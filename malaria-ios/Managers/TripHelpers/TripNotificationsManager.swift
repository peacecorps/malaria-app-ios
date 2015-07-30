import Foundation
import UIKit

public class TripNotificationsManager : NotificationManager {
    override var category: String { get{ return "TripReminder"} }
    override var alertBody: String { get{ return "Don't forget to bring your items to the trip!"} }
    override var alertAction: String { get{ return "Got it!" } }
    
    let FrequentReminderOption = "Frequent"
    let NormalReminderOption = "Normal"
    let MinimalReminderOption = "Minimal"
    let OffReminderOption = "Off"
    
    let trip: Trip
    
    init(context: NSManagedObjectContext, trip: Trip){
        self.trip = trip
        super.init(context: context)
    }
    
    public override func scheduleNotification(fireTime: NSDate){
        //do nothing
    }
    
    public func scheduleTripReminder(tripTime: NSDate){

        super.unsheduleNotification()
        switch (UserSettingsManager.UserSetting.TripReminderOption.getString()){
        case FrequentReminderOption:
            Logger.Info("Scheduling frequent notifications for plan my trip")
            super.scheduleNotification(tripTime)
            super.scheduleNotification(tripTime - 1.day)
            super.scheduleNotification(tripTime - 1.week)
        case NormalReminderOption:
            Logger.Info("Scheduling normal notifications for plan my trip")
            super.scheduleNotification(tripTime - 1.day)
            super.scheduleNotification(tripTime - 1.week)
        case MinimalReminderOption:
            Logger.Info("Scheduling minimal notifications for plan my trip")
            super.scheduleNotification(tripTime - 1.day)
        case OffReminderOption:
            Logger.Warn("Trip Reminder is turned off")
        default:
            UserSettingsManager.UserSetting.TripReminderOption.setString("Frequent")
            scheduleTripReminder(tripTime)
        }
        
        if(trip.departure != tripTime) {
            trip.departure = tripTime
            CoreDataHelper.sharedInstance.saveContext(self.context)
        }
    }
}