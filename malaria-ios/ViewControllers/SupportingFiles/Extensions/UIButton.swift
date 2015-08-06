import Foundation
import UIKit

extension UIButton {
    //44 pixels as suggested in Apple's Human Interface Guidelines
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let buttonSize = frame.size
        
        let extraWidth = max(44 - buttonSize.width, 0)
        let extraHeight = max(44 - buttonSize.height, 0)
        
        let largerFrame = CGRect(x: 0 - (extraWidth/2), y: 0 - (extraHeight/2), width: buttonSize.width + extraWidth, height: buttonSize.height + extraHeight)
        return (CGRectContainsPoint(largerFrame, point)) ? self : nil
    }
}