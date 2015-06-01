import UIKit

class DailyStatsViewController: UIViewController {
    
    @IBOutlet weak var medicineLastTaken: UILabel!
    @IBOutlet weak var DosesInARow: UILabel!
    @IBOutlet weak var Adherence: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger("loaded pills daily stats")
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        /*
        let lastDatePill = UserSettingsManager.getObject(UserSetting.MedicineLastRegistry) as! NSDate
        
        medicineLastTaken.text = dateFormatter.stringFromDate(lastDatePill)
        DosesInARow.text = "\(UserSettingsManager.getInt(UserSetting.DosesInARow)) hehe"
        
        //set adherence as totalTaken / DesiredTotal
        //DesiredTotal must be a computer properity based on type of pill (weekly/daily)
*/
    }
}

