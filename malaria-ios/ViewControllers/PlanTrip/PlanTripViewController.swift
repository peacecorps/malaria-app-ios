import Foundation
import UIKit

class PlanTripViewController: UIViewController {
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var departure: UITextField!
    @IBOutlet weak var arrival: UITextField!
    @IBOutlet weak var packingList: UITextField!
    @IBOutlet weak var generateTripBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var historyTextField: UITextField!
    
    var medicinePicker: MedicinePickerViewTrip!
    var departureDatePickerview: TimePickerView!
    var arrivalDatePickerview: TimePickerView!
    var tripLocationHistoryPickerViewer : TripLocationHistoryPickerViewer!
    
    //trip information
    var tripLocation: String = ""
    var medicine: Medicine.Pill!
    var departureDay = NSDate()
    var arrivalDay = NSDate()
    var selectedItems = [String]()
    
    lazy var toolBar: UIToolbar! = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("dismissInputView:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        return keyboardToolbar
        }()
    
    var viewContext: NSManagedObjectContext!
    var tripsManager: TripsManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        location.inputAccessoryView = toolBar
        
        //Setting up departure
        departureDatePickerview = TimePickerView(view: departure, selectCallback: {(date: NSDate) in
            self.updateDeparture(date)
        })
        departure.inputAccessoryView = toolBar
        
        arrivalDatePickerview = TimePickerView(view: arrival, selectCallback: {(date: NSDate) in
            self.updateArrival(date)
        })
        arrival.inputAccessoryView = toolBar
        
        historyTextField.inputAccessoryView = toolBar
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
        
        
        tripsManager = TripsManager(context: viewContext)
        (departureDay, arrivalDay) = getStoredPlanTripDates()
        selectedItems = getStoredPlanTripItems()
        tripLocation = getStoredLocation()
        medicine = Medicine.Pill(rawValue: MedicineManager(context: viewContext).getCurrentMedicine()!.name)!
        
        updateLocation(tripLocation)
        updateItemsTextField(selectedItems)
        updateArrival(arrivalDay)
        updateDeparture(departureDay)
        
        arrival.inputView = arrivalDatePickerview.generateInputView(.Date, startDate: arrivalDay)
        departure.inputView = departureDatePickerview.generateInputView(.Date, startDate: departureDay)
        
        prepareHistoryValuePicker()
    }
    
    func prepareHistoryValuePicker(){
        tripLocationHistoryPickerViewer = TripLocationHistoryPickerViewer(context: viewContext, selectCallback: {(object: String) in
            self.updateLocation(object)
        })
        
        historyTextField.inputView = tripLocationHistoryPickerViewer.generateInputView()
    }
    
    func dismissInputView(sender: UITextField){
        location.endEditing(true)
        packingList.endEditing(true)
        arrival.endEditing(true)
        departure.endEditing(true)
        historyTextField.endEditing(true)
    }
    
    @IBAction func settingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self), animated: true, completion: nil)
        }
    }
    
    @IBAction func locationEditingChangedHandler(sender: AnyObject) {
        updateLocation(location.text)
    }
    
    @IBAction func itemListBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            let view = UIStoryboard.instantiate(viewControllerClass: ListItemsViewController.self)
            view.arrival = self.arrivalDay
            view.departure = self.departureDay
            view.listItems = self.selectedItems
            view.completitionHandler = self.selectItemsCallback
            self.presentViewController(view, animated: true, completion: nil)
        }
    }
    
    @IBAction func generateTrip(sender: AnyObject) {
        if tripsManager.getTrip() != nil {
            var refreshAlert = UIAlertController(title: "Update Trip", message: "All data will be lost.", preferredStyle: .Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: { _ in
                self.storeTrip()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else{
            self.storeTrip()
            
            var successAlert = UIAlertController(title: "Success!", message: "", preferredStyle: .Alert)
            successAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(successAlert, animated: true, completion: nil)
            
            delay(3.0) {
                successAlert.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func storeTrip(){
        let loc = location.text
        
        let trip = tripsManager.createTrip(loc, medicine: medicine, departure: departureDay, arrival:arrivalDay)
        for i in selectedItems{
            trip.itemsManager(viewContext).addItem(i, quantity: 1)
        }
        
        trip.notificationManager(viewContext).scheduleTripReminder(departureDay)
        
        self.prepareHistoryValuePicker()
    }
    
    func selectItemsCallback(medicine: Medicine.Pill, listItems: [String]){
        updateMedicine(medicine)
        updateItemsTextField(listItems)
    }
    
    @IBAction func historyButtonHandler(sender: AnyObject) {
        if tripLocationHistoryPickerViewer.locations.isEmpty {
            var successAlert = UIAlertController(title: "Empty history", message: "", preferredStyle: .Alert)
            successAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(successAlert, animated: true, completion: nil)
        }else{
            historyTextField.becomeFirstResponder()
        }
    }

}

/// local variables updaters
extension PlanTripViewController {
    func updateDeparture(date: NSDate){
        if date.startOfDay > arrivalDay.startOfDay {
            var refreshAlert = UIAlertController(title: "Error", message: "Departure day must happend before arrival.", preferredStyle: .Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else {
            departureDay = date
            departure.text = date.formatWith("dd / MM / yyyy")
        }
    }
    
    func updateArrival(date: NSDate){
        if date.startOfDay < departureDay.startOfDay {
            var refreshAlert = UIAlertController(title: "Error", message: "Arrival day must be after departure.", preferredStyle: .Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else {
            arrivalDay = date
            arrival.text = date.formatWith("dd / MM / yyyy")
        }
    }
    
    func updateLocation(loc: String){
        generateTripBtn.enabled = !loc.isEmpty
        
        tripLocation = loc
        location.text = loc
    }
    
    func updateMedicine(medicine: Medicine.Pill){
        self.medicine = medicine
    }
    
    func getStoredLocation() -> String {
        return tripsManager.getTrip()?.location ?? ""
    }
    
    func updateItemsTextField(items: [String]){
        self.selectedItems = items
        packingList.text = items.count == 0 ? "Only medicine" : "\(items.count + 1) items"
    }
    
    func getStoredPlanTripItems() -> [String] {
        return tripsManager.getTrip()?.itemsManager(viewContext).getItems().map({ $0.name }) ?? []
    }
  
    func getStoredPlanTripDates() -> (departure: NSDate, arrival: NSDate) {
        if let trip = tripsManager.getTrip() {
            return (trip.departure, trip.arrival)
        }
        
        return (NSDate(), NSDate() + 1.week)
    }
}