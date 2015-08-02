import Foundation

public extension Medicine{
    func stats(context: NSManagedObjectContext) -> MedicineStats {
        return MedicineStats(context: context, medicine: self)
    }
    
    func registriesManager(context: NSManagedObjectContext) -> RegistriesManager{
        return RegistriesManager(context: context, medicine: self)
    }
    
    func notificationManager(context: NSManagedObjectContext) -> MedicineNotificationsManager{
        return MedicineNotificationsManager(context: context, medicine: self)
    }
    
    enum Pill : String{
        static let allValues = [Pill.Doxycycline, Pill.Malarone, Pill.Mefloquine]
        
        case Doxycycline = "Doxycycline"
        case Malarone = "Malarone"
        case Mefloquine = "Mefloquine"
        
        func interval() -> Float {
            return self == Medicine.Pill.Mefloquine ? 7 : 1
        }
        
        public func name() -> String{
            return self.rawValue
        }
    }
}