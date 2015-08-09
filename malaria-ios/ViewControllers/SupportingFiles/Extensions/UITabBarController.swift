import Foundation
import UIKit

@IBDesignable extension UITabBarController {

    @IBInspectable public var showBar: Bool {
        get {
            fatalError("Never meant to be called")
        }
        
        set(value) {
            if(!value) {
                UITabBar.appearance().barTintColor = UIColor.clearColor()
                UITabBar.appearance().backgroundImage = UIImage()
                UITabBar.appearance().shadowImage = UIImage()
            }
        }
    }
}