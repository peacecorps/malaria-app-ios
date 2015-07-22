import Foundation
import UIKit

extension UISlider {
    @IBInspectable var yScale: CGFloat {
        get {
            return self.transform.ty
        }
        set(value) {
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, value)
        }
    }
    
    @IBInspectable var showThumbImage: Bool {
        get {
            return self.thumbImageForState(.Normal) == UIImage()
        }
        set(value) {
            if value == false {
                self.setThumbImage(UIImage(), forState: .Normal)
            }
        }
    }
    
    @IBInspectable var rightColor: UIColor? {
        get {
            return self.maximumTrackTintColor
        }
        
        set(value){
            self.maximumTrackTintColor = value
        }
    }
}
