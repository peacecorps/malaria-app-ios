import Foundation

public class MedicineStats : CoreDataContextManager{
    let medicine: Medicine
    
    init(context: NSManagedObjectContext, medicine: Medicine){
        self.medicine = medicine
        super.init(context: context)
    }
    
    /// Returns the number of pills taken between two dates
    ///
    /// :param: `NSDate optional`: first date (by default is NSDate.min)
    /// :param: `NSDate optional`: second date (by default is NSDate.max)
    /// :param: `[Registry] optional`: cached list of entries
    /// :returns: `Int`: Number of pills
    public func numberPillsTaken(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max, registries: [Registry]? = nil) -> Int{
        if let reg = registries{
            return reg.filter({$0.tookMedicine}).count
        }
        
        
        return medicine.registriesManager(context).getRegistries(date1: date1, date2: date2).filter({$0.tookMedicine}).count
    }
    
    /// Returns the number of pills that the user should have taken between two dates
    ///
    /// :param: `NSDate optional`: first date (by default is NSDate.min)
    /// :param: `NSDate optional`: second date (by default is NSDate.max)
    /// :param: `[Registry] optional`: cached list of entries
    /// :returns: `Int`: Number of supposed pills
    public func numberSupposedPills(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max, registries: [Registry]? = nil) -> Int{
        if date1 > date2 {
            return numberSupposedPills(date1: date2, date2: date1, registries: registries)
        }
        
        let entries = registries != nil ? registries! : medicine.registriesManager(context).getRegistries(mostRecentFirst: false)
        if (entries.count == 0){
            return 0
        }
        
        let d1: NSDate = date1 == NSDate.min ? entries.first!.date : date1
        let d2: NSDate = date2 == NSDate.max ? entries.last!.date : date2

        let numDays = (d2 - d1) + 1
        
        return  medicine.isDaily() ?  numDays : Int(ceil(Float(numDays)/7))
    }
    
    /// Returns the number of pills that the user should have taken between two dates
    ///
    //// Adherence = numberPillsTaken/SupposedPills
    ///
    /// :param: `NSDate optional`: first date (by default is NSDate.min)
    /// :param: `NSDate optional`: second date (by default is NSDate.max)
    /// :param: `[Registry] optional`: cached list of entries
    /// :returns: `Float`: Pill adherence
    public func pillAdherence(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max, registries: [Registry]? = nil) -> Float{        
        let supposedPills = numberSupposedPills(date1: date1, date2: date2, registries: registries)
        
        if(supposedPills == 0){
            return 1.0
        }
        
        let pillsTaken = numberPillsTaken(date1: date1, date2: date2, registries: registries)
        
        return Float(pillsTaken)/(Float(supposedPills))
    }
    
    /// Returns the current Pill Streak of the user.
    ///
    /// If the user misses a day, the streak will be reset to 0
    ///
    /// :param: `NSDate optional`: first date (by default is NSDate.min)
    /// :param: `NSDate optional`: second date (by default is NSDate.max)
    /// :returns: `Int`: Pill streak
    public func pillStreak(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max) -> Int{
        var result = 0
        
        let isDaily = medicine.isDaily()
        var previousDate: NSDate?
        for r in medicine.registriesManager(context).getRegistries(date1: date1, date2: date2, mostRecentFirst: true){
            //check for missing entries
            if let previousD = previousDate{
                if (isDaily && !(previousD - 1.day).sameDayAs(r.date)) ||
                    (!isDaily && !(previousD - 7.day).sameWeekAs(r.date))
                {
                    return result
                }
            }
            
            if r.tookMedicine{
                result += 1
            }else{
                return result
            }
            
            previousDate = r.date
        }
        
        return result
    }
    
    /// returns pill adhrence in a month
    /// if there are no entries in that month return 0
    /// if there are entries in that month, truncate to the oldest and the most recent date to account when the user started tracking
    ///
    /// :param: `NSDate`: The month
    /// :param: `Registries`: Previously calculated entries. Must be sorted oldest to recent
    /// :returns: `Float`: pill adherence for the month
    public func pillAdherence(month: NSDate, registries: [Registry]? = nil) -> Float{
        let registriesManager = medicine.registriesManager(context)
        let entries = registries != nil ? registries! : registriesManager.getRegistries(mostRecentFirst: false)
        
        if entries.count == 0 {
            return 1
        }
        
        let oldestDate = entries.first!.date
        let mostRecentEntry = entries.last!.date
        
        let startMonth = NSDate.from(month.year, month: month.month, day: 1)
        let endMonth = NSDate.from(month.year, month: month.month, day: month.endOfCurrentMonth)
        
        if startMonth.happensMonthsBefore(oldestDate) || startMonth.happensMonthsAfter(mostRecentEntry) {
            return 1.0
        }
        
        let day1 = max(startMonth, oldestDate)
        let day2 = min(endMonth, mostRecentEntry)
        
        return pillAdherence(date1: day1, date2: day2, registries: registriesManager.filter(entries, date1: day1, date2: day2))
    }
    
}