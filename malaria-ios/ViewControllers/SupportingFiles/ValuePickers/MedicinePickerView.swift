import Foundation
import UIKit
import PickerSwift

/// Medicine Picker View, containing all possible medicines and by default is the on selected by the user in the setup
/// screen
public class MedicinePickerView : UIPickerView{
    private var medicinePickerProvider: PickerProvider!
    private var medicines = [String]()
    
    /// Selected value
    public var selectedValue = ""
    
    private var medicineManager: MedicineManager!
    
    /// Initialization
    ///
    /// - parameter `NSManagedObjectContext`:: current context
    /// - parameter `(object:: String) -> ()`: on selection callback. Usually to change a view element content
    public init(context: NSManagedObjectContext, selectCallback: (object: String) -> ()){
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
            let row = Medicine.Pill.allValues.indexOf(Medicine.Pill(rawValue: defaultMedicineName)!)!
            selectRow(row, inComponent: 0, animated: false)
            selectedValue = medicines[row]
        }
    }
    
    /// Returns the default medicine. If there is nothing configured, returns empty string
    ///
    /// - returns: `String`
    private func defaultMedicine() -> String{
        return medicineManager.getCurrentMedicine()?.name ?? ""
    }
    
    /// Generates a string for the medicine by following the rule:
    /// name + (weekly if interval is 7) OR (daily if interval is 1)
    ///
    /// - returns: `String`: generated string
    private func generateMedicineString(medicine: Medicine.Pill) -> String{
        return medicine.name() + " (" + (medicine.interval() == 7 ? "Weekly" : "Daily") + ")"
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}