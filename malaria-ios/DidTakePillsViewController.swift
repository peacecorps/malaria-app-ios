import UIKit

class DidTakePillsViewController: PageManagerContentViewController {
    
    //next pill day
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var currentDay: UILabel!
    
    @IBOutlet weak var didNotTookMedicineBtn: UIButton!
    @IBOutlet weak var tookMedicineBtn: UIButton!
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        logger("didNotTookMedicineBtnHandler")
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        logger("tookMedicineBtnHandler")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger("loaded didTakePills")
    }
}

