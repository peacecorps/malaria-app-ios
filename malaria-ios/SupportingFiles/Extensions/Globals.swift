import Foundation
import UIKit

/// runs the function given by argument in main_queue after the specified seconds
/// :param: `Double`: time in seconds
public func delay(seconds: Double, function: () -> ()){
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), function)
}

/// Opens the url
/// :param: `NSURL`: url
/// :returns: `Bool`: true if success, false if not
public func openUrl(url: NSURL!) -> Bool{
    if !UIApplication.sharedApplication().canOpenURL(url) {
        Logger.Error("Can't open Url \(url)")
        return false
    }
    UIApplication.sharedApplication().openURL(url)
    return true
}