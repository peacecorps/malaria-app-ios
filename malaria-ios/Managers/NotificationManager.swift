import Foundation
import UIKit

public class NotificationManager : CoreDataContextManager{
    public var category: String { get{ fatalError("No category provided")} }
    public var alertBody: String { get{ fatalError("No alertBody provided")} }
    public var alertAction: String { get{ fatalError("No alertAction provided")} }
    
    override public init(context: NSManagedObjectContext!){
        super.init(context: context)
    }
    
    /// Schedule a notification at the fireTime given by argument
    ///
    /// All previous notifications will be unsheduled
    ///
    /// :param: `NSDate`: fireTime
    public func scheduleNotification(fireTime: NSDate){
        Logger.Info("Sheduling \(category) to " + fireTime.formatWith("dd-MMMM-yyyy hh:mm"))
        let notification: UILocalNotification = createNotification(fireTime)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    /// Unschedule all notifications with the category
    public func unsheduleNotification(){
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            let notification = event as! UILocalNotification
            if notification.category == category {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
    
    /// Creates a notification
    ///
    /// :param: `NSDate`: fireTime
    /// :returns: `UILocalNotification`: local notification
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