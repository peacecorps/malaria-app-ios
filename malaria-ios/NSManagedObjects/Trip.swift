import Foundation
import CoreData

public class Trip: NSManagedObject {

    @NSManaged public var medicine: String
    @NSManaged public var cash: Int64
    @NSManaged public var reminderDate: NSDate
    @NSManaged public var location: String
    @NSManaged public var items: NSSet

}