import Foundation

public class UserSettingsManager{
    
    public enum UserSetting: String{
        static let allValues = [DidConfiguredMedicine, ClearTripHistory, ClearMedicineHistory, MedicineReminderSwitch, TripReminderOption]
        
        case DidConfiguredMedicine = "DidConfiguredMedicine"
        case ClearTripHistory = "ClearTripHistory"
        case ClearMedicineHistory = "ClearMedicineHistory"
        case MedicineReminderSwitch = "MedicineReminderSwitch"
        case TripReminderOption = "TripReminderOption"
        
        /// Sets settings boolean flag to the value given by argument
        /// :param: `Bool`: value
        public func setBool(value: Bool){
            NSUserDefaults.standardUserDefaults().setBool(value, forKey: self.rawValue)
        }
        
        /// Gets the value of the boolean user setting. If the value isn't set, sets it as default value and returns
        /// :param: `Bool optional`: default value when the variable isn't set. Default false
        /// :returns: `Bool`: The value
        public func getBool(defaultValue: Bool = false) -> Bool{
            if let value = NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) as? Bool{
                return value
            }
            
            Logger.Warn("\(self.rawValue) isn't set, setting and returning default value \(defaultValue)")
            
            self.setBool(defaultValue)
            return defaultValue
        }
        
        /// Sets settings String value of the user setting
        /// :param: `String`: value
        public func setString(value: String){
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: self.rawValue)
        }
        
        /// Gets the string value for the key. If it is not set, returns a default value and sets
        /// :param: `String optional`: default value when the variable isn't set. Default empty string
        /// :returns: `String`:  The value
        public func getString(defaultValue: String = "") -> String{
            if let value = NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) as? String{
                return value
            }
            
            Logger.Warn("\(self.rawValue) isn't set, setting and returning default value \(defaultValue)")
            
            self.setString(defaultValue)
            return defaultValue
        }
        
        /// clears the key from UserDefaults
        public func removeKey() {
            return NSUserDefaults.standardUserDefaults().removeObjectForKey(self.rawValue)
        }
    }
    
    /// Syncronize standardUserDefaults
    public class func syncronize(){
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /// Clears all values
    public class func clear(){
        UserSetting.allValues.map({$0.removeKey()})
    }
}