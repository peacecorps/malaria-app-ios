import Foundation
import UIKit

class NSNotificationEvents{
    enum Events : String{
        case ChangedEntries = "ChangedEntries"
        case UIApplicationWillEnterForegroundNotification = "UIApplicationWillEnterForegroundNotification"
    }
    
    /// Observe entered foreground events
    /// :param: `NSObject`: intended object
    /// :param: `Selector`: NSObject selector
    static func ObserveEnteredForeground(observer: NSObject, selector: Selector){
        NSNotificationEvents.observe(Events.UIApplicationWillEnterForegroundNotification.rawValue, observer, selector)
    }
    
    /// Send event saying that the medicine data was updated
    /// :param: `AnyObject?`: attached object
    static func DataUpdated(object: AnyObject?){
        NSNotificationEvents.post(Events.ChangedEntries.rawValue, object)
    }
    
    /// Observe new medicine entries
    /// :param: `NSObject`: intended object
    /// :param: `Selector`: NSObject selector
    static func ObserveNewEntries(observer: NSObject, selector: Selector){
        NSNotificationEvents.observe(Events.ChangedEntries.rawValue, observer, selector)
    }
    
    /// Stop observing all notifications
    /// :param: `NSObject`: intended object
    static func UnregisterAll(observer: NSObject){
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    private static func post(name: String, _ object: AnyObject?){
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: object)
    }
    
    private static func observe(name: String, _ observer: NSObject, _ selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer,
            selector: selector,
            name: name,
            object: nil)
    }
}