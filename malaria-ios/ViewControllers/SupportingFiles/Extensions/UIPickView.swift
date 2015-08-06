import Foundation
import UIKit

extension UIPickerView{
    var ValuePickerHeight : CGFloat { get { return 250.0 } }
    
    func generateInputView() -> UIView{
        let screenWidth = UIScreen.mainScreen().bounds.width
        let inputView = UIView(frame: CGRectMake(0, 0, screenWidth, CGFloat(ValuePickerHeight)))
        
        let inputViewSize = self.frame.size.width

        //fixed bad position on iPads
        self.frame.origin.x = screenWidth*0.5 - inputViewSize*0.5
        inputView.addSubview(self)
        
        return inputView
    }
}