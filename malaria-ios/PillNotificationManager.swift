import Foundation
import UIKit

enum Pill : String{
    case Doxycycline = "Doxycycline"
    case Malarone = "Malarone"
    case Mefloquine = "Mefloquine"
    
    func repeatInterval() -> NSCalendarUnit{
        if self == Pill.Mefloquine {
            return NSCalendarUnit.CalendarUnitWeekday
        }
        
        return NSCalendarUnit.CalendarUnitDay
    }
}

class PillNotificationManager{
    let PillReminderCategory = "PillReminder"
    
    func registerPill(pill: Pill, fireTime: NSDate){
        let notification: UILocalNotification = createNotification(pill.rawValue, fireDate: fireTime, frequency: pill.repeatInterval())
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func unregister(){
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == PillReminderCategory{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break;
            }
        }
    }

    private func createNotification(medicine: String, fireDate: NSDate, frequency: NSCalendarUnit) -> UILocalNotification{
        var localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = "Did you took the pill?"
        localNotification.alertBody = "\(medicine): Take me take me!"
        localNotification.alertAction = "Open"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = PillReminderCategory
        localNotification.repeatInterval = frequency
        
        return localNotification
    }
}