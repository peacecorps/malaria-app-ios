import Foundation
import UIKit

class MedicinePickerViewTrip : MedicinePickerView{

    var tripsManager: TripsManager!
    
    /// initialization
    /// :param: `NSManagedObjectContext`: current context
    /// :param: `(object: String) -> ()`: on selection callback. Usually to change a view element content
    override init(context: NSManagedObjectContext, selectCallback: (object: String) -> ()){
        tripsManager = TripsManager(context: context)
        super.init(context: context, selectCallback: selectCallback)
    }
    
    /// Returns default medicine for the trip. If there is no trip configured returns empty string.
    /// :returns: `String`: medicine for the stored trip
    override func defaultMedicine() -> String{
        return tripsManager.getTrip()?.medicine ?? ""
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}