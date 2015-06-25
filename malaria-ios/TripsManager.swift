import Foundation

class TripsManager{
    static let sharedInstance = TripsManager()

    func getTrip() -> Trip?{
        let result = Trip.retrieve(Trip.self)
        if result.count == 0{
            return nil
        }else if result.count > 1 {
            Logger.Warn("Multiple trips found, error")
        }
        
        return result[0]
    }
    
    func clearCoreData(){
        Trip.clear(Trip.self)
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    func createTrip(location: String, medicine: Medicine.Pill, cashToBring: Int64, reminderDate: NSDate) -> Trip?{
        
        if let t = getTrip(){
            Logger.Error("Already created a trip, please delete previous one")
            return nil
        }
        
        let trip = Trip.create(Trip.self)
        
        trip.location = location
        trip.medicine = medicine.name()
        trip.cashToBring = cashToBring
        trip.reminderDate = reminderDate
        
        CoreDataHelper.sharedInstance.saveContext()
        
        return trip
    }
}
