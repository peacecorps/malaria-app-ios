import Foundation
import UIKit

public class TripNotificationsManager : NotificationManager {
    override var category: String { get{ return "TripReminder"} }
    override var alertBody: String { get{ return "Don't forget to bring your items to the trip!"} }
    override var alertAction: String { get{ return "Got it!" } }
    
    let trip: Trip
    
    init(context: NSManagedObjectContext, trip: Trip){
        self.trip = trip
        super.init(context: context)
    }
    
    public override func scheduleNotification(fireTime: NSDate){
        super.scheduleNotification(fireTime)
    }
}