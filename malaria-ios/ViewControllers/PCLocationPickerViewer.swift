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
    
    init(selectCallback: (object: String) -> ()){
        super.init(frame: CGRectZero)
        
        pcLocationsPickerProvider = PickerProvider(
            selectedCall: {(component: Int, row: Int, object: String) in
                selectCallback(object: self.locations[row])
            }, values: locations)
        
        self.delegate = pcLocationsPickerProvider
        self.dataSource = pcLocationsPickerProvider
        
        
        var index = 0
        if let t = TripsManager.sharedInstance.getTrip(){
            index = find(locations, t.location) ?? 0
        }
        
        selectRow(index, inComponent: 0, animated: false)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}