import UIKit

class SetupScreenViewController : UIViewController{
    @IBOutlet weak var reminderTime: UITextField!
    @IBOutlet weak var medicineName: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: BackgroundImageId)!)
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
    
    @IBAction func doneButtonHandler(){
        let med = Medicine.Pill(rawValue: self.medicineName.text)!
        
        if(UserSettingsManager.UserSetting.DidConfiguredMedicine.getBool()){
            
            //avoid showing the alert view if there are no changes
            if let current = medicineManager.getCurrentMedicine(){
                if current.name == medicineName.text && current.notificationTime!.sameClockTimeAs(pillReminderNotificationTime){
                    delay(0.05) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    return
                }
            }
            
            var medicineAlert = UIAlertController(title: "There is already medicine configured", message: "The current configuration will be changed.", preferredStyle: .Alert)
            medicineAlert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: { (action: UIAlertAction!) in
                
                self.medicineManager.registerNewMedicine(med.name(), interval: med.interval())
                self.medicineManager.setCurrentPill(med.name())
                self.medicineManager.getCurrentMedicine()!.notificationManager(self.viewContext).scheduleNotification(self.pillReminderNotificationTime)
                delay(0.05) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }))
            
            medicineAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                delay(0.05) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }))
            
            presentViewController(medicineAlert, animated: true, completion: nil)
            
        }else{
            presentViewController(
                UIStoryboard.instantiate(viewControllerClass: TabbedBarController.self),
                animated: true,
                completion: nil
            )
            medicineManager.setup(med.name(), interval: med.interval(), fireDate: pillReminderNotificationTime)
        }
        
        
    }
    
    private func getStoredReminderTime() -> NSDate{
        return medicineManager.getCurrentMedicine()?.notificationTime ?? NSDate()
    }
}