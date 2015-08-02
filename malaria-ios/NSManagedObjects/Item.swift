import Foundation
import CoreData

public class Item: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var quantity: Int64
    @NSManaged public var associated_with: Trip

}
