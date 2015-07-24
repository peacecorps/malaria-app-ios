import Foundation
import UIKit

class GraphData : NSObject{
    static let sharedInstance = GraphData()
    
    var outdated: Bool { get {
        return !updatedMonthsAdherences && !updatedDailyAdherences }
    }

    var updatedMonthsAdherences = false
    var updatedDailyAdherences = false
    
    var medicine: Medicine!
    var registriesManager: RegistriesManager!
    var statsManager: MedicineStats!
    
    var tookMedicine: [NSDate: Bool] = [:]
    var months = [NSDate]()
    var days = [NSDate]()
    var adherencesPerDay = [Float]()
    
    var context: NSManagedObjectContext!
    
    override init(){
        super.init()
        NSNotificationEvents.ObserveNewEntries(self, selector: "updateShouldUpdateFlags")
    }
    
    deinit{
        NSNotificationEvents.UnregisterAll(self)
    }
    
    func updateShouldUpdateFlags(){
        updatedMonthsAdherences = false
        updatedDailyAdherences = false
    }
    
    func refreshContext(){
        self.context = CoreDataHelper.sharedInstance.createBackgroundContext()!
        
        medicine = MedicineManager(context: context).getCurrentMedicine()
        registriesManager = medicine.registriesManager(context)
        statsManager = medicine.stats(context)
    }
    
    func retrieveMonthsData(numberMonths: Int, completition : () -> ()) {
        months.removeAll()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let today = NSDate()
            for i in 0...(numberMonths - 1) {
                self.months.append(today - i.month)
            }
            
            self.updatedMonthsAdherences = true
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), completition)
        })
    }
    
    func retrieveTookMedicineStats(){
        tookMedicine.removeAll()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.registriesManager.getRegistries(mostRecentFirst: false).map({tookMedicine[$0.date.startOfDay] = $0.tookMedicine})
        })
    }
    
    
    func retrieveGraphData(progress: (progress: Float) -> (), completition : () -> ()) {
        days.removeAll()
        adherencesPerDay.removeAll()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let today = NSDate()
            var entries = self.registriesManager.getRegistries(mostRecentFirst: false)
            
            if entries.count != 0 {
                let oldestDate = entries[0].date
                let numDays = (today - oldestDate) + 1 //include today
                
                self.days = [NSDate](count: numDays, repeatedValue: today)
                self.adherencesPerDay = [Float](count: numDays, repeatedValue: 0)
                
                for v in 0...(numDays - 1) {
                    let index = (numDays - 1) - v
                    
                    let day = today - v.day
                    
                    self.days[index] = day
                    self.adherencesPerDay[index] = self.statsManager.pillAdherence(date1: oldestDate, date2: day, registries: entries) * 100
                    
                    //updating array from last index to first Index
                    for j in 0...(entries.count - 1) {
                        let posDate = entries.count - 1 - j
                        if NSDate.areDatesSameDay(entries[posDate].date, dateTwo: day){
                            entries.removeAtIndex(posDate)
                            break
                        }
                    }
                    
                    //Update progress bar
                    dispatch_async(dispatch_get_main_queue(), {
                        progress(progress: 100*Float(numDays - (numDays - v))/Float(numDays))
                    })
                }
                
                self.updatedDailyAdherences = true
            }
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), completition)
        })
    }
}