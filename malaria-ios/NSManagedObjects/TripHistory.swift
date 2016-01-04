import Foundation
import CoreData

/// Trip history class containing only the location
public class TripHistory: NSManagedObject {

    @NSManaged public var location: String
    @NSManaged public var timestamp: NSDate
}
