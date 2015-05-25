//
//  PagesManagerViewController.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 25/05/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import UIKit

class PagesManagerViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var _controllerEnum: ControllerEnum = ControllerEnum()
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var mediceButton: UIButton!
    @IBOutlet weak var planTripButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    var pageViewController : UIPageViewController!
    
    private var _dict: [UIViewController: ControllerEnum] = [:]
    private let _storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        pageControl.numberOfPages = ControllerEnum.allValues.count
        
        
        //setViewControllers([getController(_controllerEnum)!], direction: .Forward, animated: false, completion: nil)
    }
    
    // UIPaveViewController and UIPageViewControllerDataSource protocols
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return ControllerEnum.allValues.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        //pageControl.currentPage = _controllerEnum.rawValue
        return 0//_controllerEnum.rawValue
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return getController(_dict[viewController]!.prevIndex())
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return getController(_dict[viewController]!.nextIndex())
    }
    
    
    func updateCurrentViewHandler(toIndex: Int){
        pageControl.currentPage = toIndex
    }
    
    // *** PRIVATE METHODS
    private func getController(value: ControllerEnum) -> UIViewController? {
        var vc: PageManagerContentViewController?
        
        switch value {
            case .Meds:
                vc = _storyboard.instantiateViewControllerWithIdentifier("DidTakePillsViewController") as! DidTakePillsViewController
            case .Transport:
                vc = _storyboard.instantiateViewControllerWithIdentifier("PillsStatsViewController") as! PillsStatsViewController
            case .Info:
                vc = _storyboard.instantiateViewControllerWithIdentifier("InfoViewController") as! InfoViewController
            default: return nil
        }
        
        vc!.pageIndex = value.rawValue
        vc!.changeIndicatorHandler = updateCurrentViewHandler
        
        // store relative enum to view controller
        _dict[vc!] = value
        return vc!
    }
}

private enum ControllerEnum: Int {
    static let allValues = [Meds, Transport, Info]
    
    case Nil = -1, Meds, Transport, Info
    
    init() {
        self = .Meds
    }
    
    func prevIndex() -> ControllerEnum {
        return ControllerEnum(rawValue: rawValue-1)!
    }
    
    func nextIndex() -> ControllerEnum {
        var value = rawValue+1
        if value > ControllerEnum.allValues.count-1 { value = Nil.rawValue }
        return ControllerEnum(rawValue: value)!
    }
}