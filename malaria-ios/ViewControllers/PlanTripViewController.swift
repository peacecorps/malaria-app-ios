import Foundation
import UIKit
import MapKit
import CoreLocation


class PlanTripViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    var pcLocationPicker: PCLocationPickerViewer!
    var medicinePicker: MedicinePickerViewTrip!
    var dayDatePickerview: TimePickerView!
    var monthDatePickerview: TimePickerView!
    var yearDatePickerview: TimePickerView!
    
    var tripReminderDate: NSDate!
    var selectedItems = [String]()
    
    
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
    
    let viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
    
    var tripsManager: TripsManager!
    
    func dismissInputView(sender: UITextField){
        location.endEditing(true)
        parkingList.endEditing(true)
        medicationList.endEditing(true)
        dayValuePicker.endEditing(true)
        monthValuePicker.endEditing(true)
        yearValuePicker.endEditing(true)
        cashToBring.endEditing(true)
    }
    
    @IBAction func itemListBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            let view = UIStoryboard.instantiate(viewControllerClass: ListItemsViewController.self)
            view.initialItems = self.selectedItems
            view.completitionHandler = self.selectItemsCallback
            self.presentViewController(view, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        tripsManager = TripsManager(context: viewContext)
        
        tripReminderDate = getStoredPlanTripNotificationDate()
        selectedItems = getStoredPlanTripItems()
        
        pcLocationPicker = PCLocationPickerViewer(context: viewContext, selectCallback: {(object: String) in
            self.location.text = object
        })
        location.inputView = pcLocationPicker.generateInputView()
        location.inputAccessoryView = toolBar
        
        //Setting up medicinePickerView with default Value
        medicinePicker = MedicinePickerViewTrip(context: viewContext, selectCallback: {(object: String) in
            self.medicationList.text = object
        })
        medicationList.inputView = medicinePicker.generateInputView()
        medicationList.inputAccessoryView = toolBar
        
        //Setting up dayDatePickerview
        dayDatePickerview = TimePickerView(view: dayValuePicker, selectCallback: {(date: NSDate) in
            self.tripReminderDate = date
            self.updateDateTextFields(date)
        })
        dayValuePicker.inputView = dayDatePickerview.generateInputView(.Date, startDate: getStoredPlanTripNotificationDate())
        dayValuePicker.inputAccessoryView = toolBar
        
        
        //Setting up monthDatePickerview
        monthDatePickerview = TimePickerView(view: monthValuePicker, selectCallback: {(date: NSDate) in
            self.tripReminderDate = date
            self.updateDateTextFields(date)
        })
        monthValuePicker.inputView = monthDatePickerview.generateInputView(.Date, startDate: getStoredPlanTripNotificationDate())
        monthValuePicker.inputAccessoryView = toolBar
        
        //Setting up yearDatePickerview
        yearDatePickerview = TimePickerView(view: yearValuePicker, selectCallback: {(date: NSDate) in
            self.tripReminderDate = date
            self.updateDateTextFields(date)
        })
        yearValuePicker.inputView = yearDatePickerview.generateInputView(.Date, startDate: getStoredPlanTripNotificationDate())
        yearValuePicker.inputAccessoryView = toolBar
        
        
        cashToBring.inputAccessoryView = toolBar
        
        location.text = pcLocationPicker.selectedValue
        medicationList.text = medicinePicker.selectedValue
        
        cashToBring.text = "\(getStoredPlanTripCashToBring())"
        updateDateTextFields(tripReminderDate)
        updateItemsTextField(selectedItems)
    }
    
    func updateDateTextFields(date: NSDate){
        dayValuePicker.text = date.formatWith("dd")
        monthValuePicker.text = date.formatWith("MM")
        yearValuePicker.text = date.formatWith("yyyy")
    }
    
    func updateItemsTextField(items: [String]){
        parkingList.text = "\(items.count) items"
    }
    
    func getStoredPlanTripItems() -> [String] {
        var result = [String]()
        if let t = tripsManager.getTrip(){
            for i in t.itemsManager(viewContext).getItems(){
                result.append(i.name)
            }
        }
        return result
    }
    
    func getStoredPlanTripNotificationDate() -> NSDate {
        return tripsManager.getTrip()?.reminderDate ?? NSDate()
    }
    
    func getStoredPlanTripCashToBring() -> Int64{
        return tripsManager.getTrip()?.cashToBring ?? 0
    }
    
    @IBAction func generateTrip(sender: AnyObject) {
        if tripsManager.getTrip() != nil {
            var refreshAlert = UIAlertController(title: "Update Trip", message: "All data will be lost.", preferredStyle: .Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: { (action: UIAlertAction!) in
                self.storeTrip()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else{
            self.storeTrip()
        }
    }
    
    func storeTrip(){
        let loc = location.text
        let medication = Medicine.Pill(rawValue: medicationList.text)!
        let cash = Int64(cashToBring.text.toInt()!)
        
        Logger.Info("Inserting new trip with:")
        Logger.Info(location)
        Logger.Info(medicationList)
        Logger.Info(cash)
        Logger.Info(tripReminderDate.formatWith("dd-MM-yyyy"))
        
        let trip = tripsManager.createTrip(loc, medicine: medication, cashToBring: cash, reminderDate: tripReminderDate)
        for i in selectedItems{
            trip.itemsManager(viewContext).addItem(i, quantity: 1)
        }
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
    
    func selectItemsCallback(listItems: [String]){
        selectedItems = listItems
        updateItemsTextField(listItems)
    }
}