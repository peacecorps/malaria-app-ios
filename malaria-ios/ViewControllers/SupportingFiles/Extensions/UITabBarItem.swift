import Foundation
import UIKit

extension UITabBarItem {
    @IBInspectable public var imageWhenSelected: UIImage {
        get {
            return self.selectedImage
        }
        
        set(image) {
            self.selectedImage = image
        }
    }
}