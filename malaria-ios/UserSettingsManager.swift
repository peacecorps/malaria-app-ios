import Foundation

class UserSettingsManager{
    
    class func setBool(key: UserSetting, _ value: Bool){
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key.rawValue)
    }
    
    class func getBool(key: UserSetting) -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(key.rawValue) ?? false
    }
    
    class func setObject(key: UserSetting, _ value: AnyObject){
        logger("Saving \(key)")
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key.rawValue)
    }
    
    class func getObject(key: UserSetting) -> AnyObject?{
        return NSUserDefaults.standardUserDefaults().objectForKey(key.rawValue)
    }
}