import Foundation

class TripsManager{
    let sharedInstance = TripsManager()

    func getTrip() -> Trip?{
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        let result: [Trip] = context.executeFetchRequest(fetchRequest, error: nil) as! [Trip]
        
        if result.count == 0{
            return nil
        }else if result.count > 1 {
            Logger.Warn("Multiple trips found, error")
        }
        
        return result[0]
    }
    
    func clearCoreData(){
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        if let t = getTrip(){
            t.deleteFromContext(context)
        }
        
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    func createTrip(medicine: String, cashToBring: Int, reminderDate: NSDate) -> Trip?{
        
        if let t = getTrip(){
            Logger.Error("Already created a trip, please delete previous one")
            return nil
        }
        
        let trip = Trip(context: CoreDataHelper.sharedInstance.backgroundContext!)
        
        trip.medicine = medicine
        trip.cashToBring = cashToBring
        trip.reminderDate = reminderDate
        
        return trip
    }

}
