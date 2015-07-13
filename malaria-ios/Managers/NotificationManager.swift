import Foundation
import UIKit

public class NotificationManager : Manager{
    
    var category: String { get{ fatalError("No category provided")} }
    var alertBody: String { get{ fatalError("No alertBody provided")} }
    var alertAction: String { get{ fatalError("No alertAction provided")} }
    
    
    override init(context: NSManagedObjectContext!){
        super.init(context: context)
    }
    
    /// Schedule a notification at the fireTime given by argument
    ///
    /// All previous notifications will be unsheduled
    ///
    /// :param: `NSDate`: fireTime
    public func scheduleNotification(fireTime: NSDate){
        unsheduleNotification()
        Logger.Info("Scheduling \(category) to \(fireTime)")
        let notification: UILocalNotification = createNotification(fireTime)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    /// Unschedule all notifications
    public func unsheduleNotification(){
        Logger.Info("Unsheduling previous \(category)")
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == category{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break;
            }
        }
    }
    
    /// Creates a notification
    ///
    /// :param: `NSDate`: fireTime
    private func createNotification(fireDate: NSDate) -> UILocalNotification{
        var localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = alertAction
        localNotification.alertBody = alertBody
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = category
        
        return localNotification
    }
}