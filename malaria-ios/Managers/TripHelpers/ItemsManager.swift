import Foundation

class ItemsManager : Manager{

    var trip: Trip!
    
    init(trip: Trip){
        self.trip = trip
    }
    
    /// add a new item to the trip
    ///
    /// :param: `String`: name of the item
    /// :param: `Int64`: quantity
    func addItem(name: String, quantity: Int64){
        if let i = findItem(name){
            Logger.Info("Updating quantity for an existing item")
            i.add(quantity)
        }else{
            Logger.Info("Adding \(quantity) \(name)")
            var item = Item.create(Item.self, context: self.context)
            item.name = name
            item.number = quantity
            
            var newArray = getItems()
            newArray.append(item)
            trip.items = NSMutableSet(array: newArray)
        }
        
        CoreDataHelper.sharedInstance.saveContext(self.context)
    }
    
    /// Returns an item from the trip if exists
    ///
    /// :param: `String`: name of the item
    /// :returns: `Item?`:
    func findItem(name: String) -> Item?{
        var currentItems = getItems()
        currentItems = currentItems.filter({$0.name.lowercaseString == name.lowercaseString})
        
        return currentItems.count == 0 ? nil : currentItems[0]
    }
    
    /// Removes a item from the trip
    ///
    /// If quantity is specified, it only removes the specified number
    ///
    /// :param: `String`: name of the item
    /// :param: `Int64` optional: quantity
    func removeItem(name: String, quantity: Int64 = Int64.max){
        if let i = findItem(name){
            
            i.remove(quantity)
            if i.number == 0{
                trip.items.removeObject(i)
                i.deleteFromContext(self.context)
            }
            
            CoreDataHelper.sharedInstance.saveContext(self.context)
            return
        }
        
        Logger.Error("Item not found")
    }
    
    
    /// Returns all items from the trip
    ///
    /// :returns: `[Item]`: Array of items
    func getItems() -> [Item]{
        return trip.items.convertToArray()
    }
}