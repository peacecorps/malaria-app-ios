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
        
        func isWeekly() -> Bool{
            return self == Medicine.Pill.Mefloquine
        }
        
        func isDaily() -> Bool{
            return self != Medicine.Pill.Mefloquine
        }
        
        public func name() -> String{
            return self.rawValue
        }
    }
    
    class func PillTypeFromString(type: String) -> Pill?{
        return Medicine.Pill(rawValue: type)
    }
    
    func isWeekly() -> Bool{
        return weekly
    }
    
    func isDaily() -> Bool{
        return !weekly
    }
}