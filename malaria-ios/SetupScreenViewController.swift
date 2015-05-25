import UIKit

class SetupScreenViewController : UIViewController{
    
    @IBAction func doneButtonHandler(){
        presentViewController(
            ExistingViewControllers.PagesManagerViewController.instanciateViewController(),
            animated: true,
            completion: nil
        )
        logger("pressed done button: Setup finished")
        //UserSettingsManager.setBool(.IsFirstLaunch, true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
}