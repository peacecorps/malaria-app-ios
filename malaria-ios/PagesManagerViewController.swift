import Foundation
import UIKit

class PagesManagerViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var _controllerEnum: PagesEnum = PagesEnum()
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var mediceButton: UIButton!
    @IBOutlet weak var planTripButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    var pageViewController : UIPageViewController!
    
    private var _dict: [UIViewController: PagesEnum] = [:]
    private let _storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let defaultPage = getController(_controllerEnum)!
        pageViewController!.setViewControllers([defaultPage], direction: .Forward, animated: false, completion: nil)
        
        //put it relative to the settings button
        pageViewController!.view.frame = CGRectMake(0, 50, view.frame.size.width, view.frame.size.height - 50 - 50) //pageControl.frame.size.height);
        
        //add pageViewController
        pageViewController.willMoveToParentViewController(self)
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
        setupPageControl()
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.yellowColor()
        appearance.currentPageIndicatorTintColor = UIColor.redColor()
        appearance.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func homeButtonHandler(){
        logger("pressed home button")
        GoToPage(PagesEnum.Home)
    }
    
    @IBAction func tripButtonHandler(){
        logger("pressed trip button")
        GoToPage(PagesEnum.Transport)
    }
    
    @IBAction func infoButtonHandler(){
        logger("pressed info button")
        GoToPage(PagesEnum.Info)
    }
    
    @IBAction func settingsButtonHandler(){
        logger("pressed settings button")
    }
    
    private func GoToPage(index : PagesEnum){
        if _controllerEnum == index{
            return
        }
        
        let reverse = _controllerEnum.rawValue > index.rawValue
        
        _controllerEnum = index
        let page = getController(index)!
        pageViewController!.setViewControllers([page], direction: reverse ? .Reverse : .Forward, animated: true, completion: nil)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return PagesEnum.allValues.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return _controllerEnum.rawValue
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return getController(_dict[viewController]!.previousIndex())
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return getController(_dict[viewController]!.nextIndex())
    }
    
    
    func updateCurrentViewHandler(toIndex: Int){
        _controllerEnum = PagesEnum(rawValue: toIndex)!
        //_controllerEnum = toIndex
        logger("Update buttons to translucent")
    }
    
    // *** PRIVATE METHODS
    private func getController(value: PagesEnum) -> UIViewController? {
        var vc: PageManagerContentViewController?
        
        switch value {
            case .Home:
                vc = ExistingViewControllers.DidTakePillViewController.instanciateViewController() as! DidTakePillsViewController
            case .Transport:
                vc = ExistingViewControllers.PillsStatsViewController.instanciateViewController() as! PillsStatsViewController
            case .Info:
                vc = ExistingViewControllers.InfoViewController.instanciateViewController() as! InfoViewController
            default: return nil
        }
        
        vc!.pageIndex = value.rawValue
        vc!.changeIndicatorHandler = updateCurrentViewHandler
        
        // store relative enum to view controller
        _dict[vc!] = value
        return vc!
    }
}

enum PagesEnum: Int {
    static let allValues = [Home, Transport, Info]
    
    case Nil = -1, Home, Transport, Info
    
    init() {
        self = .Home
    }
    
    func previousIndex() -> PagesEnum {
        return PagesEnum(rawValue: rawValue-1)!
    }
    
    func nextIndex() -> PagesEnum {
        var value = rawValue+1
        if value > PagesEnum.allValues.count-1 { value = Nil.rawValue }
        return PagesEnum(rawValue: value)!
    }
}