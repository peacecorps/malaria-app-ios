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
        months = []
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let today = NSDate()
            for i in 0...(numberMonths - 1) {
                self.months.append(today - i.month)
            }
            
            self.updatedMonthsAdherences = true
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), {
                completition()
            })
        })
    }
    
    
    func retrieveGraphData(progress: (progress: Float) -> (), completition : () -> ()) {
        tookMedicine = [:]
        days = []
        adherencesPerDay = []
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if let oldestEntry = self.registriesManager.oldestEntry(){
                let oldestDate = oldestEntry.date
                
                var day = oldestDate
                let today = NSDate()
                
                //only for progress
                var i = 0
                let numDays = (today - oldestDate)
                
                while (day <= today) {
                    self.adherencesPerDay.append(self.statsManager.pillAdherence(date1: oldestDate, date2: day) * 100)
                    self.days.append(day)
                    
                    if let entry = self.registriesManager.findRegistry(day) {
                        self.tookMedicine[day.startOfDay] = entry.tookMedicine
                    }
                    
                    //Update progress bar
                    dispatch_async(dispatch_get_main_queue(), {
                        progress(progress: 100*Float(numDays - (numDays - i))/Float(numDays))
                        i++
                    })
                    
                    day += 1.day
                }
                
                self.updatedDailyAdherences = true
            }
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), {
                completition()
            })
            
        })
        
    }
}