//
//  Item.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 22/06/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import CoreData

public class Item: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var quantity: Int64
    @NSManaged public var associated_with: Trip

}
