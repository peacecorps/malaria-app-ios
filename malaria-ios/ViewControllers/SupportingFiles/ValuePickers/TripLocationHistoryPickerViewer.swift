import Foundation
import UIKit
import PickerSwift

/// Trip location picker viewer
public class TripLocationHistoryPickerViewer : UIPickerView{
    private var pcLocationsPickerProvider: PickerProvider!
    /// Locations
    public var locations = [String]()
    
    /// Selected value
    public var selectedValue = ""
    
    private var tripsManager: TripsManager!
    
    /// Initialization
    ///
    /// :param: `NSManagedObjectContext`: current context
    /// :param: `(object: String) -> ()`: on selection callback. Usually to change a view element content
    public init(context: NSManagedObjectContext, selectCallback: (object: String) -> ()){
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
    
    private func defaultTripLocation() -> String {
        return locations[0]
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}