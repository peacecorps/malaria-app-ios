import Foundation
import UIKit

class PCLocationPickerViewer : UIPickerView{
    var pcLocationsPickerProvider: PickerProvider!
    var locations = [
        "Benin",
        "Botswana",
        "Burkina Faso",
        "Cameroon",
        "Ethiopia",
        "Ghana",
        "Guinea",
        "Kenya",
        "Liberia",
        "Madagascar",
        "Malawi",
        "Mozambique",
        "Namibia",
        "Rwanda",
        "Senegal",
        "Sierra Leone",
        "Tanzania",
        "The Gambia",
        "Togo",
        "Uganda",
        "Zambia"
    ]
    
    var selectedValue: String!
    
    var tripsManager: TripsManager!
    
    init(context: NSManagedObjectContext, selectCallback: (object: String) -> ()){
        super.init(frame: CGRectZero)
        tripsManager = TripsManager(context: context)
        
        pcLocationsPickerProvider = PickerProvider(
            selectedCall: {(component: Int, row: Int, object: String) in
                let result = self.locations[row]
                selectCallback(object: result)
                self.selectedValue = result
            }, values: locations)
        
        self.delegate = pcLocationsPickerProvider
        self.dataSource = pcLocationsPickerProvider
        
        let defaultLocation = defaultTripLocation()
        if defaultLocation == ""{
            selectRow(0, inComponent: 0, animated: false)
            selectedValue = locations[0]
        }else{
            let row = find(locations, defaultLocation)!
            selectRow(row, inComponent: 0, animated: false)
            selectedValue = locations[row]
        }
    }
    
    func defaultTripLocation() -> String {
        return tripsManager.getTrip()?.location ?? ""
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}