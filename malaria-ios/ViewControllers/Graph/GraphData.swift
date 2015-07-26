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
    
    var registries = [Registry]()
    var tookMedicine: [NSDate: Bool] = [:]
    var monthAdhrence = [(NSDate, Float)]()
    var adherencesPerDay = [(NSDate,Float)]()
    
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
    
    func setupBeforeCaching() {
        registries = registriesManager.getRegistries(mostRecentFirst: false)
    }
    
    func retrieveMonthsData(numberMonths: Int, completition : () -> ()) {
        monthAdhrence.removeAll()

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let today = NSDate()
            for i in 0...(numberMonths - 1) {
                let month = today - i.month
                self.monthAdhrence.append((month, self.statsManager.pillAdherence(month, registries: self.registries)*100))
            }
            
            self.updatedMonthsAdherences = true
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), completition)
        })
    }
    
    func retrieveTookMedicineStats(){
        tookMedicine.removeAll()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            registries.map({tookMedicine[$0.date.startOfDay] = $0.tookMedicine})
        })
    }
    
    
    func retrieveGraphData(progress: (progress: Float) -> (), completition : () -> ()) {
        adherencesPerDay.removeAll()

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let today = NSDate()
            var entries = self.registries
            
            if entries.count != 0 {
                let oldestDate = entries[0].date
                let numDays = (today - oldestDate) + 1 //include today
                
                self.adherencesPerDay = [(NSDate,Float)](count: numDays, repeatedValue: (today, 0))
                
                for v in 0...(numDays - 1) {
                    let index = (numDays - 1) - v
                    
                    let day = today - v.day
                    
                    self.adherencesPerDay[index] = (day, self.statsManager.pillAdherence(date1: oldestDate, date2: day, registries: entries) * 100)
                    
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
                
                self.updatedDailyAdherences = true
            }
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), completition)
        })
    }
}