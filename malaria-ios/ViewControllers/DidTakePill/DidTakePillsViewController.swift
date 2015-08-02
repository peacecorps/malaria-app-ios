import UIKit

@IBDesignable class DidTakePillsViewController: UIViewController {
    @IBOutlet weak var dayOfTheWeekLbl: UILabel!
    @IBOutlet weak var fullDateLbl: UILabel!
    @IBOutlet weak var tookPillBtn: UIButton!
    @IBOutlet weak var didNotTookPillBtn: UIButton!
    
    @IBInspectable var MissedWeeklyPillTextColor: UIColor = UIColor.redColor()
    @IBInspectable var SeveralDaysRowMissedEntriesTextColor: UIColor = UIColor.blackColor()
    
    var medicineManager: MedicineManager!
    var medicine: Medicine!
    
    var currentDate: NSDate = NSDate()
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationEvents.ObserveEnteredForeground(self, selector: "refreshScreen")        
    }
    
    deinit{
        NSNotificationEvents.UnregisterAll(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshScreen()
    }
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        if (medicine.registriesManager(viewContext).addRegistry(currentDate, tookMedicine: false)){
            medicine.notificationManager(viewContext).reshedule()
        }
        
        refreshScreen()
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        if (medicine.registriesManager(viewContext).addRegistry(currentDate, tookMedicine: true)){
            medicine.notificationManager(viewContext).reshedule()
        }
        
        refreshScreen()
    }
    
    func refreshScreen(){
        Logger.Info("Refreshing screen")
        
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        medicineManager = MedicineManager(context: viewContext)
        medicine = medicineManager.getCurrentMedicine()
        
        dayOfTheWeekLbl.text = currentDate.formatWith("EEEE")
        fullDateLbl.text = currentDate.formatWith("dd/MM/yyyy")
        
        if medicine.interval > 1 {
            if medicine.notificationManager(viewContext).checkIfShouldReset(currentDate: currentDate){
                dayOfTheWeekLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                fullDateLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                
                //reset configuration so that the user can reshedule the time
                UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(false)
            }else if !currentDate.sameDayAs(medicine.notificationTime!)
                        && currentDate > medicine.notificationTime!
                        && medicine.registriesManager(viewContext).tookMedicine(currentDate) == nil {
                            
                dayOfTheWeekLbl.textColor = MissedWeeklyPillTextColor
                fullDateLbl.textColor = MissedWeeklyPillTextColor
            }
        }
        
        if medicine.registriesManager(viewContext).allRegistriesInPeriod(currentDate).entries.count == 0{
            didNotTookPillBtn.enabled = true
            tookPillBtn.enabled = true
        }else {
            let activateCheckButton = medicine.registriesManager(viewContext).tookMedicine(currentDate) != nil
            didNotTookPillBtn.enabled = !activateCheckButton
            tookPillBtn.enabled = activateCheckButton
        }
    }
}