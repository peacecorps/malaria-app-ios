import Foundation
import UIKit

extension UITabBarItem {
    @IBInspectable var imageWhenSelected: UIImage {
        get {
            return self.selectedImage
        }
        
        set(image) {
            self.selectedImage = image
        }
    }
}