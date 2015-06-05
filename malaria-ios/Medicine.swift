import Foundation
import CoreData

@objc(Medicine)
class Medicine: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var weekly: Bool
    @NSManaged var currentStreak: Int
    @NSManaged var registries: NSSet

}
