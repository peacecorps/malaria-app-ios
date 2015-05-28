import Foundation
import UIKit

class PagesManagerViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var mediceButton: UIButton!
    @IBOutlet weak var planTripButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    //can be home, trip or info, by default is Home
    var type: PageType = PageType()
    
    //if HomePage
    var pageViewController : UIPageViewController!
    private var _controllerEnum: HomePagesEnum?
    private var _dict: [UIViewController: HomePagesEnum]? = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        
        let contentFrame: CGRect = CGRectMake(0, 50, view.frame.size.width, view.frame.size.height - 50 - 50)
        var contentView: UIViewController?
        
        switch type{
        case .Home:
            //initialize controll variables
            _controllerEnum = HomePagesEnum()
            _dict = [UIViewController: HomePagesEnum]()

            
            pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
            pageViewController!.dataSource = self
            
            
            let defaultPage = getController(_controllerEnum!)!
            pageViewController!.setViewControllers([defaultPage], direction: .Forward, animated: false, completion: nil)
            
            //put it relative to the settings button
            pageViewController!.view.frame = contentFrame
            
            
            let appearance = UIPageControl.appearance()
            appearance.pageIndicatorTintColor = UIColor.yellowColor()
            appearance.currentPageIndicatorTintColor = UIColor.redColor()
            appearance.backgroundColor = UIColor.clearColor()
            

            contentView = pageViewController
            
        case .Trip:
            let tripViewController = ExistingViewsControllers.PlanTripViewController.instanciateViewController() as! PlanTripViewController
            tripViewController.view.frame = contentFrame
            contentView = tripViewController
            
        case .Info:
            let infoViewController = ExistingViewsControllers.InfoViewController.instanciateViewController() as! InfoViewController
            infoViewController.view.frame = contentFrame
            contentView = infoViewController
        }
        
        //add pretended view to the hierarchy
        if let pretendedView = contentView{
            pretendedView.willMoveToParentViewController(self)
            addChildViewController(pretendedView)
            view.addSubview(pretendedView.view)
            pretendedView.didMoveToParentViewController(self)
        }else{
            logger("Couldn't load pageManagerContent")
        }
    }
    
    @IBAction func homeButtonHandler(){
        let view = ExistingViewsControllers.PagesManagerViewController.instanciateViewController() as! PagesManagerViewController
        changePageManagerContent(view, typePage: PageType.Home)
    }
    
    @IBAction func tripButtonHandler(){
        let view = ExistingViewsControllers.PagesManagerViewController.instanciateViewController() as! PagesManagerViewController
        changePageManagerContent(view, typePage: PageType.Trip)
    }
    
    @IBAction func infoButtonHandler(){
        let view = ExistingViewsControllers.PagesManagerViewController.instanciateViewController() as! PagesManagerViewController
        changePageManagerContent(view, typePage: PageType.Info)
    }
    
    @IBAction func settingsButtonHandler(){
        presentViewController(
            ExistingViewsControllers.SetupScreenViewController.instanciateViewController(),
            animated: true,
            completion: nil
        )
    }
    
    private func changePageManagerContent(view: PagesManagerViewController, typePage: PageType){
        view.type = typePage
        
        presentViewController(
            view,
            animated: false,
            completion: nil
        )
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return HomePagesEnum.allValues.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return _controllerEnum!.rawValue
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return getController(_dict![viewController]!.previousIndex())
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return getController(_dict![viewController]!.nextIndex())
    }
    
    private func getController(value: HomePagesEnum) -> UIViewController? {
        var vc: UIViewController?
        
        switch value {
            case .DailyPill:
                vc = ExistingViewsControllers.DidTakePillViewController.instanciateViewController() as! DidTakePillsViewController
            case .DailyStates:
                vc = ExistingViewsControllers.DailyStatsViewController.instanciateViewController() as! DailyStatsViewController
            case .Stats:
                vc = ExistingViewsControllers.PillsStatsViewController.instanciateViewController() as! PillsStatsViewController
            default: return nil
        }
        
        //initialize views here if needed
        
        // store relative enum to view controller
        _dict![vc!] = value
        return vc!
    }
}

enum PageType: Int{
    case Home, Trip, Info
    init(){
        self = .Home
    }
}

enum HomePagesEnum: Int {
    static let allValues = [DailyPill, DailyStates, Stats]
    
    case Nil = -1, DailyPill, DailyStates, Stats
    
    init() {
        self = .DailyPill
    }
    
    func previousIndex() -> HomePagesEnum {
        return HomePagesEnum(rawValue: rawValue-1)!
    }
    
    func nextIndex() -> HomePagesEnum {
        var value = rawValue+1
        if value > HomePagesEnum.allValues.count-1 { value = Nil.rawValue }
        return HomePagesEnum(rawValue: value)!
    }
}