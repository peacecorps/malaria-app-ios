import Foundation
import UIKit

class MedicineNotificationManager{
    static let sharedInstance = MedicineNotificationManager()
    
    let PillReminderCategory = "PillReminder"
    
    func scheduleNotification(medicine: Medicine.Pill, fireTime: NSDate){
        unsheduleNotification()
        
        let notification: UILocalNotification = createNotification(medicine.name(), fireDate: fireTime)
        //UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func unsheduleNotification(){
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == PillReminderCategory{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break;
            }
        }
    }
    
    func getFireDate() -> NSDate?{
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == PillReminderCategory{
                return notification.fireDate
            }
        }
        
        return nil
    }
    
    
/*
    If the user fails to take their medication mid-way through a week, and a full 7 days goes by without the medication being recorded, on DayX+7 the system will start again and allow the user to enter new data for that week. So if the user is supposed to take medications on Mondays, and next Monday arrives with no data entry, the day and date at the top will go back to black text, and the system will now record data for that new week and consider the previous week a missed week.
*/

    func reshedule(medicine: Medicine) -> NSDate?{
        
        if var currentDate = getFireDate(){
            
            
            currentDate += medicine.isDaily() ? 1.day : 7.day
            return currentDate
        }
        
        Logger.Error("Error: there should be already a fire date")
        return nil
    }
    

    //returns the number of supposed pills should have been taken
    private func createNotification(medicine: String, fireDate: NSDate) -> UILocalNotification{
        var localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = "Did you took the pill?"
        localNotification.alertBody = "\(medicine): Take me take me!"
        localNotification.alertAction = "Open"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = PillReminderCategory
        
        return localNotification
    }
}