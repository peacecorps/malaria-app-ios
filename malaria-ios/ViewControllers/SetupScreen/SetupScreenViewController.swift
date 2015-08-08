import UIKit

class SetupScreenViewController : UIViewController{
    @IBOutlet weak var reminderTime: UITextField!
    @IBOutlet weak var medicineName: UITextField!
    @IBInspectable var reminderTimeFormat: String = "HH:mm a"
    
    //provided by pagesManagerViewController
    var delegate: PresentsModalityDelegate!
    
    //input pickers
    private var medicinePicker: MedicinePickerView!
    private var timePickerview: TimePickerView!
    
    private var toolBar: UIToolbar!
    
    //mangagers
    private var viewContext: NSManagedObjectContext!
    private var medicineManager: MedicineManager!
    
    private var pillReminderNotificationTime: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBar = ToolbarWithDone(viewsWithToolbar: [medicineName, reminderTime])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
        
        medicineManager = MedicineManager(context: viewContext)
        
        pillReminderNotificationTime = getStoredReminderTime()
        
        //Setting up medicinePickerView with default Value
        medicinePicker = MedicinePickerView(context: viewContext, selectCallback: {(object: String) in
            self.medicineName.text = object
        })
        medicineName.inputView = medicinePicker.generateInputView()
        medicineName.inputAccessoryView = toolBar
        
        //Setting up DatePickerView
        timePickerview = TimePickerView(selectCallback: {(date: NSDate) in
            self.pillReminderNotificationTime = date
            self.refreshDate()
        })
        reminderTime.inputView = timePickerview.generateInputView(.Time, startDate: pillReminderNotificationTime)
        reminderTime.inputAccessoryView = toolBar
        
        medicineName.text = medicinePicker.selectedValue
        
        refreshDate()
    }
    
    func dismissInputView(sender: UIView){
        medicineName.endEditing(true)
        reminderTime.endEditing(true)
    }
}

extension SetupScreenViewController{
    //could be called on the completition, however It is too late because it is noticible the screen being updated
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.CallOnDismiss()
    }
    
    func CallOnDismiss() {
        delegate?.OnDismiss()
    }
}

//IBActions and helpers
extension SetupScreenViewController {
    @IBAction func sendFeedback(sender: AnyObject) {
        openUrl(NSURL(string: "mailto:\(PeaceCorpsInfo.mail)"))
    }
    
    @IBAction func doneButtonHandler(){
        let med = Medicine.Pill(rawValue: self.medicineName.text)!
        
        //avoid showing the alert view if there are no changes
        if let current = medicineManager.getCurrentMedicine(){
            if current.name == medicineName.text && current.notificationTime!.sameClockTimeAs(pillReminderNotificationTime){
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            var medicineAlert = UIAlertController(title: ReplaceMedicineAlertText.title, message: ReplaceMedicineAlertText.message, preferredStyle: .Alert)
            medicineAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Destructive, handler: { _ in
                self.setupMedicine(med)
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            medicineAlert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Default, handler: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            presentViewController(medicineAlert, animated: true, completion: nil)
        } else {
            setupMedicine(med)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func setupMedicine(med: Medicine.Pill) {
        self.medicineManager.registerNewMedicine(med.name(), interval: med.interval())
        self.medicineManager.setCurrentPill(med.name())
        self.medicineManager.getCurrentMedicine()!.notificationManager(self.viewContext).scheduleNotification(self.pillReminderNotificationTime)
        UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(true)
    }
    
    private func refreshDate(){
        reminderTime.text = pillReminderNotificationTime.formatWith(reminderTimeFormat)
    }
    
    private func getStoredReminderTime() -> NSDate{
        return medicineManager.getCurrentMedicine()?.notificationTime ?? NSDate()
    }
}

//alert messages
extension SetupScreenViewController {
    typealias AlertText = (title: String, message: String)
    
    //existing medicine configured
    private var ReplaceMedicineAlertText: AlertText {get {
        return ("This will change the current settings", "Your previous statistics won't be lost")
    }}
    
    //type of alerts options
    private var AlertOptions: (ok: String, cancel: String) {get {
        return ("Ok", "Cancel")
    }}
}