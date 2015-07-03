import Foundation
import UIKit

class PickerProvider: NSObject, UIPickerViewDataSource,UIPickerViewDelegate
{
    var possibleValues: [String]
    var callback: (component: Int, row: Int, value: String) -> ()
    
    init(selectedCall:(component: Int, row: Int, value: String)->(), values: [String])
    {
        possibleValues = values
        callback = selectedCall
    }
    
    func pickerView(pickerview: UIPickerView,numberOfRowsInComponent component: Int) -> Int
    {
        return possibleValues.count;
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String
    {
        return possibleValues[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        callback(component: component, row: row, value: possibleValues[row]);
    }
}