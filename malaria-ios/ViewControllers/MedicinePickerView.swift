import Foundation
import UIKit

class MedicinePickerView : UIPickerView{
    var medicinePickerProvider: PickerProvider!
    var medicines = [String]()
    
    init(selectCallback: (object: String) -> ()){
        super.init(frame: CGRectZero)
        
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
        
        var index = 0
        if let m = MedicineManager.sharedInstance.getCurrentMedicine(){
            index = find(Medicine.Pill.allValues, Medicine.Pill(rawValue: m.name)!) ?? 0
        }
        
        selectRow(index, inComponent: 0, animated: false)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}