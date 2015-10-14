import Foundation

public extension Medicine{
    /// - returns: `Int`: medicine interval
    public var interval: Int {
        get {
            return Int(internalInterval)
        }
    
        set(value) {
            internalInterval = Int64(value)
        }
    }
    
    /// Returns an object responsible for computing the statistics
    public var stats: MedicineStats {
        return MedicineStats(medicine: self)
    }
    
    /// Returns an object responsible for handling the registries
    public var registriesManager: RegistriesManager{
        return RegistriesManager(medicine: self)
    }
    
    /// Returns an object responsible for hadling the notifications
    public var notificationManager: MedicineNotificationsManager{
        return MedicineNotificationsManager(medicine: self)
    }
}