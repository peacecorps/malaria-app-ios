import UIKit

public class PageManagerContentViewController : UIViewController{
    var changeIndicatorHandler: ( Int -> Void )?
    var pageIndex: Int?
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let changeIndicatorHandler = changeIndicatorHandler {
            changeIndicatorHandler(pageIndex!)
        }
    }

}