import Foundation
import UIKit

@IBDesignable extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set(value) {
            layer.borderWidth = value
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor)
        }
        
        set(value) {
            layer.borderColor = value?.CGColor
        }
    }
}