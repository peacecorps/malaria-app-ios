import Foundation
import UIKit

class PagesManagerViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    @IBOutlet weak var settingsBtn: UIImageView!
    @IBOutlet weak var content: UIView!
    
    
    //can be home, trip or info, by default is Home
    var type: PageType = PageType()
    
    //TakeMedicine, DailyStats or Stats
    private var homePageEnum: HomePage = HomePage()
    private var pageViewController : UIPageViewController!
    private var _dict: [UIViewController: HomePage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        
        var contentView: UIViewController?
        let contentFrame: CGRect = CGRectMake(0, content.frame.origin.y, view.frame.width, view.frame.height - content.frame.origin.y - 50)
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        pageViewController.view.frame = contentFrame
        
        
        let defaultPage = getController(homePageEnum)!
        pageViewController!.setViewControllers([defaultPage], direction: .Forward, animated: false, completion: nil)
        
        contentView = pageViewController
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()
        
        //add pretended view to the hierarchy
        
        
        if let pretendedView = contentView{
            pretendedView.view.backgroundColor = UIColor.clearColor()
            pretendedView.willMoveToParentViewController(self)
            addChildViewController(pretendedView)
            view.addSubview(pretendedView.view)
            pretendedView.didMoveToParentViewController(self)
        }else{
            Logger.Error("Couldn't load pageManagerContent")
        }
    }
    
    @IBAction func settingsButtonHandler(){
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showSetupScreen", sender: nil)
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return HomePage.allValues.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return homePageEnum.rawValue
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return getController(_dict[viewController]!.previousIndex())
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return getController(_dict[viewController]!.nextIndex())
    }
    
    private func getController(value: HomePage) -> UIViewController? {
        var vc: UIViewController?
        
        switch value {
            case .DailyPill:
                vc = ExistingViewsControllers.DidTakePillViewController.instanciateViewController() as! DidTakePillsViewController
            case .DailyStates:
                vc = ExistingViewsControllers.DailyStatsTableViewController.instanciateViewController() as! DailyStatsTableViewController
            case .Stats:
                vc = ExistingViewsControllers.PillsStatsViewController.instanciateViewController() as! PillsStatsViewController
            default: return nil
        }
        
        //initialize views here if needed
        
        // store relative enum to view controller
        _dict[vc!] = value
        return vc!
    }
}

enum PageType: Int{
    case Home, Trip, Info
    init(){
        self = .Home
    }
}

enum HomePage: Int {
    static let allValues = [DailyPill, DailyStates, Stats]
    
    case Nil = -1, DailyPill, DailyStates, Stats
    
    init() {
        self = .DailyPill
    }
    
    func previousIndex() -> HomePage {
        return HomePage(rawValue: rawValue-1)!
    }
    
    func nextIndex() -> HomePage {
        var value = rawValue+1
        if value > HomePage.allValues.count-1 { value = Nil.rawValue }
        return HomePage(rawValue: value)!
    }
}