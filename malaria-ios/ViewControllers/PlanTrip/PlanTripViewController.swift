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

    @IBInspectable var textFieldsDateFormat: String = "dd / MM / yyyy"
    
    //input fields
    private var medicinePicker: MedicinePickerViewTrip!
    private var departureDatePickerview: TimePickerView!
    private var arrivalDatePickerview: TimePickerView!
    private var tripLocationHistoryPickerViewer : TripLocationHistoryPickerViewer!
    
    //context and manager
    private var viewContext: NSManagedObjectContext!
    private var tripsManager: TripsManager!

    //Notification options
    private let FrequentReminderOption = "Frequent"
    private let NormalReminderOption = "Normal"
    private let MinimalReminderOption = "Minimal"
    private let OffReminderOption = "None"
    
    //trip information
    var tripLocation: String = ""
    var medicine: Medicine.Pill!
    var departureDay = NSDate()
    var arrivalDay = NSDate()
    var items = [(String, Bool)]()
    
    lazy var toolBar: UIToolbar! = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("dismissInputView:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        return keyboardToolbar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        location.inputAccessoryView = toolBar
        historyTextField.inputAccessoryView = toolBar
        
        //Setting up departure
        departureDatePickerview = TimePickerView(view: departure, selectCallback: {(date: NSDate) in
            self.updateDeparture(date)
        })
        departure.inputAccessoryView = toolBar
        
        //Setting up arrival date picker
        arrivalDatePickerview = TimePickerView(view: arrival, selectCallback: {(date: NSDate) in
            self.updateArrival(date)
        })
        arrival.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //refresh context
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
        tripsManager = TripsManager(context: viewContext)
        
        //get stored information
        (departureDay, arrivalDay) = getStoredPlanTripDates()
        (items, tripLocation) = (getStoredPlanTripItems(), getStoredLocation())
        medicine = Medicine.Pill(rawValue: MedicineManager(context: viewContext).getCurrentMedicine()!.name)!
        
        //update fields
        updateLocation(tripLocation)
        updateItemsTextField(items)
        updateArrival(arrivalDay)
        updateDeparture(departureDay)
        
        //update input views
        arrival.inputView = arrivalDatePickerview.generateInputView(.Date, startDate: arrivalDay)
        departure.inputView = departureDatePickerview.generateInputView(.Date, startDate: departureDay)
        
        //update history
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
    
    func selectItemsCallback(medicine: Medicine.Pill, listItems: [(String, Bool)]){
        updateMedicine(medicine)
        updateItemsTextField(listItems)
    }
}

