import UIKit
import AVFoundation

@IBDesignable class DidTakePillsViewController: UIViewController, PresentsModalityDelegate {
    @IBOutlet weak var dayOfTheWeekLbl: UILabel!
    @IBOutlet weak var fullDateLbl: UILabel!
    @IBOutlet weak var tookPillBtn: UIButton!
    @IBOutlet weak var didNotTookPillBtn: UIButton!
    
    @IBInspectable var MissedWeeklyPillTextColor: UIColor = UIColor.redColor()
    @IBInspectable var SeveralDaysRowMissedEntriesTextColor: UIColor = UIColor.blackColor()
    
    
    var medicineManager: MedicineManager!
    var medicine: Medicine?
    
    var currentDate: NSDate = NSDate()
    var viewContext: NSManagedObjectContext!
    
    private let TookPillSoundPath = NSBundle.mainBundle().pathForResource("correct", ofType: "aiff", inDirectory: "Sounds")
    private let DidNotTakePillSoundPath = NSBundle.mainBundle().pathForResource("incorrect", ofType: "aiff", inDirectory: "Sounds")
    private var tookPillPlayer = AVAudioPlayer()
    private var didNotTakePillPlayer = AVAudioPlayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationEvents.ObserveEnteredForeground(self, selector: "refreshScreen")
        
        if let tookPillSoundPath = TookPillSoundPath,
            let didNotTakePillSoundPath = DidNotTakePillSoundPath{
            tookPillPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: tookPillSoundPath), error: nil)
            didNotTakePillPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: didNotTakePillSoundPath), error: nil)
        }else {
            Logger.Error("Error getting sounds effects file paths")
        }
    }
    
    deinit{
        NSNotificationEvents.UnregisterAll(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshScreen()
    }
    
    var pagesManager: PagesManagerViewController!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pagesManager.currentViewController = self
    }
    
    func OnDismiss() {
        refreshScreen()
    }
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        if let m = medicine {
            if (tookPillBtn.enabled && didNotTookPillBtn.enabled && m.registriesManager(viewContext).addRegistry(currentDate, tookMedicine: false)){
                didNotTakePillPlayer.play()
                m.notificationManager(viewContext).reshedule()
                refreshScreen()
            }
        }
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        if let m = medicine {
            if (tookPillBtn.enabled && didNotTookPillBtn.enabled && m.registriesManager(viewContext).addRegistry(currentDate, tookMedicine: true)){
                tookPillPlayer.play()
                m.notificationManager(viewContext).reshedule()
                refreshScreen()
            }
        }
    }
    
    func refreshScreen(){
        Logger.Info("Refreshing TOOK PILL")
        
        currentDate = NSDate()
        dayOfTheWeekLbl.text = currentDate.formatWith("EEEE")
        fullDateLbl.text = currentDate.formatWith("dd/MM/yyyy")

        
        if !UserSettingsManager.UserSetting.DidConfiguredMedicine.getBool() {
            return
        }
        
        if !(tookPillPlayer.prepareToPlay() && didNotTakePillPlayer.prepareToPlay()) {
            Logger.Error("Error preparing sounds effects")
        }
        
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        medicineManager = MedicineManager(context: viewContext)
        medicine = medicineManager.getCurrentMedicine()
        
        let medicineRegistries = medicine!.registriesManager(viewContext)
        let tookMedicineEntry = medicineRegistries.tookMedicine(currentDate)
        
        if medicine!.interval > 1 {
            if medicine!.notificationManager(viewContext).checkIfShouldReset(currentDate: currentDate){
                
                dayOfTheWeekLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                fullDateLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                
                //reset configuration so that the user can reshedule the time
                UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(false)
            }else if !currentDate.sameDayAs(medicine!.notificationTime!)
                        && currentDate > medicine!.notificationTime!
                        && tookMedicineEntry == nil {
                            
                dayOfTheWeekLbl.textColor = MissedWeeklyPillTextColor
                fullDateLbl.textColor = MissedWeeklyPillTextColor
            }
        }
        
        if tookMedicineEntry != nil {
            //if he took
            didNotTookPillBtn.enabled = false
            tookPillBtn.enabled = true
        }else {
            //didn't took because there is no information
            if medicineRegistries.allRegistriesInPeriod(currentDate).entries.count == 0 {
                didNotTookPillBtn.enabled = true
                tookPillBtn.enabled = true
            }else {
                //or there is and he he didn't took the medicine yet
                //check if he already registered today
                if medicineRegistries.findRegistry(currentDate) != nil {
                    didNotTookPillBtn.enabled = true
                    tookPillBtn.enabled = false
                }else {
                    //which means that there are no entries for today, so he still has the opportunity to change that
                    didNotTookPillBtn.enabled = true
                    tookPillBtn.enabled = true
                }
            }
        }
    }
}