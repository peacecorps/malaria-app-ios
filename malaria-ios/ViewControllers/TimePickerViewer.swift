import Foundation
import UIKit

class TimePickerView: UIDatePicker{
    var view: UIView!
    var selectCallback: ((date: NSDate) -> ())!
    var DoneButtonHeight : CFloat { get { return 40.0 } }
    var DoneButtonWidth : CFloat { get { return 100.0 } }
    var ValuePickerHeight : CGFloat { get { return CGFloat(200) + CGFloat(DoneButtonHeight) } }
    
    
    init(view: UIView, selectCallback: (date: NSDate) -> ()){
        super.init(frame: CGRectZero)
        self.view = view
        self.selectCallback = selectCallback
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func generateInputView(pickerMode: UIDatePickerMode, startDate: NSDate) -> UIView{
        let inputView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, ValuePickerHeight))
        
        var datePickerView = UIDatePicker(frame: CGRectMake(0, CGFloat(DoneButtonHeight), 0, 0))
        datePickerView.datePickerMode = pickerMode
        datePickerView.date = startDate
        datePickerView.addTarget(self, action: "onDateChange:", forControlEvents: .AllEvents)
        
        inputView.addSubview(datePickerView) // add date picker to UIView
        inputView.addSubview(generateDoneButtonView())
        
        return inputView
    }
    
    private func generateDoneButtonView() -> UIView{
        //bug in ios, have to call CGFLoat twice despite being already defined as CGFloat...
        let frame = CGRectMake(CGFloat(UIScreen.mainScreen().bounds.width) - CGFloat(DoneButtonWidth), 0, CGFloat(DoneButtonWidth), CGFloat(DoneButtonHeight))
        
        let doneButton = UIButton(frame: frame)
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        doneButton.addTarget(self, action: "dismissInputView:", forControlEvents: .TouchUpInside) // set button click event
        
        return doneButton
    }
    
    func dismissInputView(sender: UIButton){
        view.resignFirstResponder()
    }
    
    func onDateChange(sender: UIDatePicker){
        selectCallback(date: sender.date)
    }
}