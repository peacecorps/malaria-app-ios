import Foundation
import UIKit

class PlanTripViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.Info("loaded PlanTripViewController")
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    @IBAction func settingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self), animated: true, completion: nil)
        }
    }
}