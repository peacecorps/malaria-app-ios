import UIKit
import AVFoundation

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
    
    private let TookPillPath = NSBundle.mainBundle().pathForResource("correct", ofType: "aiff", inDirectory: "Sounds")
    private let DidNotTakePillPath = NSBundle.mainBundle().pathForResource("incorrect", ofType: "aiff", inDirectory: "Sounds")
    private var tookPillPlayer = AVAudioPlayer()
    private var didNotTakePillPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationEvents.ObserveEnteredForeground(self, selector: "refreshScreen")
        
        if let tookPillPath = TookPillPath,
            let didNotTakePillPath = DidNotTakePillPath{

            tookPillPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: tookPillPath), error: nil)
            tookPillPlayer.prepareToPlay()
                
            didNotTakePillPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: didNotTakePillPath), error: nil)
            didNotTakePillPlayer.prepareToPlay()
        }else {
            Logger.Error("Error loading sounds effects")
        }
    }
    
    deinit{
        NSNotificationEvents.UnregisterAll(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshScreen()
    }
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        println("NO")
        if (tookPillBtn.enabled && didNotTookPillBtn.enabled && medicine.registriesManager(viewContext).addRegistry(currentDate, tookMedicine: false)){
            didNotTakePillPlayer.play()
            medicine.notificationManager(viewContext).reshedule()
            refreshScreen()
        }
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        println("YES")
        if (tookPillBtn.enabled && didNotTookPillBtn.enabled && medicine.registriesManager(viewContext).addRegistry(currentDate, tookMedicine: true)){
            tookPillPlayer.play()
            medicine.notificationManager(viewContext).reshedule()
            refreshScreen()
        }
    }
    
    func refreshScreen(){
        Logger.Info("Refreshing screen")
        
        currentDate = NSDate()
        
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        medicineManager = MedicineManager(context: viewContext)
        medicine = medicineManager.getCurrentMedicine()
        
        dayOfTheWeekLbl.text = currentDate.formatWith("EEEE")
        fullDateLbl.text = currentDate.formatWith("dd/MM/yyyy")
        
        let medicineRegistries = medicine.registriesManager(viewContext)
        let tookMedicineEntry = medicineRegistries.tookMedicine(currentDate)
        
        if medicine.interval > 1 {
            if medicine.notificationManager(viewContext).checkIfShouldReset(currentDate: currentDate){
                
                dayOfTheWeekLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                fullDateLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                
                //reset configuration so that the user can reshedule the time
                UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(false)
            }else if !currentDate.sameDayAs(medicine.notificationTime!)
                        && currentDate > medicine.notificationTime!
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
            //didn't took because there he didn't entered any information
            if medicineRegistries.allRegistriesInPeriod(currentDate).entries.count == 0 {
                didNotTookPillBtn.enabled = true
                tookPillBtn.enabled = true
            }else {
                //or did and said that he didn't took the medicine yet
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