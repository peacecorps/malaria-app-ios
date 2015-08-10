import Foundation
import UIKit

/// Manages trip notifications
public class TripNotificationsManager : NotificationManager {
    /// Notification category
    override public var category: String { get{ return "TripReminder"} }
    /// Notification alert body
    override public var alertBody: String { get{ return "Don't forget to bring your items to the trip!"} }
    /// Notification alert action
    override public var alertAction: String { get{ return "Got it!" } }
    
    private let trip: Trip
    
    /// Init
    init(context: NSManagedObjectContext, trip: Trip){
        self.trip = trip
        super.init(context: context)
    }
}