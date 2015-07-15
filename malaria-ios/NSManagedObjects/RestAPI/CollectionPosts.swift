//
//  CollectionPosts.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 26/06/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import CoreData

public class CollectionPosts: NSManagedObject {

    @NSManaged public var posts: NSMutableSet

}
