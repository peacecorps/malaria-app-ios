import Foundation
import UIKit

class MedicinePickerViewTrip : MedicinePickerView{
    
    override init(selectCallback: (object: String) -> ()){
        super.init(selectCallback: selectCallback)
    }
    
    override func defaultMedicine() -> String{
        return TripsManager.sharedInstance.getTrip()?.medicine ?? ""
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}