import Foundation
import UIKit

public class TripNotificationsManager : NotificationManager{
    override var category: String { get{ return "TripReminder"} }
    override var alertBody: String { get{ fatalError("Don't forget to bring your items to the trip!")} }
    override var alertAction: String { get{ fatalError("Got it!")} }
    
    let trip: Trip
    
    init(context: NSManagedObjectContext, trip: Trip){
        self.trip = trip
        super.init(context: context)
    }
    
    public override func scheduleNotification(fireTime: NSDate){
        super.scheduleNotification(fireTime)
        
        if(trip.reminderDate != fireTime){
            trip.reminderDate = fireTime
            CoreDataHelper.sharedInstance.saveContext(self.context)
        }
    }
}