//
//  UserSettingsManager.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 25/05/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation

enum UserSetting: String{
    case IsFirstLaunch = "FirstLaunch"
}

class UserSettingsManager{
    
    class func setBool(key: UserSetting, _ value: Bool){
        logger("Setting \(value) for key: \(key.rawValue)")
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key.rawValue)
    }
    
    class func getBool(key: UserSetting) -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(key.rawValue) ?? false
    }
    
    
    class func setString(key: UserSetting, _ value: String){
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key.rawValue)
    }
    
    class func getString(key: UserSetting) -> String?{
        return NSUserDefaults.standardUserDefaults().stringForKey(key.rawValue)
    }
}