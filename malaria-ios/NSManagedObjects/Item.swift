import Foundation
import CoreData

/// Trip Item
public class Item: NSManagedObject {

    @NSManaged public var check: Bool
    @NSManaged public var name: String
    @NSManaged public var quantity: Int64
    @NSManaged public var associated_with: Trip

}
