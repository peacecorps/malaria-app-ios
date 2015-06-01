import UIKit

class DailyStatsViewController: UIViewController {
    
    @IBOutlet weak var medicineLastTaken: UILabel!
    @IBOutlet weak var DosesInARow: UILabel!
    @IBOutlet weak var Adherence: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger("loaded pills daily stats")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        medicineLastTaken.text = dateFormatter.stringFromDate(getAppDelegate().pillsManager.lastPillDateRegistry())
        
        DosesInARow.text = "\(getAppDelegate().pillsManager.currentPillStreak())"
        Adherence.text = "\(getAppDelegate().pillsManager.currentPillAdherence())"
    }
}

