import Foundation
import UIKit
import MapKit
import CoreLocation


class PlanTripViewController: UIViewController, CLLocationManagerDelegate {//, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let DoneButtonWidth: CGFloat = 100.0
    let DoneButtonHeight: CGFloat = 40.0
    let InputMedicineHeight: CGFloat = 200.0
    
    
    private var picker: UIPickerView!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var parkingList: UITextField!
    @IBOutlet weak var medicationList: UITextField!
    @IBOutlet weak var dayValuePicker: UITextField!
    @IBOutlet weak var monthValuePicker: UITextField!
    @IBOutlet weak var yearValuePicker: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    @IBAction func generateTrip(sender: AnyObject) {
        Logger.Info("Saving trip")
    }
    
    
    @IBAction func findMyLocation(sender: AnyObject) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                Logger.Error("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        location.text = placemark?.locality
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    @IBAction func settingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self), animated: true, completion: nil)
        }
    }
}