import Foundation

public class UserSettingsManager{
    
    private enum UserSetting: String{
        static let allValues = [DidConfiguredMedicine]
        
        case ModelVersion = "ModelVersion"
        case DidConfiguredMedicine = "DidConfiguredMedicine"
    }
    
    /// Sets DidConfiguredMedicine flag to the value given by argument
    /// :param: `Bool`: value
    public class func setDidConfiguredMedicine(value: Bool){
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: UserSetting.DidConfiguredMedicine.rawValue)
    }
    
    /// Gets the value of the flag DidConfigureMedicine
    /// :returns: The value of the flag DidConfigureMedicine
    public class func getDidConfiguredMedicine() -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(UserSetting.DidConfiguredMedicine.rawValue) ?? false
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