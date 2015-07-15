//
//  TabbedBarController.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 02/07/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import UIKit

class TabbedBarController : UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().barTintColor = UIColor.clearColor()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }
    
    
}