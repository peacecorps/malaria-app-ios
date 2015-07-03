import UIKit

class DidTakePillsViewController: UIViewController {
    @IBOutlet weak var dayOfTheWeekLbl: UILabel!
    @IBOutlet weak var fullDateLbl: UILabel!
    @IBOutlet weak var tookPillBtn: UIButton!
    @IBOutlet weak var didNotTookPillBtn: UIButton!
    
    let MissedWeeklyPillTextColor = UIColor.redColor()
    let SeveralDaysRowMissedEntriesTextColor = UIColor.blackColor()
    
    var medicine: Medicine!
    
    //optional in preparation for calendar view that will show this screen
    var currentDate: NSDate?
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("didNotTookMedicineBtnHandler")
        if (medicine.registriesManager.addRegistry(currentDate!, tookMedicine: false)){
            medicine.notificationManager.reshedule()
        }
        
        refreshScreen()
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("tookMedicineBtnHandler")
        if (medicine.registriesManager.addRegistry(currentDate!, tookMedicine: true)){
            medicine.notificationManager.reshedule()
        }
        
        refreshScreen()
    }
    
    func refreshScreen(){
        if medicine.isWeekly(){
            if medicine.notificationManager.checkIfShouldReset(currentDate: currentDate!){
                dayOfTheWeekLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                fullDateLbl.textColor = SeveralDaysRowMissedEntriesTextColor
                
                //reset configuration so that the user can reshedule the time
                UserSettingsManager.setDidConfiguredMedicine(false)
            }else if !NSDate.areDatesSameDay(currentDate!, dateTwo: medicine.notificationTime!)
                        && currentDate > medicine.notificationTime!
                        && !medicine.registriesManager.tookMedicine(currentDate!){
                            
                dayOfTheWeekLbl.textColor = MissedWeeklyPillTextColor
                fullDateLbl.textColor = MissedWeeklyPillTextColor
            }
        }
        
        if medicine.registriesManager.allRegistriesInPeriod(currentDate!).count == 0{
            return
        }else {
            let activateCheckButton = medicine.registriesManager.tookMedicine(currentDate!)
            
            didNotTookPillBtn.enabled = !activateCheckButton
            tookPillBtn.enabled = activateCheckButton
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentDate = currentDate ?? NSDate()
        medicine = MedicineManager.sharedInstance.getCurrentMedicine()
        
        dayOfTheWeekLbl.text = currentDate!.formatWith("EEEE")
        fullDateLbl.text = currentDate!.formatWith("dd/MM/yyyy")
        
        refreshScreen()
    }
}