import Foundation


class MedicineRegistry {
    //singleton
    static let sharedInstance = MedicineRegistry()

    
    func clearCoreData(){
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        for m in getRegisteredMedicines(){
            context.deleteObject(m)
        }
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    /*
    *   Medicine queries and setters
    *
    */
    
    func registerNewMedicine(med: Medicine.Pill) -> Bool{
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        
        let registed: Medicine? = findMedicine(med)
        if let m = registed{
            logger("Already registered \(m.name), returning")
            
            return false
        }
        
        let medicine = Medicine(context: context)
        medicine.name = med.rawValue
        medicine.weekly = med.isWeekly()
        
        CoreDataHelper.sharedInstance.saveContext()
        
        return true
    }
    
    func getCurrentMedicine() -> Medicine?{
        let medicines: [Medicine] = getRegisteredMedicines()
        let result = medicines.filter({ return $0.isCurrent == true})
        
        return result.count == 0 ? nil : result[0]
    }
    
    func getRegisteredMedicines() -> [Medicine]{
        let fetchRequest = NSFetchRequest(entityName: "Medicine")
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        let result: [Medicine] = context.executeFetchRequest(fetchRequest, error: nil) as! [Medicine]
        
        return result
    }
    
    func setCurrentPill(med: Medicine.Pill){
        if let m = findMedicine(med){
            getRegisteredMedicines().map({$0.isCurrent = false})
            m.isCurrent = true
            CoreDataHelper.sharedInstance.saveContext()
        }else{
            logger("pill not found!")
        }
     }
    
    func findMedicine(med: Medicine.Pill) -> Medicine?{
        let registedMedicine : [Medicine] = getRegisteredMedicines()
        let filter = registedMedicine.filter({$0.name == med.rawValue})
        
        return filter.count == 0 ? nil : filter[0]
    }
    
    
    
    /*
    *   Registries queries and setters
    *
    */
    
    func alreadyRegistered(med: Medicine.Pill, at: NSDate) -> Bool{
        if let m = MedicineRegistry.sharedInstance.findMedicine(med){
            
            if m.isDaily(){
                return getRegistries(med, date1: at, date2: at).count != 0
            }else{
                let registries = getRegistries(med, date1: at - 8.day, date2: at + 8.day)
                for r in registries{
                    if NSDate.areDatesSameWeek(at, dateTwo: r.date){
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func mostRecentEntry(med: Medicine.Pill) -> NSDate?{
        let registries = MedicineRegistry.sharedInstance.getRegistries(med)
        
        return registries.count > 0 ? registries[0].date : nil
    }
    
    func addRegistry(pill: Medicine.Pill, date: NSDate, tookMedicine: Bool, modifyEntry: Bool = false) -> Bool{
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        
        if !modifyEntry && alreadyRegistered(pill, at: date){
            logger("Already registered the pill in that pill/week. Aborting")
            return false
        }
        
        //check if there is already a registry
        if let m = findMedicine(pill){
            var registry : Registry? = findRegistry(pill, date: date)
            
            if let r = registry{
                logger("Found entry same date.")
                r.tookMedicine = tookMedicine
            }else{
                var registry = Registry(context: context)
                registry.date = date
                registry.tookMedicine = tookMedicine
                
                var registries: [Registry] = m.registries.convertToArray()
                registries.append(registry)
                m.registries = NSSet(array: registries)
            }
            
            if(tookMedicine){
                m.currentStreak += 1
            }else {
                m.currentStreak = 0
            }
            
            CoreDataHelper.sharedInstance.saveContext()
            
            return true
        }
        
        logger("Error! addRegistry method failed because there is no registered Medicine")
        return false
    }
    
    func getRegistries(pill: Medicine.Pill, date1: NSDate = NSDate.lateDate(), date2: NSDate = NSDate.earliestDate(), mostRecentFirst: Bool = true) -> [Registry]{
        
        if let m = findMedicine(pill){
            var array : [Registry] = m.registries.convertToArray()
            
            //sort entries chronologically
            let registries = mostRecentFirst ? array.sorted({$0.date > $1.date}) : array.sorted({$0.date < $1.date})
            
            
            if NSDate.areDatesSameDay(date1, dateTwo: date2){
                return registries.filter({NSDate.areDatesSameDay($0.date, dateTwo: date1)})
            }else if date2 < date1 {
                return registries.filter({$0.date >= date2 && $0.date <= date1})
            }
            
            return registries.filter({$0.date >= date1 && $0.date <= date2})
        }
    
        return []
    }
    
    func findRegistry(pill: Medicine.Pill, date: NSDate) -> Registry?{
        let filteredArray = getRegistries(pill).filter({ NSDate.areDatesSameDay($0.date, dateTwo: date) })
        if filteredArray.count > 1{
            logger("Error: Found too many entries with same date")
        }
        
        return filteredArray.count > 0 ? filteredArray[0] : nil
    }
}