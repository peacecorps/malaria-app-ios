import Foundation
import CoreData

extension Trip{
    func itemsManager(context: NSManagedObjectContext) -> ItemsManager{
        return ItemsManager(context: context, trip: self)
    }
    
    func notificationManager(context: NSManagedObjectContext) -> TripNotificationsManager{
        return TripNotificationsManager(context: context, trip: self)
    }
}
