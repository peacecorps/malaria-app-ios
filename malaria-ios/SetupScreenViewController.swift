import UIKit

class SetupScreenViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var reminderTime: UITextField!
    @IBOutlet weak var medicineName: UITextField!
    
    var pills : [String] = [Pill.Doxycycline.rawValue, Pill.Malarone.rawValue, Pill.Mefloquine.rawValue];
    
    var pillReminderNotificationTime = NSDate()
    let DoneButtonWidth: CGFloat = 100.0
    let DoneButtonHeight: CGFloat = 40.0
    let TimePickerHeight: CGFloat = 200.0
    let InputMedicineHeight: CGFloat = 200.0
    
    let DismissTimePickerBtnTitle = "Done"
    
    private var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        medicineName.inputView = generateInputMedicineView()
        
        pillReminderNotificationTime = getStoredReminderTime()
        reminderTime.inputView = generateInputTimeView(pillReminderNotificationTime)
        
        refreshPage()
    }
    
    @IBAction func medicineEditingBegin(sender: AnyObject) {
        picker.reloadAllComponents()
        picker.selectRow(find(pills, getStoredMedicineName())!, inComponent: 0, animated: false)
    }
    
    private func refreshPage(){
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateformatter.dateFormat = "HH:mm a"
        reminderTime.text = dateformatter.stringFromDate(pillReminderNotificationTime)
        medicineName.text = getStoredMedicineName()
    }
    
    @IBAction func doneButtonHandler(){
        if(medicineName.text == ""){
            return;
        }
        
        //update userDefaults
        UserSettingsManager.setObject(UserSetting.ReminderTime, pillReminderNotificationTime)
        UserSettingsManager.setObject(UserSetting.MedicineName, medicineName.text)
        
        //setup notifications
        getAppDelegate().pillsManager.registerPill(Pill(rawValue: medicineName.text)!, fireTime: pillReminderNotificationTime)
        
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
        return UserSettingsManager.getObject(UserSetting.MedicineName) as? String ?? pills[0]
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pills.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return pills[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.medicineName.text = self.pills[row];
    }
    
    //create the view for input time
    private func generateInputTimeView(startDate: NSDate) -> UIView{
    
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, TimePickerHeight + DoneButtonHeight))
        
        var datePickerView = UIDatePicker(frame: CGRectMake(0, DoneButtonHeight, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.date = startDate
        datePickerView.addTarget(self, action: "timePickerValueChanged:", forControlEvents: UIControlEvents.AllEvents)
        
        inputView.addSubview(datePickerView) // add date picker to UIView
        inputView.addSubview(generateDoneButtonView("doneChoosingTimeButton:")) // add Button to UIView
        
        return inputView
    }
    
    //create the view for input medicine view
    private func generateInputMedicineView() -> UIView{
        
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, InputMedicineHeight + DoneButtonHeight))
        
        picker = UIPickerView()
        picker.delegate   = self
        picker.dataSource = self

        
        inputView.addSubview(picker) // add date picker to UIView
        inputView.addSubview(generateDoneButtonView("doneChoosingMedicineButton:")) // add Button to UIView
        
        return inputView
    }
    
    //create view for done button
    private func generateDoneButtonView(action: Selector) -> UIView{
        let doneButton = UIButton(frame: CGRectMake(self.view.frame.size.width-1.75*(DoneButtonWidth/2), 0, DoneButtonWidth, DoneButtonHeight))
        doneButton.setTitle(DismissTimePickerBtnTitle, forState: UIControlState.Normal)
        doneButton.setTitle(DismissTimePickerBtnTitle, forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        doneButton.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        return doneButton
    }
    
    //Selectors
    func doneChoosingMedicineButton(sender: UIButton){
        self.medicineName.endEditing(true)
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