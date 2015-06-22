//
//  Post.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 21/06/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import CoreData

class Post: NSManagedObject {

    @NSManaged var owner_rev_post: Int
    @NSManaged var owner_rev: Int
    @NSManaged var title: String
    @NSManaged var post_description: String
    @NSManaged var created_at: String
    @NSManaged var id: Int
    @NSManaged var title_change: Bool
    @NSManaged var description_change: Bool
    @NSManaged var updated_at: String
    @NSManaged var contained_in: NSManagedObject
}
