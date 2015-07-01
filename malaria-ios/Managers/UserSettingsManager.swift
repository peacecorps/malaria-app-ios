import Foundation

class UserSettingsManager{
    
    enum UserSetting: String{
        static let allValues = [DidConfiguredMedicine]
        
        case DidConfiguredMedicine = "DidConfiguredMedicine"
    }
    
    /// Sets DidConfiguredMedicine flag to the value given by argument
    /// :param: `Bool`: value
    class func setDidConfiguredMedicine(value: Bool){
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: UserSetting.DidConfiguredMedicine.rawValue)
    }
    
    /// Gets the value of the flag DidConfigureMedicine
    /// :returns: The value of the flag DidConfigureMedicine
    class func getDidConfiguredMedicine() -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(UserSetting.DidConfiguredMedicine.rawValue) ?? false
    }
    
    /// Syncronize standardUserDefaults
    class func syncronize(){
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /// Clears all values
    class func clear(){
        for setting in UserSetting.allValues{
            NSUserDefaults.standardUserDefaults().removeObjectForKey(setting.rawValue)
        }
    }
}