import Foundation
import UIKit

extension UIPickerView{
    var ValuePickerHeight : CGFloat { get { return 250.0 } }
    
    func generateInputView() -> UIView{
        let inputView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, CGFloat(ValuePickerHeight)))
        
        inputView.addSubview(self)
        
        return inputView
    }
}