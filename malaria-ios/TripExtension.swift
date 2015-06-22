import Foundation
import CoreData

extension Trip{
    var notificationManager: TripNotificationsManager { get { return TripNotificationsManager(trip: self) }}
    
    convenience init(context: NSManagedObjectContext) {
        let entityName = getSimpleClassName(self.dynamicType)
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
    func addItem(name: String, quantity: Int){
        var currentItems = getItems()
        
        if let i = findItem(name){
            Logger.Info("Updating quantity for an existing item")
            i.number += quantity
            
            return
        }
        
        let item = Item(context: CoreDataHelper.sharedInstance.backgroundContext!)
        item.name = name
        item.number = quantity
        
        currentItems.append(item)
        
        items = NSSet(array: currentItems)
        
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    func findItem(name: String) -> Item?{
        var currentItems = getItems()
        currentItems = currentItems.filter({$0.name == name})
        
        return currentItems.count == 0 ? nil : currentItems[0]
    }
    
    func getItems() -> [Item]{
        return items.convertToArray()
    }
}
