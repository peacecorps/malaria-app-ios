import Foundation
import UIKit

extension UIColor {
    /// Init
    /// - parameter `UInt`:: hex. eg. 0x666666
    public convenience init(hex: UInt){
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}