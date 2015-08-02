import Foundation
import CoreData

public extension Trip{
    /// returns an object responsible for managing the items
    /// param: `NSManagedObjectContext`: context
    /// returns: `ItemsManager`
    public func itemsManager(context: NSManagedObjectContext) -> ItemsManager{
        return ItemsManager(context: context, trip: self)
    }
    
    /// returns an object responsible for managing the notifications
    /// param: `NSManagedObjectContext`: context
    /// returns: `TripNotificationsManager`
    public func notificationManager(context: NSManagedObjectContext) -> TripNotificationsManager{
        return TripNotificationsManager(context: context, trip: self)
    }
}
