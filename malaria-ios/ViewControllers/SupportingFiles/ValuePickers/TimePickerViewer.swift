import Foundation
import UIKit

class TimePickerView: UIDatePicker{
    var selectCallback: ((date: NSDate) -> ())!
    var DoneButtonHeight : CFloat { get { return 40.0 } }
    var DoneButtonWidth : CFloat { get { return 100.0 } }
    var ValuePickerHeight : CGFloat { get { return CGFloat(200) + CGFloat(DoneButtonHeight) } }
    
    init(view: UIView, selectCallback: (date: NSDate) -> ()){
        super.init(frame: CGRectZero)
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
        
        return inputView
    }
    
    func onDateChange(sender: UIDatePicker){
        selectCallback(date: sender.date)
    }
}