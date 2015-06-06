import Foundation


class MedicineRegistry {
    
    func registerNewMedicine(med: Medicine.Pill){
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        
        let currentMedicine: Medicine? = getRegisteredMedicine()
        if let m = currentMedicine{
            
            if(m.name != med.name()){
                logger("Changing Medicine, deleting old")
                context.deleteObject(m)
            }else{
                logger("Already registered \(m.name), returning")
            }
            
            return
        }
        
        var medicine = NSEntityDescription.insertNewObjectForEntityForName("Medicine", inManagedObjectContext: context) as! Medicine
        
        medicine.name = med.rawValue
        medicine.weekly = med.isWeekly()
        
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    func addRegistry(date: NSDate, tookMedicine: Bool){
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        
        //check if there is already a registry
        if let m = getRegisteredMedicine(){
            var registries : [Registry] = m.registries.convertToArray()
            
            //check if there is already an entry
            var found: Bool = false
            for r in registries{
                let d1 = r.date.formatWith("dd/MM")
                let d2 = date.formatWith("dd/MM")
                
                //logger("Comparing r = " + d1 + " with " + d2)
                
                if (NSDate.areDatesSameDay(date, dateTwo: r.date)){
                    //logger("Fount entry same date, deleting it")
                    r.tookMedicine = tookMedicine
                    found = true
                }
            }
            
            if(!found){
                //logger("Inserting new entry for that date")
                var registry = NSEntityDescription.insertNewObjectForEntityForName("Registry", inManagedObjectContext: context) as! Registry
                registry.date = date
                registry.tookMedicine = tookMedicine
                
                registries.append(registry)
                registries = registries.sorted({$0.date > $1.date})
                
                m.registries = NSSet(array: registries)
            }
            
            if(tookMedicine){
                m.currentStreak += 1
            }else {
                m.currentStreak = 0
            }
            
            CoreDataHelper.sharedInstance.saveContext()
        }
    }
    
    func getRegisteredMedicine() -> Medicine?{
        let fetchRequest = NSFetchRequest(entityName: "Medicine")
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [Medicine] {
        
            if !fetchResults.isEmpty {
                return fetchResults[0]
            }
        }
        
        return nil
    }
    
    func getRegistries() -> [Registry]?{
        if let m = getRegisteredMedicine(){
            return m.registries.convertToArray()
        }
        
        return nil
    }
}