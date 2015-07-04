import UIKit

class SetupScreenViewController : UIViewController{
    @IBOutlet weak var reminderTime: UITextField!
    @IBOutlet weak var medicineName: UITextField!
    
    var pillReminderNotificationTime: NSDate!
    let BackgroundImageId = "background"
    
    var medicinePicker: MedicinePickerView!
    var timePickerview: TimePickerView!
    
    
    lazy var toolBar: UIToolbar! = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("dismissInputView:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        return keyboardToolbar
        }()
    
    func dismissInputView(sender: UITextField){
        medicineName.endEditing(true)
        reminderTime.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: BackgroundImageId)!)
        
        pillReminderNotificationTime = getStoredReminderTime()
        
        //Setting up medicinePickerView with default Value
        medicinePicker = MedicinePickerView(selectCallback: {(object: String) in
            self.medicineName.text = object
        })
        medicineName.inputView = medicinePicker.generateInputView()
        medicineName.inputAccessoryView = toolBar
        
        //Setting up DatePickerView
        timePickerview = TimePickerView(view: reminderTime, selectCallback: {(date: NSDate) in
            self.pillReminderNotificationTime = date
            self.refreshPage()
        })
        reminderTime.inputView = timePickerview.generateInputView(.Time, startDate: pillReminderNotificationTime)
        reminderTime.inputAccessoryView = toolBar
        
        refreshPage()
    }
    
    private func refreshPage(){
        reminderTime.text = pillReminderNotificationTime.formatWith("HH:mm a")
        medicineName.text = getStoredMedicineName()
    }
    
    @IBAction func doneButtonHandler(){
        if(UserSettingsManager.getDidConfiguredMedicine()){
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            var view = UIStoryboard.instantiate(viewControllerClass: TabbedBarController.self)
            presentViewController(
                view,
                animated: true,
                completion: nil
            )
        }
        
        MedicineManager.sharedInstance.setup(Medicine.Pill(rawValue: medicineName.text)!, fireDate: pillReminderNotificationTime)
    }
    
    private func getStoredReminderTime() -> NSDate{
        return MedicineManager.sharedInstance.getCurrentMedicine()?.notificationTime ?? NSDate()
    }
    
    private func getStoredMedicineName() -> String{
        return MedicineManager.sharedInstance.getCurrentMedicine()?.name ?? medicinePicker.medicines[0]
    }
    
    func timePickerValueChanged(date: NSDate){
        pillReminderNotificationTime = date
        refreshPage()
    }
}