import Foundation
import CoreData

public extension Trip{
    /// Returns an object responsible for managing the items
    public var itemsManager: ItemsManager{
        return ItemsManager(trip: self)
    }
    
    /// Returns an object responsible for managing the notifications
    public var notificationManager: TripNotificationsManager{
        return TripNotificationsManager(trip: self)
    }
}
