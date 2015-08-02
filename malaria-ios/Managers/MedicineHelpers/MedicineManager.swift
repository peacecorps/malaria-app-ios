import Foundation

public class MedicineManager : CoreDataContextManager{
    
    override public init(context: NSManagedObjectContext){
        super.init(context: context)
    }
    
    /// Setups a new pill and sets it as default
    ///
    /// If there is already a pill registed as default, it will no longer be the default pill
    ///
    /// :param: `String`: name of the pill
    /// :param: `Int`: interval of the pill (1 = daily, 7 = weekly)
    /// :param: `NSDate`: fireDate
    public func setup(name: String, interval: Int, fireDate: NSDate){
        //unregister previous medicines
        if let currentMed = getCurrentMedicine(){
            currentMed.notificationManager(context).unsheduleNotification()
        }
        
        Logger.Info("Setting medicine")
        registerNewMedicine(name, interval: interval)
        setCurrentPill(name)
        
        getCurrentMedicine()!.notificationManager(context).scheduleNotification(fireDate)

        UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(true)
    }
    
    /// Clears instance of Medicines from the CoreData
    public func clearCoreData(){
        Medicine.clear(Medicine.self, context: self.context)
        CoreDataHelper.sharedInstance.saveContext(self.context)
        UserSettingsManager.UserSetting.DidConfiguredMedicine.removeKey()
    }

    /// Registers a new medicine (not as default)
    ///
    /// :param: `String`: name of the pill
    /// :param: `Int`: interval of the pill (1 = daily, 7 = weekly). If argument is less than 1, it will be 1.
    /// :returns: `Bool`:  If registry was success. False if not.
    public func registerNewMedicine(name: String, interval: Int) -> Bool{
        let registed: Medicine? = getMedicine(name)
        if let m = registed{
            Logger.Warn("Already registered \(name), returning")
            
            return false
        }
        
        let medicine = Medicine.create(Medicine.self, context: context)
        medicine.name = name
        medicine.interval = max(1, interval)
        
        CoreDataHelper.sharedInstance.saveContext(context)
        
        return true
    }
    
    /// Retuns the default medicine (if any)
    ///
    /// :returns: `Medicine?`: The default medicine.
    public func getCurrentMedicine() -> Medicine?{
        let predicate = NSPredicate(format: "isCurrent == %@", true)
        return Medicine.retrieve(Medicine.self, predicate: predicate, fetchLimit: 1, context: context).first
    }
    
    /// Retuns a specified medicine
    ///
    /// :param: `String`: name of pill, case sensitive
    /// :returns: `Medicine?`: The default medicine.
    public func getMedicine(name: String) -> Medicine?{
        let predicate = NSPredicate(format: "name == %@", name)
        return Medicine.retrieve(Medicine.self, predicate: predicate, fetchLimit: 1, context: context).first
    }
    
    /// Retuns all medicines registered
    ///
    /// :returns: `[Medicine]`: All the medicines
    public func getRegisteredMedicines() -> [Medicine]{
        return Medicine.retrieve(Medicine.self, context: self.context)
    }
    
    /// Sets the specified pill as default
    ///
    /// :param: `String`: name of the pill, case sensitive
    public func setCurrentPill(name: String){
        if let m = getCurrentMedicine(){
            Logger.Info("Removing \(m.name) from default medicine")
            m.isCurrent = false
            m.notificationManager(context).unsheduleNotification()
        }else{
            Logger.Error("No current pill found!")
        }
        Logger.Info("Setting \(name) as default")
        getMedicine(name)!.isCurrent = true
        
        NSNotificationEvents.DataUpdated(nil)
        
        CoreDataHelper.sharedInstance.saveContext(context)
    }
}