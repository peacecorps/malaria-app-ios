import Foundation
import UIKit

public class TimePickerView: UIDatePicker{
    private var selectCallback: ((date: NSDate) -> ())!
    private var DoneButtonHeight : CFloat { get { return 40.0 } }
    private var DoneButtonWidth : CFloat { get { return 100.0 } }
    private var ValuePickerHeight : CGFloat { get { return CGFloat(200) + CGFloat(DoneButtonHeight) } }
    
    /// initialization
    /// :param: `(object: String) -> ()`: on selection callback. Usually to change a view element content
    public init(selectCallback: (date: NSDate) -> ()){
        super.init(frame: CGRectZero)
        self.selectCallback = selectCallback
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Generates inputview
    /// :param: `UIDatePickerMode`: The mode of the picker
    /// :param: `NSDate`: the starting day
    /// :returns: `UIView`: the generated view
    public func generateInputView(pickerMode: UIDatePickerMode, startDate: NSDate) -> UIView{
        let screenWidth = UIScreen.mainScreen().bounds.width
        let inputView = UIView(frame: CGRectMake(0, 0, screenWidth, CGFloat(ValuePickerHeight)))
        let inputViewSize = self.frame.size.width
        
        var datePickerView = UIDatePicker(frame: CGRectMake(screenWidth*0.5 - inputViewSize*0.5, CGFloat(DoneButtonHeight), 0, 0))
        datePickerView.datePickerMode = pickerMode
        datePickerView.date = startDate
        datePickerView.addTarget(self, action: "onDateChange:", forControlEvents: .AllEvents)
        
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        return inputView
    }
    
    internal func onDateChange(sender: UIDatePicker){
        selectCallback(date: sender.date)
    }
}