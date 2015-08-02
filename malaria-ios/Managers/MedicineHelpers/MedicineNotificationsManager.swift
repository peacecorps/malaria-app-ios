import Foundation
import UIKit

public class MedicineNotificationsManager : NotificationManager{
    override var category: String { get{ return MedicineNotificationsManager.NotificationCategory } }
    override var alertBody: String { get{ return "Did you take \(MedicineManager(context: context).getCurrentMedicine()!.name) today?" } }
    override var alertAction: String { get{ return "Take pill"} }
    
    let medicine: Medicine
    
    public static let TookPillId = "TookPill"
    public static let TookPillTitle = "Yes"
    public static let DidNotTakePillId = "DidNotTakePillId"
    public static let DidNotTakePillTitle = "No"
    public static let NotificationCategory = "PILL_REMINDER"
    
    init(context: NSManagedObjectContext, medicine: Medicine){
        self.medicine = medicine
        super.init(context: context)
    }
    
    public override func scheduleNotification(fireTime: NSDate) {
        medicine.notificationTime = fireTime
        CoreDataHelper.sharedInstance.saveContext(self.context)
        
        if !UserSettingsManager.UserSetting.MedicineReminderSwitch.isSet() {
            Logger.Warn("MedicineReminderSwitch wasn't set, setting to default value true")
            UserSettingsManager.UserSetting.MedicineReminderSwitch.setBool(true)
            scheduleNotification(fireTime)
            return
        }
        
        if !UserSettingsManager.UserSetting.MedicineReminderSwitch.getBool(){
            Logger.Error("Medicine Notifications are not enabled")
            return
        }
        
        super.unsheduleNotification()
        super.scheduleNotification(fireTime)
    }
    
    public override func unsheduleNotification(){
        super.unsheduleNotification()
        
        medicine.notificationTime = nil
        CoreDataHelper.sharedInstance.saveContext(self.context)
    }

    /// Reschedule the pill according to the medicine interval
    /// So, if on monday, 1/1/2014, and interval is 4 days then
    /// it will resheduled to (1 + 4) / 1 / 2014
    public func reshedule(){
        if var nextTime = medicine.notificationTime{
            nextTime += medicine.interval.day
            medicine.notificationTime = nextTime
            
            Logger.Info("Resheduling to " + nextTime.formatWith("dd-MMMM-yyyy hh:mm"))
            
            unsheduleNotification()
            scheduleNotification(nextTime)
            
            return
        }
        
        if medicine.isCurrent{
            Logger.Error("Error: there should be already a fire date")
        }
    }
    
    /// Checks if a week went by without a entry (only valid for weekly pills)
    ///
    /// :param: `NSDate optional`: Current date. (by default is the most current one)
    /// :returns: `Bool`: true if should, false if not
    public func checkIfShouldReset(currentDate: NSDate = NSDate()) -> Bool{
        if medicine.interval == 1 {
            Logger.Warn("checkIfShouldReset only valid for weekly pills")
            return false
        }
        
        if let mostRecent = medicine.registriesManager(context).mostRecentEntry(){
            //get ellaped days
            return (currentDate - mostRecent.date) >= 7
        }
        
        Logger.Warn("There are no entries yet. Returning false")
        return false
    }
    
    /// Returns interactive notifications settings to be added in the AppDelegate
    ///
    /// :returns: `UIMutableUserNotificationCategory`: Configuration
    public static func setup() -> UIMutableUserNotificationCategory{
        var notificationActionOk = UIMutableUserNotificationAction()
        notificationActionOk.identifier = TookPillId
        notificationActionOk.title = TookPillTitle
        notificationActionOk.destructive = false
        notificationActionOk.authenticationRequired = false
        notificationActionOk.activationMode = .Background
        
        var notificationActionCancel = UIMutableUserNotificationAction()
        notificationActionCancel.identifier = DidNotTakePillId
        notificationActionCancel.title = DidNotTakePillTitle
        notificationActionCancel.destructive = true
        notificationActionCancel.authenticationRequired = false
        notificationActionCancel.activationMode = .Background
        
        var notificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = NotificationCategory
        notificationCategory.setActions([notificationActionOk, notificationActionCancel], forContext: .Default)
        notificationCategory.setActions([notificationActionOk, notificationActionCancel], forContext: .Minimal)
        
        return notificationCategory
    }
}