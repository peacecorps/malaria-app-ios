import Foundation
import CoreData

@objc(Registry)
public class Registry: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var tookMedicine: Bool
}
