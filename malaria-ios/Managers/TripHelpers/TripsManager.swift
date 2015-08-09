import Foundation

public class TripsManager : CoreDataContextManager{
    
    public override init(context: NSManagedObjectContext){
        super.init(context: context)
    }
    
    /// Returns the current trip if any
    /// :returns: `Trip?`
    public func getTrip() -> Trip?{
        return Trip.retrieve(Trip.self, fetchLimit: 1, context: context).first
    }
    
    /// Clears any trip from coreData
    public func clearCoreData(){
        Trip.clear(Trip.self, context: context)
        TripHistory.clear(TripHistory.self, context: context)
        CoreDataHelper.sharedInstance.saveContext(context)
    }
    
    /// Returns the location history of the trips
    /// :param: `Int optional`: number of intended items, default is 15
    /// :returns: `[TripHistory]`: history
    public func getHistory(limit: Int = 15) -> [TripHistory] {
        return TripHistory.retrieve(TripHistory.self, fetchLimit: limit, context: context)
    }
    
    /// Appends the trip to the history
    /// :param: `Trip`: the trip
    private func createHistory(trip: Trip){
        let previousHistory = TripHistory.retrieve(TripHistory.self, context: context)
        if previousHistory.count >= 15 {
            Logger.Warn("Deleting history to have more space")
            var count = 15
            for entry in previousHistory {
                if count == 0 {
                    break
                }
                entry.deleteFromContext(context)
            }
        }
        
        if previousHistory.filter({ $0.location.lowercaseString == trip.location.lowercaseString }).count == 0 {
            let hist = TripHistory.create(TripHistory.self, context: context)
            hist.location = trip.location
        }
        
        CoreDataHelper.sharedInstance.saveContext(context)
    }
    
    /// Creates a trip.
    ///
    /// It creates an instance of the object in the CoreData, any deletion must be done explicitly.
    /// If there is already an instance of trip, it modifies it.
    ///
    /// :param: `String`: Location
    /// :param: `Medicine.Pill`: Location
    /// :param: `Int64`: caseToBring
    /// :param: `NSdate`: reminderDate
    /// :return: `Trip`: Instance of trip
    public func createTrip(location: String, medicine: Medicine.Pill, departure: NSDate, arrival: NSDate, timeReminder: NSDate) -> Trip{
        func create(t: Trip) -> Trip{
            t.location = location
            t.medicine = medicine.name()
            t.departure = departure
            t.arrival = arrival
            t.reminderTime = timeReminder
            
            t.itemsManager(context).getItems().map({$0.deleteFromContext(self.context)})
            
            createHistory(t)
            
            CoreDataHelper.sharedInstance.saveContext(context)
            
            return t
        }
        
        if let t = getTrip(){
            Logger.Warn("Already created a trip: changing stored one")
            return create(t)
        }
        
        return create(Trip.create(Trip.self, context: context))
    }
}
