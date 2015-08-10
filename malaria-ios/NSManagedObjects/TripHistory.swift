import Foundation
import CoreData

/// Trip history class containing only the location
public class TripHistory: NSManagedObject {

    @NSManaged var location: String

}
