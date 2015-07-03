import Foundation
import UIKit

class MedicinePickerView : UIPickerView{
    var medicinePickerProvider: PickerProvider!
    var medicines = [String]()
    
    var view: UIView!
    
    init(view: UIView, selectCallback: (object: String) -> ()){
        super.init(frame: CGRectZero)
        
        self.view = view
        
        //Setting up medicine value picker
        var values = [String]()
        for m in Medicine.Pill.allValues {
            medicines.append(m.name())
            values.append(m.name() + " (" + (m.isWeekly() ? "Weekly" : "Daily") + ")")
        }
        
        medicinePickerProvider = PickerProvider(
            selectedCall: {(component: Int, row: Int, object: String) in
                selectCallback(object: self.medicines[row])
            }, values: values)
        
        self.delegate = medicinePickerProvider
        self.dataSource = medicinePickerProvider
    }
    
    
    override func insertedInput() -> UIView {
        return view
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}