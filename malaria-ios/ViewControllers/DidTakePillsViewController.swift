import UIKit

class DidTakePillsViewController: UIViewController {
    @IBOutlet weak var dayOfTheWeekLbl: UILabel!
    @IBOutlet weak var fullDateLbl: UILabel!
    @IBOutlet weak var tookPillBtn: UIButton!
    @IBOutlet weak var didNotTookPillBtn: UIButton!
    
    let MissedWeeklyPillTextColor = UIColor.redColor()
    let SeveralDaysRowMissedEntriesTextColor = UIColor.blackColor()
    
    var medicineManager: MedicineManager!
    
    var medicine: Medicine!
    
    //optional in preparation for calendar view that will show in this screen
    var currentDate: NSDate?
    
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medicineManager = MedicineManager(context: viewContext)
    }
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("didNotTookMedicineBtnHandler")
        if (medicine.registriesManager(viewContext).addRegistry(currentDate!, tookMedicine: false)){
            medicine.notificationManager(viewContext).reshedule()
        }
        
        refreshScreen()
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("tookMedicineBtnHandler")
        if (medicine.registriesManager(viewContext).addRegistry(currentDate!, tookMedicine: true)){
            medicine.notificationManager(viewContext).reshedule()
        }
        
        refreshScreen()
    }
    
    func refreshScreen(){
        if medicine.isWeekly(){
            if medicine.notificationManager(viewContext).checkIfShouldReset(currentDate: currentDate!){
                dayOfTheWeekLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                fullDateLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                
                //reset configuration so that the user can reshedule the time
                UserSettingsManager.setDidConfiguredMedicine(false)
            }else if !NSDate.areDatesSameDay(currentDate!, dateTwo: medicine.notificationTime!)
                        && currentDate > medicine.notificationTime!
                        && !medicine.registriesManager(viewContext).tookMedicine(currentDate!){
                            
                dayOfTheWeekLbl.textColor = MissedWeeklyPillTextColor
                fullDateLbl.textColor = MissedWeeklyPillTextColor
            }
        }
        
        if medicine.registriesManager(viewContext).allRegistriesInPeriod(currentDate!).count == 0{
            return
        }else {
            let activateCheckButton = medicine.registriesManager(viewContext).tookMedicine(currentDate!)
            
            didNotTookPillBtn.enabled = !activateCheckButton
            tookPillBtn.enabled = activateCheckButton
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentDate = currentDate ?? NSDate()
        medicine = medicineManager.getCurrentMedicine()
        
        dayOfTheWeekLbl.text = currentDate!.formatWith("EEEE")
        fullDateLbl.text = currentDate!.formatWith("dd/MM/yyyy")
        
        refreshScreen()
    }
}