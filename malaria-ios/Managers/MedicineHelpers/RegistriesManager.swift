import Foundation

public class RegistriesManager : CoreDataContextManager{
    let medicine: Medicine
    
    init(context: NSManagedObjectContext, medicine: Medicine){
        self.medicine = medicine
        super.init(context: context)
    }

    /// Check if the pill was already taken in that day if daily pill or in that week if weekly pill
    ///
    /// :param: `NSDate`: the date
    /// :param: `[Registry] optional`: Cached vector of entries, most recent first
    /// :returns: `Registry?`: Confliting registry
    public func tookMedicine(at: NSDate, registries: [Registry]? = nil) -> Registry?{
        for r in allRegistriesInPeriod(at, registries: registries){
            if r.tookMedicine{
                return r
            }
        }
        
        return nil
    }
    
    
    /// Returns the list of entries that happens in that day or in that week (if daily or weekly pill)
    ///
    /// :param: `NSDate`: the date
    /// :param: `[Registry] optional`: Cached vector of entries, most recent first
    /// :returns: `[Registry]` all the entries
    public  func allRegistriesInPeriod(at: NSDate, registries: [Registry]? = nil) -> [Registry] {
        var result = [Registry]()
        
        if medicine.isDaily(){
            if let r = findRegistry(at, registries: registries){
                result.append(r)
            }
        }else if medicine.isWeekly(){
            let (day1, day2) = (at - 8.day, at + 8.day)
            let entries = registries != nil ? filter(registries!, date1: day1, date2: day2) : getRegistries(date1: day1, date2: day2)
            
            for r in entries {
                if at.sameWeekAs(r.date){
                    result.append(r)
                }
            }
        }
        
        return result
    }

    /// Returns the most recent entry for that pill if there is
    ///
    /// :returns: `Registry?`
    public func mostRecentEntry() -> Registry?{
        return getRegistries().first
    }
    
    /// Returns the oldest entry for that pill if there is
    ///
    /// :returns: `Registry?`
    public func oldestEntry() -> Registry?{
        return getRegistries(mostRecentFirst: false).first
    }

    /// Adds a new entry for that pill
    ///
    /// It will return false if trying to add entries in the future
    /// If modify flag is set to false, It will return false it there is
    /// already an entry in that day if daily pill or in that week if weekly pill.
    ///
    /// If weekly pill, if there is already an entry in that week and if modifyEntry is true,
    /// that same entry is replaced by a new one
    ///
    /// :param: `NSDate`: the date of the entry
    /// :param: `Bool`: if the user took medicine
    /// :param: `Bool` optional: overwrite previous entry (by default is false)
    /// :returns: `Bool`: true if success, false if not
    public func addRegistry(date: NSDate, tookMedicine: Bool, modifyEntry: Bool = false) -> Bool{
        if date > NSDate() {
            Logger.Error("Cannot change entries in the future")
            return false
        }
        
        if let conflitingTookMedicineEntry = self.tookMedicine(date) {
            if tookMedicine && !modifyEntry && conflitingTookMedicineEntry.date.sameDayAs(date) {
                Logger.Warn("Found equivalent entry on same day")
                return true
            } else if modifyEntry {
                //remove previous, whether it is weekly or daily (if daily we could just change the entry)
                removeEntry(conflitingTookMedicineEntry)
                
                //create new one
                let registry = Registry.create(Registry.self, context: context)
                registry.date = date
                registry.tookMedicine = tookMedicine
                
                var newRegistries: [Registry] = medicine.registries.convertToArray()
                newRegistries.append(registry)
                medicine.registries = NSSet(array: newRegistries)
                NSNotificationEvents.DataUpdated(registry)
                CoreDataHelper.sharedInstance.saveContext(context)
                
                return true
            }
            
            Logger.Warn("Can't modify entry, aborting")
            return false
        }
        
        //check if there is already a registry
        var registry : Registry? = findRegistry(date)
        
        if let r = registry{
            if r.tookMedicine && tookMedicine || !r.tookMedicine && !tookMedicine{
                Logger.Warn("Found equivalent entry")
                return true
            } else if !modifyEntry {
                Logger.Info("Can't modify entry. Aborting")
                return false
            }
            
            Logger.Info("Found entry same date. Modifying entry")
            r.tookMedicine = tookMedicine
        } else {
            registry = Registry.create(Registry.self, context: context)
            registry!.date = date
            registry!.tookMedicine = tookMedicine
            
            var newRegistries: [Registry] = medicine.registries.convertToArray()
            newRegistries.append(registry!)
            medicine.registries = NSSet(array: newRegistries)
        }
        
        NSNotificationEvents.DataUpdated(registry!)
        CoreDataHelper.sharedInstance.saveContext(context)
        
        return true
    }

    /// Returns entries between the two specified dates
    ///
    /// :param: `NSDate`: date1
    /// :param: `NSDate`: date2
    /// :param: `Bool` optional: if first element of result should be the most recent entry. (by default is true)
    /// :returns: `[Registry]`
    public func getRegistries(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max, mostRecentFirst: Bool = true) -> [Registry]{
        var array : [Registry] = medicine.registries.convertToArray()
        
        //make sure that date2 is always after date1
        if date1 > date2 {
            return getRegistries(date1: date2, date2: date1, mostRecentFirst: mostRecentFirst)
        }
        
        //sort entries chronologically
        let registries = mostRecentFirst ? array.sorted({$0.date > $1.date}) : array.sorted({$0.date < $1.date})
        
        return filter(registries, date1: date1, date2: date2)
    }
    
    public func filter(registries: [Registry], date1: NSDate, date2: NSDate)  -> [Registry]{
        if date1.sameDayAs(date2){
            return registries.filter({$0.date.sameDayAs(date1)})
        }
        
        return registries.filter({ ($0.date > date1 && $0.date < date2) || $0.date.sameDayAs(date1) || $0.date.sameDayAs(date2)})
    }

    /// Returns entry in the specified date if exists
    ///
    /// :param: `NSDate`: date
    /// :param: `[Registry] optional`: Cached vector of entries, most recent first
    /// :returns: `Registry?`
    public func findRegistry(date: NSDate, registries: [Registry]? = nil) -> Registry?{
        return registries != nil ? filter(registries!, date1: date, date2: date).first : getRegistries(date1: date, date2: date).first
    }
    
    /// Returns last day when the user taken the medicine
    ///
    /// :param `[Registry]? optional`: cached list of entries. Must be sorted from most recent to least recent
    /// :returns: `NSDate?`
    
    func lastPillDate(registries: [Registry]? = nil) -> NSDate?{
        let entries = registries != nil ? registries! : getRegistries(mostRecentFirst: true)
        
        for r in entries{
            if r.tookMedicine{
                return r.date
            }
        }
        return nil
    }
    
    func removeEntry(registry: Registry){
        var newRegistries: [Registry] = medicine.registries.convertToArray().filter({!$0.date.sameDayAs(registry.date)})
        medicine.registries = NSSet(array: newRegistries)

        registry.deleteFromContext(context)
        NSNotificationEvents.DataUpdated(nil)
        CoreDataHelper.sharedInstance.saveContext(context)
    }
}