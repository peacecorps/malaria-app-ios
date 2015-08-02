import Foundation

public extension Medicine{
    public var interval: Int {
        get {
            return Int(internalInterval)
        }
    
        set(value) {
            internalInterval = Int64(value)
        }
    }
    
    /// returns an object responsible for computing the statistics
    /// param: `NSManagedObjectContext`: context
    /// returns: `MedicineStats`: the stats object manager
    public func stats(context: NSManagedObjectContext) -> MedicineStats {
        return MedicineStats(context: context, medicine: self)
    }
    
    /// returns an object responsible for handling the registries
    /// param: `NSManagedObjectContext`: context
    /// returns: `RegistriesManager`
    public func registriesManager(context: NSManagedObjectContext) -> RegistriesManager{
        return RegistriesManager(context: context, medicine: self)
    }
    
    /// returns an object responsible for hadling the notifications
    /// param: `NSManagedObjectContext`: context
    /// returns: `MedicineNotificationsManager`
    public func notificationManager(context: NSManagedObjectContext) -> MedicineNotificationsManager{
        return MedicineNotificationsManager(context: context, medicine: self)
    }
}