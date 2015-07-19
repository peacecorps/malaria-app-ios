//
//  GraphData.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 18/07/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

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
        
        updateShouldUpdateFlags()
    }
    
    
    deinit{
        NSNotificationEvents.UnregisterAll(self)
    }
    
    func updateShouldUpdateFlags() {
        self.context = CoreDataHelper.sharedInstance.createBackgroundContext()!
        
        medicine = MedicineManager(context: context).getCurrentMedicine()
        registriesManager = medicine.registriesManager(context)
        statsManager = medicine.stats(context)
        
        updatedMonthsAdherences = false
        updatedDailyAdherences = false
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
    
    
    func retrieveGraphData(completition : () -> ()) {
        tookMedicine = [:]
        days = []
        adherencesPerDay = []
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var startTime = CFAbsoluteTimeGetCurrent()
            if let oldestEntry = self.registriesManager.oldestEntry(){
                let oldestDate = oldestEntry.date
                
                var day = oldestDate
                let today = NSDate()
                
                while (day <= today) {
                    self.adherencesPerDay.append(self.statsManager.pillAdherence(date1: oldestDate, date2: day) * 100)
                    self.days.append(day)
                    
                    if let entry = self.registriesManager.findRegistry(day) {
                        self.tookMedicine[day.startOfDay] = entry.tookMedicine
                    }
                    
                    day += 1.day
                }
                
                self.updatedDailyAdherences = true
                
                println("TOOK: \(CFAbsoluteTimeGetCurrent() - startTime)")
            
                //update UI when finished
                dispatch_async(dispatch_get_main_queue(), {
                    completition()
                })
            }
        })
        
    }
}