/// IBActions and helpers
extension PlanTripViewController{
    @IBAction func settingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            let view = UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self) as SetupScreenViewController
            self.presentViewController(view, animated: true, completion: nil)
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
            view.listItems = self.items
            view.completitionHandler = self.selectItemsCallback
            self.presentViewController(view, animated: true, completion: nil)
        }
    }
    
    @IBAction func generateTrip(sender: AnyObject) {
        if tripsManager.getTrip() != nil {
            var refreshAlert = UIAlertController(title: UpdateTripAlertText.title, message: UpdateTripAlertText.message, preferredStyle: .Alert)
            refreshAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Destructive, handler: { _ in
                self.storeTrip()
            }))
            refreshAlert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Default, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else{
            self.storeTrip()
            
            var successAlert = UIAlertController(title: SuccessAlertText.title, message: SuccessAlertText.message, preferredStyle: .Alert)
            successAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
            presentViewController(successAlert, animated: true, completion: nil)
            
            delay(3.0) {
                successAlert.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    private func storeTrip(){
        let trip = tripsManager.createTrip(location.text, medicine: medicine, departure: departureDay, arrival:arrivalDay)
        let itemManager = trip.itemsManager(viewContext)
        items.map({ itemManager.addItem($0.0, quantity: 1) })
        itemManager.toggleCheckItem( items.filter({ $0.1 }).map({ $0.0 }))
        
        scheduleNotifications(trip)
        prepareHistoryValuePicker()
    }
    
    private func scheduleNotifications(trip: Trip) {
        let notificationManager = trip.notificationManager(viewContext)
        
        switch (UserSettingsManager.UserSetting.TripReminderOption.getString()){
        case FrequentReminderOption:
            Logger.Info("Scheduling frequent notifications for plan my trip")
            notificationManager.scheduleNotification(departureDay)
            notificationManager.scheduleNotification(departureDay - 1.day)
            notificationManager.scheduleNotification(departureDay - 1.week)
        case NormalReminderOption:
            Logger.Info("Scheduling normal notifications for plan my trip")
            notificationManager.scheduleNotification(departureDay - 1.day)
            notificationManager.scheduleNotification(departureDay - 1.week)
        case MinimalReminderOption:
            Logger.Info("Scheduling minimal notifications for plan my trip")
            notificationManager.scheduleNotification(departureDay - 1.day)
        case OffReminderOption:
            Logger.Warn("Trip Reminder is turned off")
        default:
            UserSettingsManager.UserSetting.TripReminderOption.setString(FrequentReminderOption)
            scheduleNotifications(trip)
        }
    }
    
    @IBAction func historyButtonHandler(sender: AnyObject) {
        if tripLocationHistoryPickerViewer.locations.isEmpty {
            var successAlert = UIAlertController(title: EmptyHistoryAlertText.title, message: EmptyHistoryAlertText.message, preferredStyle: .Alert)
            successAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
            presentViewController(successAlert, animated: true, completion: nil)
        }else{
            historyTextField.becomeFirstResponder()
        }
    }
}

/// local variables updaters
extension PlanTripViewController {
    private func updateDeparture(date: NSDate){
        if date.startOfDay > arrivalDay.startOfDay {
            var refreshAlert = UIAlertController(title: InvalidDepartureAlertText.title, message: InvalidDepartureAlertText.message, preferredStyle: .Alert)
            refreshAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else {
            departureDay = date
            departure.text = date.formatWith(textFieldsDateFormat)
        }
    }
    
    private func updateArrival(date: NSDate){
        if date.startOfDay < departureDay.startOfDay {
            var refreshAlert = UIAlertController(title: InvalidArrivalAlertText.title, message: InvalidArrivalAlertText.message, preferredStyle: .Alert)
            refreshAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else {
            arrivalDay = date
            arrival.text = date.formatWith(textFieldsDateFormat)
        }
    }
    
    private func updateLocation(loc: String){
        generateTripBtn.enabled = !loc.isEmpty
        
        tripLocation = loc
        location.text = loc
    }
    
    private func updateMedicine(medicine: Medicine.Pill){
        self.medicine = medicine
    }
    
    private func getStoredLocation() -> String {
        return tripsManager.getTrip()?.location ?? ""
    }
    
    private func updateItemsTextField(items: [(String, Bool)]){
        self.items = items
        packingList.text = items.count == 0 ? "Only medicine" : "\(items.count + 1) items"
    }
    
    private func getStoredPlanTripItems() -> [(String, Bool)] {
        return tripsManager.getTrip()?.itemsManager(viewContext).getItems().map({ ($0.name, $0.check) }) ?? []
    }
  
    func getStoredPlanTripDates() -> (departure: NSDate, arrival: NSDate) {
        if let trip = tripsManager.getTrip() {
            return (trip.departure, trip.arrival)
        }
        
        return (NSDate(), NSDate() + 1.week)
    }
}

//messages
extension PlanTripViewController {
    typealias AlertText = (title: String, message: String)
    
    //update trip
    private var UpdateTripAlertText: AlertText {get {
        return ("Update Trip", "All data will be lost")
        }}
    
    //update trip
    private var SuccessAlertText: AlertText {get {
        return ("Success", "")
        }}
    
    //empty history
    private var EmptyHistoryAlertText: AlertText {get {
        return ("History is empty", "")
        }}
    
    //departure day error
    private var InvalidDepartureAlertText: AlertText {get {
        return ("Error", "Departure day must happen before arrival")
        }}
    
    //arrival day error
    private var InvalidArrivalAlertText: AlertText {get {
        return ("Error", "Arrival day must be after departure")
        }}
    
    //type of alerts options
    private var AlertOptions: (ok: String, cancel: String) {get {
        return ("Ok", "Cancel")
        }}
}