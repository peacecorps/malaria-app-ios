import Foundation
import UIKit

@IBDesignable extension UIView {
    /// Sets corner radius. Specify half width to make a full circle
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /// Border width
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set(value) {
            layer.borderWidth = value
        }
    }
    
    /// Border color
    @IBInspectable public var borderColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor)
        }
        
        set(value) {
            layer.borderColor = value?.CGColor
        }
    }
}