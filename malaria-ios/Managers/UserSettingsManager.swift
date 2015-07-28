import Foundation

public class UserSettingsManager{
    
    public enum UserSetting: String{
        static let allValues = [DidConfiguredMedicine]
        
        case DidConfiguredMedicine = "DidConfiguredMedicine"
        case ClearTripHistory = "ClearTripHistory"
        case ClearMedicineHistory = "ClearMedicineHistory"
        case MedicineReminderSwitch = "MedicineReminderSwitch"
        
        /// Sets settings boolean flag to the value given by argument
        /// :param: `Bool`: value
        public func setBool(value: Bool){
                NSUserDefaults.standardUserDefaults().setBool(value, forKey: self.rawValue)
        }
        
        /// Gets the value of the boolean user setting
        /// :returns: The value
        public func getBool() -> Bool{
            return NSUserDefaults.standardUserDefaults().boolForKey(self.rawValue) ?? false
        }
    }
    
    /// Syncronize standardUserDefaults
    public class func syncronize(){
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /// Clears all values
    public class func clear(){
        for setting in UserSetting.allValues{
            NSUserDefaults.standardUserDefaults().removeObjectForKey(setting.rawValue)
        }
    }
}