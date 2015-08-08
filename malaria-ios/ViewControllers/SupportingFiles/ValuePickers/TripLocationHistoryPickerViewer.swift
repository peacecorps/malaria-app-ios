import Foundation
import UIKit
import PickerSwift

class TripLocationHistoryPickerViewer : UIPickerView{
    internal var pcLocationsPickerProvider: PickerProvider!
    internal var locations = [String]()
    
    var selectedValue = ""
    
    var tripsManager: TripsManager!
    
    /// initialization
    /// :param: `NSManagedObjectContext`: current context
    /// :param: `(object: String) -> ()`: on selection callback. Usually to change a view element content
    init(context: NSManagedObjectContext, selectCallback: (object: String) -> ()){
        super.init(frame: CGRectZero)
        tripsManager = TripsManager(context: context)
        
        locations = tripsManager.getHistory().map({$0.location})
        
        pcLocationsPickerProvider = PickerProvider(selectedCall: {(component: Int, row: Int, object: String) in
                let result = self.locations[row]
                selectCallback(object: result)
                self.selectedValue = result
        }, values: locations)
        
        self.delegate = pcLocationsPickerProvider
        self.dataSource = pcLocationsPickerProvider
    }
    
    func defaultTripLocation() -> String {
        return locations[0]
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}