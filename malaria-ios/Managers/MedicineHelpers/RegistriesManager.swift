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
    /// :returns: `Bool`: True if the user took a pill in that day or week
    public func tookMedicine(at: NSDate) -> Bool{
        for r in allRegistriesInPeriod(at){
            if r.tookMedicine{
                return true
            }
        }
        
        return false
    }
    
    
    /// Returns the list of entries that happens in that day or in that week (if daily or weekly pill)
    ///
    /// :param: `NSDate`: the date
    /// :returns: `[Registry]` all the entries
    public  func allRegistriesInPeriod(at: NSDate) -> [Registry] {
        var result = [Registry]()
        
        if medicine.isDaily(){
            if let r = findRegistry(at){
                result.append(r)
            }
        }else if medicine.isWeekly(){
            for r in getRegistries(date1: at - 8.day, date2: at + 8.day){
                if NSDate.areDatesSameWeek(at, dateTwo: r.date){
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
    /// already an entry in that day if daily pill or in that week if weekly pill
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
        
        if (tookMedicine && self.tookMedicine(date)){
            Logger.Warn("Already took the pill in that pill/week. Aborting")
            return false
        }
        
        //check if there is already a registry
        var registry : Registry? = findRegistry(date)
        
        if let r = registry{
            if(!modifyEntry){
                Logger.Info("Can't modify entry. Aborting")
                return false
            }
            
            Logger.Info("Found entry same date. Modifying entry")
            
            let previous = r.tookMedicine
            r.tookMedicine = tookMedicine
            
            //update future entries
            if(previous != r.tookMedicine){
                if r.tookMedicine {
                    getRegistries(date1: date, mostRecentFirst: false).map({$0.numberPillsTaken += 1})
                }else{
                    getRegistries(date1: date, mostRecentFirst: false).map({$0.numberPillsTaken -= 1})
                }
            }
            
            
        }else{
            registry = Registry.create(Registry.self, context: context)
            registry!.date = date
            registry!.tookMedicine = tookMedicine
            registry!.numberPillsTaken = Int64(medicine.stats(context).numberPillsTaken(date2: date))
            
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
        
        if NSDate.areDatesSameDay(date1, dateTwo: date2){
            return registries.filter({NSDate.areDatesSameDay($0.date, dateTwo: date1)})
        }
        
        return registries.filter({$0.date >= date1 && $0.date <= date2})
    }

    /// Returns entry in the specified date if exists
    ///
    /// :param: `NSDate`: date
    /// :returns: `Registry?`
    public func findRegistry(date: NSDate) -> Registry?{
        return getRegistries(date1: date, date2: date).first
    }
}