import Foundation
import UIKit

class NSNotificationEvents{
    enum Events : String{
        case ChangedEntries = "ChangedEntries"
        case UIApplicationWillEnterForegroundNotification = "UIApplicationWillEnterForegroundNotification"
    }
    
    static func ObserveEnteredForeground(observer: NSObject, selector: Selector){
        NSNotificationEvents.observe(Events.UIApplicationWillEnterForegroundNotification.rawValue, observer, selector)

    }
    
    static func DataUpdated(object: AnyObject?){
        NSNotificationEvents.post(Events.ChangedEntries.rawValue, object)
    }
    
    static func ObserveNewEntries(observer: NSObject, selector: Selector){
        NSNotificationEvents.observe(Events.ChangedEntries.rawValue, observer, selector)
    }
    
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