import Foundation
import UIKit

enum ExistingViewsControllers : String{
    //setup screen when the application launches for the first time
    case SetupScreenViewController = "SetupScreenViewController"
    
    //main manager of paged view controller
    case PagesManagerViewController = "PagesManagerViewController"
    
    //first button
    case DidTakePillViewController = "DidTakePillsViewController"
    
    //second button
    case PillsStatsViewController = "PillsStatsViewController"

    //third button
    case InfoViewController = "InfoViewController"
    
    
    func instanciateViewController() -> UIViewController{
        var value = rawValue
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(value) as! UIViewController
    }
}