import Foundation
import UIKit

class CachedStatistics : NSObject{
    static let sharedInstance = CachedStatistics()

    private var context: NSManagedObjectContext!
    
    var medicine: Medicine!
    var registriesManager: RegistriesManager!
    var statsManager: MedicineStats!
    
    var registries = [Registry]()

    //For PillStatsViewController
    var isMonthlyAdherenceDataUpdated = false
    var isGraphViewDataUpdated = false
    var isCalendarViewDataUpdated = false
    
    var tookMedicine: [NSDate: Bool] = [:]
    var monthAdhrence = [(NSDate, Float)]()
    var adherencesPerDay = [(NSDate, Float)]()
    
    //For dailyStats
    var isDailyStatsUpdated = false
    
    var lastMedicine: NSDate?
    var todaysPillStreak: Int = 0
    var todaysAdherence: Float = 0
    
    override init(){
        super.init()
        NSNotificationEvents.ObserveDataUpdated(self, selector: "resetFlags")
    }
    
    deinit{
        NSNotificationEvents.UnregisterAll(self)
    }
    
    func resetFlags(){
        isMonthlyAdherenceDataUpdated = false
        isGraphViewDataUpdated = false
        isCalendarViewDataUpdated = false
        isDailyStatsUpdated = false
    }
    
    func refreshContext(){
        self.context = CoreDataHelper.sharedInstance.createBackgroundContext()!
        
        medicine = MedicineManager(context: context).getCurrentMedicine()
        registriesManager = medicine.registriesManager(context)
        statsManager = medicine.stats(context)
    }
    
    func setupBeforeCaching() {
        registries = registriesManager.getRegistries(mostRecentFirst: false)
    }
}

extension CachedStatistics {
    func retrieveDailyStats(completition: () -> ()){
        lastMedicine = nil
        todaysPillStreak = 0
        todaysAdherence = 0
        
        println("retrieveingDailyStats")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.todaysAdherence = self.statsManager.pillAdherence(date2: NSDate(), registries: self.registries) * 100
            
            let mostRecentFirst = self.registries.reverse()
            self.lastMedicine = self.registriesManager.lastPillDate(registries: mostRecentFirst)
            self.todaysPillStreak = self.statsManager.pillStreak(date2: NSDate(), registries: mostRecentFirst)
            
            self.isDailyStatsUpdated = true
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), completition)
        })
        
    }
    
    func retrieveMonthsData(numberMonths: Int, completition : () -> ()) {
        monthAdhrence.removeAll()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let today = NSDate()
            for i in 0...(numberMonths - 1) {
                let month = today - i.month
                let adherence = self.statsManager.pillAdherence(month, registries: self.registries)
                self.monthAdhrence.append((month, adherence * 100))
            }
            
            self.isMonthlyAdherenceDataUpdated = true
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), completition)
        })
    }
    
    func retrieveTookMedicineStats(){
        
        tookMedicine.removeAll()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let entriesReversed = self.registries.reverse() //most recent first
            
            if !entriesReversed.isEmpty {
                let oldestDate = entriesReversed.last!.date.startOfDay
                let numDays = (NSDate() - oldestDate) + 1 //include today
                
                for i in 0...(numDays - 1) {
                    let day = oldestDate + i.day
                    self.tookMedicine[day] = self.registriesManager.tookMedicine(day, registries: entriesReversed) != nil
                }
            }
            
            self.isCalendarViewDataUpdated = true
        })
    }
    
    func updateTookMedicineStats(at: NSDate, progress: (day: NSDate) -> ()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            self.refreshContext()
            self.setupBeforeCaching()
            
            let d1 = at - (self.medicine.interval - 1).day
            let d2 = at + (self.medicine.interval - 1).day
            
            let entriesReversed = self.registries.reverse() //most recentFirst
            if !entriesReversed.isEmpty {
                let numDays = d2 - d1 + 1 //include d2
                for i in 0...(numDays - 1) {
                    let day = (d1 + i.day).startOfDay
                    self.tookMedicine[day] = self.registriesManager.tookMedicine(day, registries: entriesReversed) != nil
                }
                
                let oldestEntry = entriesReversed.last!.date
                let numEntries = NSDate() - oldestEntry + 1
                for i in 0...(numEntries - 1){
                    let day = (oldestEntry + i.day).startOfDay
                    dispatch_async(dispatch_get_main_queue(), {
                        progress(day: day)
                    })
                }
            }
        })
    }
    
    func retrieveCachedStatistics(progress: (progress: Float) -> (), completition : () -> ()) {
        adherencesPerDay.removeAll()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let today = NSDate()
            var entries = self.registries
            
            if !entries.isEmpty {
                let oldestDate = entries[0].date
                let numDays = (today - oldestDate) + 1 //include today
                
                self.adherencesPerDay = [(NSDate,Float)](count: numDays, repeatedValue: (today, 0))
                
                for v in 0...(numDays - 1) {
                    let index = (numDays - 1) - v
                    
                    let day = today - v.day
                    
                    let adherence = self.statsManager.pillAdherence(date1: oldestDate, date2: day, registries: entries)
                    self.adherencesPerDay[index] = (day, adherence * 100)
                    
                    //updating array from last index to first Index
                    for j in 0...(entries.count - 1) {
                        let posDate = entries.count - 1 - j
                        if entries[posDate].date.sameDayAs(day){
                            entries.removeAtIndex(posDate)
                            break
                        }
                    }
                    
                    //Update progress bar
                    dispatch_async(dispatch_get_main_queue(), {
                        progress(progress: 100*Float(numDays - (numDays - v))/Float(numDays))
                    })
                }
                
                self.isGraphViewDataUpdated = true
            }
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), completition)
        })
    }

}