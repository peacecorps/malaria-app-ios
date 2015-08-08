import Foundation
import UIKit

public class TimePickerView: UIDatePicker{
    private var selectCallback: ((date: NSDate) -> ())!
    /// initialization
    /// :param: `UIDatePickerMode`: picker mode .Date or .Time
    /// :param: `NSDate`: start date
    /// :param: `(object: String) -> ()`: on selection callback. Usually to change a view element content
    public init(pickerMode: UIDatePickerMode, startDate: NSDate, selectCallback: (date: NSDate) -> ()){
        super.init(frame: CGRectZero)
        self.selectCallback = selectCallback
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let inputViewWidth = self.frame.size.width
        
        self.frame = CGRectMake(screenWidth*0.5 - inputViewWidth*0.5, 0, 0, 0)
        self.datePickerMode = pickerMode
        self.date = startDate
        self.addTarget(self, action: "onDateChange:", forControlEvents: .AllEvents)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func onDateChange(sender: UIDatePicker){
        selectCallback(date: sender.date)
    }
}