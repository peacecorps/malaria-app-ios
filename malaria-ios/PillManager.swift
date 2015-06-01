import Foundation
import UIKit

class PillManager{
    let PillReminderCategory = "PillReminder"
    
    var currentPill: Pill?
    
    func registerPill(pill: Pill, fireTime: NSDate){
        unregister()
        
        let notification: UILocalNotification = createNotification(pill.rawValue, fireDate: fireTime, frequency: pill.repeatInterval())
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        currentPill = pill
    }
    
    func unregister(){
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == PillReminderCategory{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break;
            }
        }
        
        currentPill = nil
    }
    
    func getFireDate() -> NSDate?{
        for event in UIApplication.sharedApplication().scheduledLocalNotifications {
            
            var notification = event as! UILocalNotification
            
            if notification.category == PillReminderCategory{
                return notification.fireDate
            }
        }
        
        return nil
    }
    
    func generateNewNotificationTime(currentPill: Pill, currentTriggerTime: NSDate,  timesInRow: Int, timesSupposed: Int) -> NSDate{
        
        //Empty for now but should generate smart notifications
        
        return NSDate()
    }
    
    func updatePillTracker(tookPill: Bool){
        
        let currentDate = NSDate()
        UserSettingsManager.setObject(UserSetting.MedicineLastRegistry, currentDate)
        
        if(tookPill){
            UserSettingsManager.setInt(UserSetting.DosesInARow, UserSettingsManager.getInt(UserSetting.DosesInARow)+1)
            UserSettingsManager.setInt(UserSetting.DosesTaken, UserSettingsManager.getInt(UserSetting.DosesTaken)+1)
            
            logger("DosesInRow: \(UserSetting.DosesInARow, UserSettingsManager.getInt(UserSetting.DosesInARow))")
            
        }else{
            UserSettingsManager.setInt(UserSetting.DosesInARow, 0)
        }
    }
    
    func didTookPill(currentDate: NSDate) -> Bool{
        let previousPill = UserSettingsManager.getObject(UserSetting.MedicineLastRegistry) as! NSDate
        let currentPill = Pill(rawValue: UserSettingsManager.getObject(UserSetting.MedicineName) as! String)
        
        if let p = currentPill{
            return p.isDaily() && NSDate.areDatesSameDay(currentDate, dateTwo: previousPill) ||
                   p.isWeekly() && NSDate.areDatesSameDay(currentDate, dateTwo: previousPill)
        }
        
        logger("Pill not configured and wasn't supposed to happen")
        return false
    }
    
    func configureNextNotification(){
        unregister()
        
        var currentFireDate = getFireDate()
    
        registerPill(currentPill!, fireTime: currentPill!.isDaily() ? NSDate.nextDay(currentFireDate!) : NSDate.nextWeek(currentFireDate!))
    }
    
    
    //returns the number of supposed pills should have been taken
    func numberOfSupposedPills(now: NSDate)-> Int{
        //FIXME
        return 10
    }
    
    //returns the number of pills in a row taken
    func currentPillStreak()-> Int{
        return UserSettingsManager.getInt(UserSetting.DosesInARow)
    }
    
    func numberDosesTaken()-> Int{
        return UserSettingsManager.getInt(UserSetting.DosesTaken)
    }
    
    func currentPillAdherence() -> Float{
        
        let supposedPills = numberOfSupposedPills(NSDate())
        if(supposedPills == 0){
            return 100.0
        }
        
        return Float(numberDosesTaken())/(Float(supposedPills))
    }
    
    func lastPillDateRegistry() -> NSDate{
        return UserSettingsManager.getObject(UserSetting.MedicineLastRegistry) as! NSDate
    }

    private func createNotification(medicine: String, fireDate: NSDate, frequency: NSCalendarUnit) -> UILocalNotification{
        var localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = "Did you took the pill?"
        localNotification.alertBody = "\(medicine): Take me take me!"
        localNotification.alertAction = "Open"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = PillReminderCategory
        localNotification.repeatInterval = frequency
        
        return localNotification
    }
}