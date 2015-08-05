import Foundation

public class ItemsManager : CoreDataContextManager{

    let trip: Trip
    
    init(context: NSManagedObjectContext, trip: Trip){
        self.trip = trip
        super.init(context: context)
    }
    
    /// add a new item to the trip
    ///
    /// :param: `String`: name of the item
    /// :param: `Int64`: quantity
    public func addItem(name: String, quantity: Int64){
        if let i = findItem(name){
            Logger.Info("Updating quantity for an existing item")
            i.add(quantity)
        }else{
            var item = Item.create(Item.self, context: self.context)
            item.name = name
            item.quantity = quantity
            
            var newArray = getItems()
            newArray.append(item)
            trip.items = NSSet(array: newArray)
        }
        
        CoreDataHelper.sharedInstance.saveContext(self.context)
    }
    
    /// Returns an item from the trip if exists
    ///
    /// :param: `String`: name of the item
    /// :param: `[Item] optional` cached list of items
    /// :returns: `Item?`:
    public func findItem(name: String, listItems: [Item]? = nil) -> Item?{
        let items = listItems != nil ? listItems! : getItems()
        return items.filter({$0.name.lowercaseString == name.lowercaseString}).first
    }
    
    
    /// Checkmark the items
    ///
    /// :param: `[String]`: list of items name
    public func checkItem(names: [String]){
        let listItems = getItems()
        names.map({ self.findItem($0, listItems: listItems)?.check = true })
        CoreDataHelper.sharedInstance.saveContext(self.context)
    }
    
    /// Remove the checkmark
    ///
    /// :param: `[String]`: list of items name
    public func uncheckItem(names: [String]){
        let listItems = getItems()
        names.map({ self.findItem($0, listItems: listItems)?.check = false })
        CoreDataHelper.sharedInstance.saveContext(self.context)
    }
    
    /// Toggle the checkmark
    ///
    /// :param: `[String]`: list of items name
    public func toggleCheckItem(names: [String]){
        let listItems = getItems()
        for name in names {
            if let item = self.findItem(name, listItems: listItems) {
                item.check = !item.check
            }
        }
        CoreDataHelper.sharedInstance.saveContext(self.context)
    }
    
    
    /// Removes a item from the trip
    ///
    /// If quantity is specified, it only removes the specified number
    ///
    /// :param: `String`: name of the item
    /// :param: `Int64` optional: quantity
    public func removeItem(name: String, quantity: Int64 = Int64.max){
        if let i = findItem(name){
            i.remove(quantity)
            if i.quantity == 0{
                var array: [Item] = trip.items.convertToArray()
                array.removeAtIndex(find(array, i)!)
                trip.items = NSSet(array: array)
                i.deleteFromContext(self.context)
            }
            
            CoreDataHelper.sharedInstance.saveContext(self.context)
        }else {
            Logger.Error("Item not found")
        }
    }
    
    
    /// Returns all items from the trip
    ///
    /// :returns: `[Item]`: Array of items
    public func getItems() -> [Item]{
        return trip.items.convertToArray()
    }
}