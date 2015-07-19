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
    
    //optional in preparation for calendar view that will show in this screen
    var currentDate: NSDate = NSDate()
    
    var viewContext: NSManagedObjectContext!
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("didNotTookMedicineBtnHandler")
        if (medicine.registriesManager(viewContext).addRegistry(currentDate, tookMedicine: false)){
            medicine.notificationManager(viewContext).reshedule()
        }
        
        refreshScreen()
    }
    
    func randomTook(probability: Int) -> Bool{
        let random = Int(arc4random_uniform(100))
        
        return probability >= random
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("tookMedicineBtnHandler")
        if (medicine.registriesManager(viewContext).addRegistry(currentDate, tookMedicine: true)){
            medicine.notificationManager(viewContext).reshedule()
        }
        
        Logger.Warn("ADDING DUMMY ENTRIES")
        for i in 1...50 {
            medicine.registriesManager(viewContext).addRegistry(currentDate - i.day, tookMedicine: randomTook(0))
        }
        
        for i in 51...100 {
            medicine.registriesManager(viewContext).addRegistry(currentDate - i.day, tookMedicine: randomTook(99))
        }
        
        for i in 101...200 {
            medicine.registriesManager(viewContext).addRegistry(currentDate - i.day, tookMedicine: randomTook(30))
        }
        
        for i in 201...365 {
            medicine.registriesManager(viewContext).addRegistry(currentDate - i.day, tookMedicine: randomTook(10))
        }
        
        Logger.Warn("DONE ADDING DUMMY ENTRIES")
        
        
        refreshScreen()
    }
    
    func refreshScreen(){
        if medicine.isWeekly(){
            if medicine.notificationManager(viewContext).checkIfShouldReset(currentDate: currentDate){
                dayOfTheWeekLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                fullDateLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                
                //reset configuration so that the user can reshedule the time
                UserSettingsManager.setDidConfiguredMedicine(false)
            }else if !NSDate.areDatesSameDay(currentDate, dateTwo: medicine.notificationTime!)
                        && currentDate > medicine.notificationTime!
                        && !medicine.registriesManager(viewContext).tookMedicine(currentDate){
                            
                dayOfTheWeekLbl.textColor = MissedWeeklyPillTextColor
                fullDateLbl.textColor = MissedWeeklyPillTextColor
            }
        }
        
        if medicine.registriesManager(viewContext).allRegistriesInPeriod(currentDate).count == 0{
            didNotTookPillBtn.enabled = true
            tookPillBtn.enabled = true
            
            return
        }else {
            let activateCheckButton = medicine.registriesManager(viewContext).tookMedicine(currentDate)
            
            didNotTookPillBtn.enabled = !activateCheckButton
            tookPillBtn.enabled = activateCheckButton
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        medicineManager = MedicineManager(context: viewContext)
        
        medicine = medicineManager.getCurrentMedicine()
        
        dayOfTheWeekLbl.text = currentDate.formatWith("EEEE")
        fullDateLbl.text = currentDate.formatWith("dd/MM/yyyy")
        
        refreshScreen()
    }
}