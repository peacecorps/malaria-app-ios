import Foundation
import CoreData

/// registry containing the date and boolean indicating if the user took the medicine on that day
public class Registry: NSManagedObject {

    @NSManaged public var date: NSDate
    @NSManaged public var tookMedicine: Bool
}