import Foundation

class MedicineManager{
    static let sharedInstance = MedicineManager()
    
    func setup(medicine : Medicine.Pill, fireDate: NSDate){
        
        logger("Storing new medicine")
        MedicineRegistry.sharedInstance.registerNewMedicine(medicine)
        
        logger("Setting up notification")
        MedicineNotificationManager.sharedInstance.scheduleNotification(medicine, fireTime: fireDate)
        
        UserSettingsManager.setBool(UserSetting.DidConfiguredMedicine, true)
        UserSettingsManager.syncronize()
    }
    
    func didTookPill(currentDate: NSDate) -> Bool{
        if let previous = lastPillDateRegistry(), let m = MedicineRegistry.sharedInstance.getRegisteredMedicine(){
            return
                m.isDaily() && NSDate.areDatesSameDay(currentDate, dateTwo: previous) ||
                m.isWeekly() && NSDate.areDatesSameWeek(currentDate, dateTwo: previous)
        }
        
        return false
    }
    
    func numberOfSupposedPills(now: NSDate)-> Int{
        if let r = MedicineRegistry.sharedInstance.getRegistries(){
            return r.count
        }
        
        return 0
    }
    
    func currentPillAdherence() -> Float{
        
        let supposedPills = numberOfSupposedPills(NSDate())
        if(supposedPills == 0){
            return 1.0
        }
        
        return Float(numberDosesTaken())/(Float(supposedPills))
    }
    
    func getCurrentPill() -> Medicine.Pill?{
        
        if let m = MedicineRegistry.sharedInstance.getRegisteredMedicine(){
            return Medicine.Pill(rawValue: m.name)!
        }
        
        return nil
    }
    
    func lastPillDateRegistry() -> NSDate?{
        if let registries = MedicineRegistry.sharedInstance.getRegistries(){
            return registries.count > 0 ? registries[0].date : nil
        }
        
        return nil
    }
    
    func currentStreak()-> Int{
        if let m = MedicineRegistry.sharedInstance.getRegisteredMedicine(){
            return m.currentStreak
        }
        
        return 0
    }
    
    func numberDosesTaken()-> Int{
        var count = 0
        
        if let registries = MedicineRegistry.sharedInstance.getRegistries(){
            for r in registries{
                if (r.tookMedicine){
                    count++
                }
            }
        }
        
        return count
    }
}