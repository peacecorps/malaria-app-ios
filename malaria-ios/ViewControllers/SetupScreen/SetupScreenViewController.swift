import UIKit

class SetupScreenViewController : UIViewController{
    @IBOutlet weak var reminderTime: UITextField!
    @IBOutlet weak var medicineName: UITextField!
    
    var delegate: PresentsModalityDelegate!
    
    var pillReminderNotificationTime: NSDate!
    let BackgroundImageId = "background"
    
    var medicinePicker: MedicinePickerView!
    var timePickerview: TimePickerView!
    
    var viewContext: NSManagedObjectContext!
    
    var medicineManager: MedicineManager!
    
    lazy var toolBar: UIToolbar! = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("dismissInputView:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        return keyboardToolbar
        }()
    

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
        timePickerview = TimePickerView(view: reminderTime, selectCallback: {(date: NSDate) in
            self.pillReminderNotificationTime = date
            self.refreshDate()
        })
        reminderTime.inputView = timePickerview.generateInputView(.Time, startDate: pillReminderNotificationTime)
        reminderTime.inputAccessoryView = toolBar
        
        medicineName.text = medicinePicker.selectedValue
        
        refreshDate()
    }
    
    func dismissInputView(sender: UITextField){
        medicineName.endEditing(true)
        reminderTime.endEditing(true)
    }
    
    private func refreshDate(){
        reminderTime.text = pillReminderNotificationTime.formatWith("HH:mm a")
    }
    
    @IBAction func sendFeedback(sender: AnyObject) {
        openUrl(NSURL(string: "mailto:\(PeaceCorpsInfo.mail)"))
    }
    
    @IBAction func doneButtonHandler(){
        let med = Medicine.Pill(rawValue: self.medicineName.text)!
        
        //avoid showing the alert view if there are no changes
        if let current = medicineManager.getCurrentMedicine(){
            if current.name == medicineName.text && current.notificationTime!.sameClockTimeAs(pillReminderNotificationTime){
                delay(0.05) {
                    self.dismissViewControllerAnimated(true, completion: self.CallOnDismiss)
                }
                return
            }
            
            let title = "There is already medicine configured"
            let message = "The current configuration will be changed"
            var medicineAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            medicineAlert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: { _ in
                self.setupMedicine(med)
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            medicineAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { _ in
                delay(0.05) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }))
            
            presentViewController(medicineAlert, animated: true, completion: nil)
        } else {
            self.setupMedicine(med)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //could be called on the completition, however It is too late because it is noticible the screen being updated
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.CallOnDismiss()
    }
    
    private func setupMedicine(med: Medicine.Pill) {
        self.medicineManager.registerNewMedicine(med.name(), interval: med.interval())
        self.medicineManager.setCurrentPill(med.name())
        self.medicineManager.getCurrentMedicine()!.notificationManager(self.viewContext).scheduleNotification(self.pillReminderNotificationTime)
        UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(true)
    }
    
    func CallOnDismiss() {
        delegate!.OnDismiss()
    }
    
    private func getStoredReminderTime() -> NSDate{
        return medicineManager.getCurrentMedicine()?.notificationTime ?? NSDate()
    }
}