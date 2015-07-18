//
//  GraphData.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 18/07/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import UIKit

class GraphData : CoreDataContextManager{
    var medicine: Medicine!
    var registriesManager: RegistriesManager!
    var statsManager: MedicineStats!
    var tookMedicine: [NSDate: Bool] = [:]
    
    var months = [NSDate]()
    
    var days = [NSDate]()
    var adherencesPerDay = [Float]()
    
    override init(context: NSManagedObjectContext) {
        super.init(context: context)
        
        medicine = MedicineManager(context: context).getCurrentMedicine()
        registriesManager = medicine.registriesManager(context)
        statsManager = medicine.stats(context)
    }
    
    
    func retrieveMonthsData(numberMonths: Int, completition : () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let today = NSDate()
            for i in 0...(numberMonths - 1) {
                self.months.append(today - i.month)
            }
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), {
                completition()
            })
        })
    }
    
    
    func retrieveGraphData(completition : () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var startTime = CFAbsoluteTimeGetCurrent()
            if let oldestEntry = self.registriesManager.oldestEntry(){
                let oldestDate = oldestEntry.date
                
                var day = oldestDate
                let today = NSDate()
                
                self.days = [NSDate]()
                self.adherencesPerDay = [Float]()
                while (day <= today) {
                    self.days.append(day)
                    if let entry = self.registriesManager.findRegistry(day) {
                        self.tookMedicine[day.startOfDay] = entry.tookMedicine
                    }
                    self.adherencesPerDay.append(self.statsManager.pillAdherence(date1: oldestDate, date2: day) * 100)
                    
                    day += 1.day
                }
                
                var endTime = CFAbsoluteTimeGetCurrent()
                println("TOOK: \(endTime - startTime)")
            }
        
            
            //update UI when finished
            dispatch_async(dispatch_get_main_queue(), {
                completition()
            })
        })
        
    }
}