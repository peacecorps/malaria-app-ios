import Foundation
import UIKit

class PagesManagerViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var content: UIView!
    
    private var homePageEnum: HomePage = HomePage()
    private var pageViewController : UIPageViewController!
    private var _dict: [UIViewController: HomePage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        pageViewController.view.frame = CGRectMake(0, content.frame.origin.y, view.frame.width, view.frame.height - content.frame.origin.y - 50)
        
        
        let defaultPage = getController(homePageEnum)!
        pageViewController!.setViewControllers([defaultPage], direction: .Forward, animated: false, completion: nil)
        
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.fromHex(0xB2BFAF)
        appearance.currentPageIndicatorTintColor = UIColor.fromHex(0x9EB598)
        appearance.backgroundColor = UIColor.clearColor()
        
        
        //add pretended view to the hierarchy
        pageViewController.view.backgroundColor = UIColor.clearColor()
        pageViewController.willMoveToParentViewController(self)
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }
    
    @IBAction func settingsButtonHandler(){
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self), animated: true, completion: nil)
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
                vc = UIStoryboard.instantiate(viewControllerClass: DidTakePillsViewController.self)
            case .DailyStates:
                vc = UIStoryboard.instantiate(viewControllerClass: DailyStatsTableViewController.self)
            case .Stats:
                vc = UIStoryboard.instantiate(viewControllerClass: PillsStatsViewController.self)
            default: return nil
        }
        
        
        // store relative enum to view controller
        _dict[vc!] = value
        return vc!
    }
}

enum HomePage: Int {
    static let allValues = [DailyPill, DailyStates]//, Stats]
    
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