import Foundation

public class TripsManager : Manager{
    
    public override init(context: NSManagedObjectContext){
        super.init(context: context)
    }
    
    /// Returns the current trip if any
    /// :returns: Trip?
    public func getTrip() -> Trip?{
        let result = Trip.retrieve(Trip.self, context: context)
        if result.count == 0{
            return nil
        }else if result.count > 1 {
            Logger.Warn("Multiple trips found, error")
        }
        
        return result[0]
    }
    
    /// Clears any trip from coreData
    public func clearCoreData(){
        Trip.clear(Trip.self, context: context)
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
    public func createTrip(location: String, medicine: Medicine.Pill, cash: Int64, reminderDate: NSDate) -> Trip{
        if let t = getTrip(){
            Logger.Warn("Already created a trip: changing stored one")
            t.location = location
            t.medicine = medicine.name()
            t.cash = cash
            t.reminderDate = reminderDate
            
            for i in t.itemsManager(context).getItems(){
                Logger.Info("Deleting previous items")
                i.deleteFromContext(self.context)
            }
            
            CoreDataHelper.sharedInstance.saveContext(context)
            return t
        }
        
        let trip = Trip.create(Trip.self, context: context)
        trip.location = location
        trip.medicine = medicine.name()
        trip.cash = cash
        trip.reminderDate = reminderDate
        
        CoreDataHelper.sharedInstance.saveContext(context)
        
        return trip
    }
}
