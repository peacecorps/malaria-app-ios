import Foundation
import UIKit

extension UITabBarItem {
    /// image when selected. The another similar field in the storyboard doesn't work
    @IBInspectable public var imageWhenSelected: UIImage {
        get {
            return self.selectedImage!
        }
        
        set(image) {
            self.selectedImage = image
        }
    }
}