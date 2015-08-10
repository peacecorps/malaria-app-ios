import Foundation
import UIKit

/// NSNotificationCenter wrapper
public class NSNotificationEvents{
    
    /// List of events
    ///
    /// - DataUpdated: When medicine is changed or if there was a change in the entries
    /// - UIApplicationWillEnterForegroundNotification: When application enters foreground
    public enum Events : String{
        case DataUpdated = "DataUpdated"
        case UIApplicationWillEnterForegroundNotification = "UIApplicationWillEnterForegroundNotification"
    }
    
    /// Observe entered foreground events
    ///
    /// :param: `NSObject`: intended object
    /// :param: `Selector`: NSObject selector
    public static func ObserveEnteredForeground(observer: NSObject, selector: Selector){
        NSNotificationEvents.observe(Events.UIApplicationWillEnterForegroundNotification.rawValue, observer, selector)
    }
    
    
    /// Send event saying that the current medicine was changed
    ///
    /// :param: `AnyObject?`: attached object
    public static func DataUpdated(object: AnyObject?){
        NSNotificationEvents.post(Events.DataUpdated.rawValue, object)
    }
        
    /// Observe new medicine entries
    ///
    /// :param: `NSObject`: intended object
    /// :param: `Selector`: NSObject selector
    public static func ObserveDataUpdated(observer: NSObject, selector: Selector){
        NSNotificationEvents.observe(Events.DataUpdated.rawValue, observer, selector)
    }
    
    /// Stop observing all notifications
    ///
    /// :param: `NSObject`: intended object
    public static func UnregisterAll(observer: NSObject){
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