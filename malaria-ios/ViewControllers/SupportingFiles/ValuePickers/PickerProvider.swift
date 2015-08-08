import Foundation
import UIKit

public class PickerProvider: NSObject{
    public var possibleValues: [String]
    private let callback: (component: Int, row: Int, value: String) -> ()
    
    /// initializing
    /// :param: `(component: Int, row: Int, value: String) -> ()`: selection call back
    /// :param: `[String]`: array of possible values
    public init(selectedCall: (component: Int, row: Int, value: String)->(), values: [String]) {
        possibleValues = values
        callback = selectedCall
    }
}

extension PickerProvider : UIPickerViewDataSource, UIPickerViewDelegate  {
    public func pickerView(pickerview: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return possibleValues.count;
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return possibleValues[row];
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        callback(component: component, row: row, value: possibleValues[row]);
    }
}