import UIKit

class DidTakePillsViewController: UIViewController {
    @IBOutlet weak var dayOfTheWeekLbl: UILabel!
    @IBOutlet weak var fullDateLbl: UILabel!
    @IBOutlet weak var tookMedicineBtn: UIButton!
    @IBOutlet weak var didNotTookMedicineBtn: UIButton!
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("didNotTookMedicineBtnHandler")
        
        //MedicineRegistry.sharedInstance.addRegistry(NSDate(), tookMedicine: false)
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("tookMedicineBtnHandler")
        //MedicineRegistry.sharedInstance.addRegistry(NSDate(), tookMedicine: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.Info("loaded didTakePills")
        
        
        let currentDay = NSDate()
        dayOfTheWeekLbl.text = currentDay.formatWith("EEEE")
        fullDateLbl.text = currentDay.formatWith("dd/MM/yyyy")
        
        //let didTookPill = MedicineManager.sharedInstance.didTookPill(NSDate())
     
        /*
        didNotTookMedicineBtn.enabled = !didTookPill
        tookMedicineBtn.enabled = !didTookPill
        */
    }
}