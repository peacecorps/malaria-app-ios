import UIKit

class DidTakePillsViewController: UIViewController {
    
    //next pill day
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var currentDay: UILabel!
    
    @IBOutlet weak var didNotTookMedicineBtn: UIButton!
    @IBOutlet weak var tookMedicineBtn: UIButton!
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        
        /*TODO - DO NOTHING IF THIS DAY WAS REGISTERED*/
        
        logger("didNotTookMedicineBtnHandler")
        
        let currentDate = NSDate()
        UserSettingsManager.setObject(UserSetting.MedicineLastRegistry, currentDate)
        
        UserSettingsManager.setInt(UserSetting.DosesInARow, 0)
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        logger("tookMedicineBtnHandler")
        let currentDate = NSDate()
        UserSettingsManager.setObject(UserSetting.MedicineLastRegistry, currentDate)
        UserSettingsManager.setInt(UserSetting.DosesInARow, UserSettingsManager.getInt(UserSetting.DosesInARow)+1)
        
        logger("DosesInRow: \(UserSetting.DosesInARow, UserSettingsManager.getInt(UserSetting.DosesInARow))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger("loaded didTakePills")
    }
}

