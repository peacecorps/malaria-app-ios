import Foundation

public class MedicineManager : Manager{
    
    override public init(context: NSManagedObjectContext){
        super.init(context: context)
    }
    
    /// Setups a new pill and sets it as default
    ///
    /// If there is already a pill registed as default, it will no longer be the default pill
    ///
    /// :param: `Medicine.Pill`: the pill
    /// :param: `NSDate`: fireDate
    public func setup(medicine : Medicine.Pill, fireDate: NSDate){
        //unregister previous medicines
        if let currentMed = getCurrentMedicine(){
            currentMed.notificationManager(context).unsheduleNotification()
        }
        
        Logger.Info("Storing new medicine")
        registerNewMedicine(medicine)
        setCurrentPill(medicine)
        
        Logger.Info("Setting up notification")
        getCurrentMedicine()!.notificationManager(context).scheduleNotification(fireDate)

        UserSettingsManager.setDidConfiguredMedicine(true)
    }
    
    /// Clears instance of Medicines from the CoreData
    public func clearCoreData(){
        Medicine.clear(Medicine.self, context: self.context)
        CoreDataHelper.sharedInstance.saveContext(self.context)
        UserSettingsManager.setDidConfiguredMedicine(true)
    }

    /// Registers a new medicine (not as default)
    ///
    /// :param: `Medicine.Pill`: The medicine to be registered
    /// :returns: `Bool`:  If registry was success. False if not.
    public func registerNewMedicine(med: Medicine.Pill) -> Bool{
        let registed: Medicine? = getMedicine(med)
        if let m = registed{
            Logger.Warn("Already registered \(m.name), returning")
            
            return false
        }
        
        let medicine = Medicine.create(Medicine.self, context: context)
        medicine.name = med.name()
        medicine.weekly = med.isWeekly()
        
        CoreDataHelper.sharedInstance.saveContext(context)
        
        return true
    }
    
    /// Retuns the default medicine (if any)
    ///
    /// :returns: `Medicine?`: The default medicine.
    public func getCurrentMedicine() -> Medicine?{
        let medicines: [Medicine] = getRegisteredMedicines()
        
        let result = medicines.filter({ return $0.isCurrent == true})
        
        if result.count > 1{
            println(result)
            Logger.Error("Multiple current medicines found. Inconsistency found")
        }
        
        return result.count == 1 ? result[0] : nil
    }
    
    /// Retuns a specified medicine
    ///
    /// :param: `Medicine.Pill`: The type of the pill
    /// :returns: `Medicine?`: The default medicine.
    public func getMedicine(pill: Medicine.Pill) -> Medicine?{
        let medicines: [Medicine] = getRegisteredMedicines()
        let result = medicines.filter({ return $0.name == pill.name()})
        
        return result.count == 0 ? nil : result[0]
    }
    
    /// Retuns all medicines registered
    ///
    /// :returns: `[Medicine]`: All the medicines
    public func getRegisteredMedicines() -> [Medicine]{
        return Medicine.retrieve(Medicine.self, context: self.context)
    }
    
    /// Sets the specified pill as default
    ///
    /// :param: `Medicine.Pill`: The type of the pill
    public func setCurrentPill(med: Medicine.Pill){
        if let m = getCurrentMedicine(){
            Logger.Info("Removing \(m.name) from default medicine")
            m.isCurrent = false
            m.notificationManager(context).unsheduleNotification()
        }else{
            Logger.Error("No current pill found!")
        }
        Logger.Info("Setting \(med.name()) as default")
        getMedicine(med)!.isCurrent = true
        CoreDataHelper.sharedInstance.saveContext(context)
    }
}