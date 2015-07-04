import Foundation
import UIKit
import MapKit
import CoreLocation


class PlanTripViewController: UIViewController, CLLocationManagerDelegate {//, UIPickerViewDelegate, UIPickerViewDataSource{
    let locationManager = CLLocationManager()
    
    var pcLocationPicker: PCLocationPickerViewer!
    var medicinePicker: MedicinePickerView!
    var dayDatePickerview: TimePickerView!
    var monthDatePickerview: TimePickerView!
    var yearDatePickerview: TimePickerView!
    
    var tripReminderDate: NSDate!
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var parkingList: UITextField!
    @IBOutlet weak var medicationList: UITextField!
    @IBOutlet weak var dayValuePicker: UITextField!
    @IBOutlet weak var monthValuePicker: UITextField!
    @IBOutlet weak var yearValuePicker: UITextField!
    @IBOutlet weak var cashToBring: UITextField!
    
    
    lazy var toolBar: UIToolbar! = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("dismissInputView:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        return keyboardToolbar
        }()
    
    func dismissInputView(sender: UITextField){
        location.endEditing(true)
        parkingList.endEditing(true)
        medicationList.endEditing(true)
        dayValuePicker.endEditing(true)
        monthValuePicker.endEditing(true)
        yearValuePicker.endEditing(true)
        cashToBring.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        tripReminderDate = getStoredPlanTripNotificationDate()
        
        pcLocationPicker = PCLocationPickerViewer(selectCallback: {(object: String) in
            self.location.text = object
        })
        location.inputView = pcLocationPicker.generateInputView()
        location.inputAccessoryView = toolBar
        
        //Setting up medicinePickerView with default Value
        medicinePicker = MedicinePickerView(selectCallback: {(object: String) in
            self.medicationList.text = object
        })
        medicationList.inputView = medicinePicker.generateInputView()
        medicationList.inputAccessoryView = toolBar
        
        //Setting up dayDatePickerview
        dayDatePickerview = TimePickerView(view: dayValuePicker, selectCallback: {(date: NSDate) in
            self.tripReminderDate = date
            self.refresh()
        })
        dayValuePicker.inputView = dayDatePickerview.generateInputView(.Date, startDate: getStoredPlanTripNotificationDate())
        dayValuePicker.inputAccessoryView = toolBar
        
        
        //Setting up monthDatePickerview
        monthDatePickerview = TimePickerView(view: monthValuePicker, selectCallback: {(date: NSDate) in
            self.tripReminderDate = date
            self.refresh()
        })
        monthValuePicker.inputView = monthDatePickerview.generateInputView(.Date, startDate: getStoredPlanTripNotificationDate())
        monthValuePicker.inputAccessoryView = toolBar
        
        //Setting up yearDatePickerview
        yearDatePickerview = TimePickerView(view: yearValuePicker, selectCallback: {(date: NSDate) in
            self.tripReminderDate = date
            self.refresh()
        })
        yearValuePicker.inputView = yearDatePickerview.generateInputView(.Date, startDate: getStoredPlanTripNotificationDate())
        yearValuePicker.inputAccessoryView = toolBar
        
        
        cashToBring.inputAccessoryView = toolBar
        
        refresh()
    }
    
    func getStoredPlanTripNotificationDate() -> NSDate {
        return TripsManager.sharedInstance.getTrip()?.reminderDate ?? NSDate()
    }
    
    func getStoredPlanTripLocation() -> String {
        return TripsManager.sharedInstance.getTrip()?.location ?? ""
    }
    
    func getStoredPlanTripMedicine() -> String {
        return TripsManager.sharedInstance.getTrip()?.medicine ?? medicinePicker.medicines[0]
    }
    
    func getStoredPlanTripCashToBring() -> Int64{
        return TripsManager.sharedInstance.getTrip()?.cashToBring ?? 0
    }
    
    func refresh(){
        location.text = getStoredPlanTripLocation()
        medicationList.text = getStoredPlanTripMedicine()
        cashToBring.text = "\(getStoredPlanTripCashToBring())"
        
        dayValuePicker.text = tripReminderDate.formatWith("dd")
        monthValuePicker.text = tripReminderDate.formatWith("MM")
        yearValuePicker.text = tripReminderDate.formatWith("yyyy")
    }
    
    @IBAction func generateTrip(sender: AnyObject) {
        Logger.Info("Saving trip")
        
        if TripsManager.sharedInstance.getTrip() != nil {
            var refreshAlert = UIAlertController(title: "Update Trip", message: "All data will be lost.", preferredStyle: .Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.overwriteTrip()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        
        TripsManager.sharedInstance.createTrip(location.text, medicine: Medicine.Pill(rawValue: medicationList.text)!, cashToBring: 100, reminderDate: tripReminderDate)
    }
    
    func overwriteTrip(){
        TripsManager.sharedInstance.clearCoreData()
        TripsManager.sharedInstance.createTrip(location.text, medicine: Medicine.Pill(rawValue: medicationList.text)!, cashToBring: 100, reminderDate: tripReminderDate)
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
                //stop updating location to save battery life
                self.locationManager.stopUpdatingLocation()
                self.location.text = pm.locality
            } else {
                println("Problem with the data received from geocoder")
            }
        })
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