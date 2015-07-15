import Foundation
import UIKit

class MedicinePickerViewTrip : MedicinePickerView{

    var tripsManager: TripsManager!
    
    override init(context: NSManagedObjectContext, selectCallback: (object: String) -> ()){
        tripsManager = TripsManager(context: context)
        super.init(context: context, selectCallback: selectCallback)
    }
    
    override func defaultMedicine() -> String{
        return tripsManager.getTrip()?.medicine ?? ""
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}