import Foundation
import CoreData

public class Registry: NSManagedObject {

    @NSManaged public var date: NSDate
    @NSManaged public var tookMedicine: Bool
}
