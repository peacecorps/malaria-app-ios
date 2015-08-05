import Foundation
import UIKit

@IBDesignable class HorizontalGraphBar : UIView {
    
    @IBInspectable var progressValue: Float = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var progressColor: UIColor = UIColor.redColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let progressWidth = rect.size.width * CGFloat(progressValue/100)
        
        let leftPart = CGRectMake(rect.origin.x, rect.origin.y, progressWidth, rect.size.height)
        let rightPart = CGRectMake(rect.origin.x + progressWidth, rect.origin.y, rect.size.width - progressWidth, rect.size.height)
        
        progressColor.set()
        UIRectFill(leftPart)
        
        backgroundColor?.set()
        UIRectFill(rightPart)
    }
}