import Foundation
import UIKit

class MedicinePickerView : UIPickerView{
    var medicinePickerProvider: PickerProvider!
    var medicines = [String]()
    var selectedValue: String!
    
    init(selectCallback: (object: String) -> ()){
        super.init(frame: CGRectZero)
        
        //Setting up medicine value picker
        var values = [String]()
        for m in Medicine.Pill.allValues {
            medicines.append(m.name())
            values.append(generateMedicineString(m))
        }
        
        medicinePickerProvider = PickerProvider(
            selectedCall: {(component: Int, row: Int, object: String) in
                let result = self.medicines[row]
                selectCallback(object: result)
                self.selectedValue = result
            }, values: values)
        
        self.delegate = medicinePickerProvider
        self.dataSource = medicinePickerProvider
        
        
        let defaultMedicineName = defaultMedicine()
        if defaultMedicineName == ""{
            selectRow(0, inComponent: 0, animated: false)
            selectedValue = medicines[0]
        }else{
            let row = find(Medicine.Pill.allValues, Medicine.Pill(rawValue: defaultMedicineName)!)!
            selectRow(row, inComponent: 0, animated: false)
            selectedValue = medicines[row]
        }
    }
    
    func defaultMedicine() -> String{
        return MedicineManager.sharedInstance.getCurrentMedicine()?.name ?? ""
    }
    
    func generateMedicineString(medicine: Medicine.Pill) -> String{
        return medicine.name() + " (" + (medicine.isWeekly() ? "Weekly" : "Daily") + ")"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}