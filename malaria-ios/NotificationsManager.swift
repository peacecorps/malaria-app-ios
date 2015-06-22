import Foundation
import UIKit

class NotificationsManager{
    var medicine: Medicine!
    
    init(medicine: Medicine){
        self.medicine = medicine
    }
    
    
    let PillReminderCategory = "PillReminder"
    
    func scheduleNotification(fireTime: NSDate){
        unsheduleNotification()
        
        let notification: UILocalNotification = createNotification(fireTime)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        medicine.notificationTime = fireTime
    }
    
    func unsheduleNotification(){
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == PillReminderCategory{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break;
            }
        }
        
        medicine.notificationTime = nil
        CoreDataHelper.sharedInstance.saveContext()
    }

    func reshedule(){
        if var nextTime = medicine.notificationTime{
            nextTime += medicine.isDaily() ? 1.day : 7.day
            medicine.notificationTime = nextTime
        }
        
        if medicine.isCurrent{
            Logger.Error("Error: there should be already a fire date")
        }
    }
    

    //returns the number of supposed pills should have been taken
    private func createNotification(fireDate: NSDate) -> UILocalNotification{
        var localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = "Did you took the pill?"
        localNotification.alertBody = "\(medicine.name): Take me take me!"
        localNotification.alertAction = "Open"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = PillReminderCategory
        
        return localNotification
    }
    
    /*
    If the user fails to take their medication mid-way through a week, and a full 7 days goes by without the medication being recorded, on DayX+7 the system will start again and allow the user to enter new data for that week. So if the user is supposed to take medications on Mondays, and next Monday arrives with no data entry, the day and date at the top will go back to black text, and the system will now record data for that new week and consider the previous week a missed week.
    */
    func checkIfShouldReset(currentDate: NSDate) -> Bool{
        if let mostRecent = medicine.registriesManager.mostRecentEntry(){
            let numberDays: Int = NSDate.numberDaysBetween(mostRecent, date2: currentDate)
            return numberDays > 7
        }
        
        Logger.Warn("There is no registry yet registred")
        return false
    }
}