import UIKit

class DidTakePillsViewController: UIViewController {
    
    //next pill day
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var didNotTookMedicineBtn: UIButton!
    @IBOutlet weak var tookMedicineBtn: UIButton!
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        logger("didNotTookMedicineBtnHandler")
        
        getAppDelegate().medsManager.updatePillTracker(NSDate(), tookPill: false)
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        logger("tookMedicineBtnHandler")
        getAppDelegate().medsManager.updatePillTracker(NSDate(), tookPill: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger("loaded didTakePills")
        
        let didTookPill = getAppDelegate().medsManager.didTookPill(NSDate())
     
        /*
        didNotTookMedicineBtn.enabled = !didTookPill
        tookMedicineBtn.enabled = !didTookPill
        */
    }
}