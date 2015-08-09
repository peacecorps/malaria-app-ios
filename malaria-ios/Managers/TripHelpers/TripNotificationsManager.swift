import Foundation
import UIKit

public class TripNotificationsManager : NotificationManager {
    override public var category: String { get{ return "TripReminder"} }
    override public var alertBody: String { get{ return "Don't forget to bring your items to the trip!"} }
    override public var alertAction: String { get{ return "Got it!" } }
    
    let trip: Trip
    
    init(context: NSManagedObjectContext, trip: Trip){
        self.trip = trip
        super.init(context: context)
    }
    
    public override func scheduleNotification(fireTime: NSDate){
        super.scheduleNotification(fireTime)
    }
}