//
//  StoryboardManager.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 02/07/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard{

    ///Converts MyTarget.ClassName to ClassName
    class func getSimpleClassName(c: AnyClass) -> String {
        return c.description().componentsSeparatedByString(".").last!
    }
    
    class func instantiate <C:UIViewController> (named: String = "Main", viewControllerClass: C.Type) -> C {
        return UIStoryboard(name: named, bundle: nil).instantiateViewControllerWithIdentifier(UIStoryboard.getSimpleClassName(viewControllerClass)) as! C
    }
    
    class func instantiate (named: String = "Main", viewControllerName: String) -> UIViewController {
        return UIStoryboard(name: named, bundle: nil).instantiateViewControllerWithIdentifier(viewControllerName) as! UIViewController
    }
}