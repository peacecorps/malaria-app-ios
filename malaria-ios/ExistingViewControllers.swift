//
//  ExistingViewControllers.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 25/05/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation

enum ExistingViewControllers : String{
    //setup screen when the application launches for the first time
    case SetupScreenViewController = "SetupScreenViewController"
    
    //main manager of paged view controller
    case PagesManagerViewController = "PagesManagerViewController"
    
    //first button
    case DidTakePillViewController = "DidTakePillViewController"
    
    //third button
    case InfoViewController = "InfoViewController"
}