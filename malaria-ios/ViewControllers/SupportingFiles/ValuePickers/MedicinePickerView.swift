import Foundation
import UIKit

class MedicinePickerView : UIPickerView{
    var medicinePickerProvider: PickerProvider!
    var medicines = [String]()
    var selectedValue = ""
    
    var medicineManager: MedicineManager!
    
    /// initialization
    /// :param: `NSManagedObjectContext`: current context
    /// :param: `(object: String) -> ()`: on selection callback. Usually to change a view element content
    init(context: NSManagedObjectContext, selectCallback: (object: String) -> ()){
        medicineManager = MedicineManager(context: context)
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
    
    /// returns the default medicine. If there is nothing configured, returns empty string
    /// :returns: `String`
    func defaultMedicine() -> String{
        return medicineManager.getCurrentMedicine()?.name ?? ""
    }
    
    /// generates a string for the medicine by following the rule:
    /// name + (weekly if interval is 7) OR (daily if interval is 1)
    /// :returns: `String`: generated string
    func generateMedicineString(medicine: Medicine.Pill) -> String{
        return medicine.name() + " (" + (medicine.interval() == 7 ? "Weekly" : "Daily") + ")"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}