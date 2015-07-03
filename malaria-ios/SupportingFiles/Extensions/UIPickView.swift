import Foundation
import UIKit

extension UIPickerView{
    var DoneButtonHeight : CFloat { get { return 40.0 } }
    var DoneButtonWidth : CFloat { get { return 100.0 } }
    var ValuePickerHeight : CGFloat { get { return 200.0 } }
    
    func insertedInput() -> UIView{
        fatalError("If generating view, please override inserting view")
    }
    
    func generateInputView() -> UIView{
        let inputView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, CGFloat(ValuePickerHeight) + CGFloat(DoneButtonHeight)))
        
        inputView.addSubview(self)
        inputView.addSubview(generateDoneButtonView())
        
        return inputView
    }
    
    private func generateDoneButtonView() -> UIView {
        //bug in ios, have to call CGFLoat twice despite being already defined as CGFloat...
        let frame = CGRectMake(CGFloat(UIScreen.mainScreen().bounds.width) - CGFloat(DoneButtonWidth), 0, CGFloat(DoneButtonWidth), CGFloat(DoneButtonHeight))
        
        let doneButton = UIButton(frame: frame)
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitle("Done", forState: .Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        doneButton.addTarget(self, action: "dismissInputView:", forControlEvents: .TouchUpInside) // set button click event
        
        return doneButton
    }
    
    func dismissInputView(sender: UIPickerView){
        insertedInput().endEditing(true)
    }
}