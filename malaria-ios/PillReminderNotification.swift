import Foundation
import UIKit

class PillRemainderNotification{
    
    class func create(medicine: String, fireDate: NSDate) -> UILocalNotification{
        var localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = "Did you took the pill?"
        localNotification.alertBody = "\(medicine): Take me take me!"
        localNotification.alertAction = "Open"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = "PillRemainderCategory"
        localNotification.repeatInterval = NSCalendarUnit.CalendarUnitDay
        
        return localNotification
    }
}

