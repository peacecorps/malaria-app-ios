import UIKit

class SetupScreenViewController : UIViewController{
    @IBOutlet weak var reminderTime: UITextField!
    @IBOutlet weak var medicineName: UITextField!
    
    var pillReminderNotificationTime = NSDate()
    let DoneButtonWidth: CGFloat = 100.0
    let DoneButtonHeight: CGFloat = 40.0
    let TimePickerHeight: CGFloat = 200.0
    
    let DismissTimePickerBtnTitle = "Done"
    let MedicinePlaceHolderText = "Vicodin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        pillReminderNotificationTime = getStoredReminderTime()
        refreshPage()
    }
    
    
    private func refreshPage(){
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateformatter.dateFormat = "HH:mm a"
        reminderTime.text = dateformatter.stringFromDate(pillReminderNotificationTime)
        
        medicineName.text = getStoredMedicineName()
    }
    
    @IBAction func timeTextFieldHandler(sender: UITextField){
        let storedPreviousDate = getStoredReminderTime()
        sender.inputView = generateInputTimeView(storedPreviousDate)
    }
    
    @IBAction func doneButtonHandler(){
        if(medicineName.text == ""){
            return;
        }
        
        //update userDefaults
        UserSettingsManager.setObject(UserSetting.ReminderTime, pillReminderNotificationTime)
        UserSettingsManager.setObject(UserSetting.MedicineName, medicineName.text)
        
        //setup notifications
        var remindPillNotification = PillRemainderNotification.create(medicineName.text, fireDate: pillReminderNotificationTime)
        UIApplication.sharedApplication().scheduleLocalNotification(remindPillNotification)
        
        //updated flag to avoid going to this page again after each app restart
        UserSettingsManager.setBool(UserSetting.DidConfiguredMedicineNotification, true)
        
        //show next view
        presentViewController(
            ExistingViewsControllers.PagesManagerViewController.instanciateViewController(),
            animated: true,
            completion: nil
        )
        
    }
    
    
    private func getStoredReminderTime() -> NSDate{
        return UserSettingsManager.getObject(UserSetting.ReminderTime) as? NSDate ?? NSDate()
    }
    
    private func getStoredMedicineName() -> String{
        return UserSettingsManager.getObject(UserSetting.MedicineName) as? String ?? MedicinePlaceHolderText
    }

    //Create the view for the Done button navigation on popup.
    private func generateInputTimeView(startDate: NSDate) -> UIView{
    
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, TimePickerHeight + DoneButtonHeight))
        
        var datePickerView = UIDatePicker(frame: CGRectMake(0, DoneButtonHeight, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.date = startDate
        datePickerView.addTarget(self, action: "timePickerValueChanged:", forControlEvents: UIControlEvents.AllEvents)
        
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRectMake(self.view.frame.size.width-1.75*(DoneButtonWidth/2), 0, DoneButtonWidth, DoneButtonHeight))
        doneButton.setTitle(DismissTimePickerBtnTitle, forState: UIControlState.Normal)
        doneButton.setTitle(DismissTimePickerBtnTitle, forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        doneButton.addTarget(self, action: "doneChoosingTimeButton:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event

        inputView.addSubview(doneButton) // add Button to UIView
        
        return inputView
    }
    
    
    func doneChoosingTimeButton(sender: UIButton)
    {
        reminderTime.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func timePickerValueChanged (sender: UIDatePicker){
        pillReminderNotificationTime = sender.date
        refreshPage()
    }

}