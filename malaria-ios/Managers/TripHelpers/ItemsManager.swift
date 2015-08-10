import Foundation

/// Manages trip items
public class ItemsManager : CoreDataContextManager{
    let trip: Trip
    
    /// Init
    public init(context: NSManagedObjectContext, trip: Trip){
        self.trip = trip
        super.init(context: context)
    }
    
    /// Adds a new item to the trip
    ///
    /// :param: `String`: name of the item
    /// :param: `Int64`: quantity
    public func addItem(name: String, quantity: Int64){
        if let i = findItem(name){
            Logger.Info("Updating quantity for an existing item")
            i.add(quantity)
        }else{
            let item = Item.create(Item.self, context: self.context)
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
    /// :param: `String`: name of the item (case insensitive)
    /// :param: `[Item] optional` cached list of items
    ///
    /// :returns: `Item?`:
    public func findItem(name: String, listItems: [Item]? = nil) -> Item?{
        let items = listItems != nil ? listItems! : getItems()
        return items.filter({$0.name.lowercaseString == name.lowercaseString}).first
    }
    
    /// Checkmark the items
    ///
    /// :param: `[String]`: names of the items (case insensitive)
    public func checkItem(names: [String]){
        let listItems = getItems()
        names.map({ self.findItem($0, listItems: listItems)?.check = true })
        CoreDataHelper.sharedInstance.saveContext(self.context)
    }
    
    /// Remove the checkmark
    ///
    /// :param: `[String]`: names of the items (case insensitive)
    public func uncheckItem(names: [String]){
        let listItems = getItems()
        names.map({ self.findItem($0, listItems: listItems)?.check = false })
        CoreDataHelper.sharedInstance.saveContext(self.context)
    }
    
    /// Toggle the checkmark
    ///
    /// :param: `[String]`: name of the items (case insensitive)
    public func toggleCheckItem(names: [String]){
        let listItems = getItems()
        names.map({ self.findItem($0, listItems: listItems)?.toogle() })
        CoreDataHelper.sharedInstance.saveContext(self.context)
    }
    
    /// Removes a item from the trip
    ///
    /// If quantity is specified, it only removes the specified number,
    /// if not, removes the item completly
    ///
    /// :param: `String`: name of the item
    /// :param: `Int64 optional` quantity
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