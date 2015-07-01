import UIKit

class DidTakePillsViewController: UIViewController {
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
        
        //let didTookPill = MedicineManager.sharedInstance.didTookPill(NSDate())
     
        /*
        didNotTookMedicineBtn.enabled = !didTookPill
        tookMedicineBtn.enabled = !didTookPill
        */
    }
}