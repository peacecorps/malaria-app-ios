//
//  Manager.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 09/07/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation

class Manager{
    var context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext!){
        self.context = context
    }
}