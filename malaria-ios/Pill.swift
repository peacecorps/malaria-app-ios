import Foundation

enum Pill : String{
    case Doxycycline = "Doxycycline"
    case Malarone = "Malarone"
    case Mefloquine = "Mefloquine"
    
    func repeatInterval() -> NSCalendarUnit{
        return self == Pill.Mefloquine ? NSCalendarUnit.CalendarUnitWeekday : NSCalendarUnit.CalendarUnitDay
    }
    
    func isWeekly() -> Bool{
        return self == Pill.Mefloquine
    }
    
    func isDaily() -> Bool{
        return self != Pill.Mefloquine
    }
    
    func repeatIntervalString() -> String{
        return self == Pill.Mefloquine ? "Weekly" : "Daily"
    }
    
    func toString() -> String{
        return "\(self.rawValue) (\(self.repeatIntervalString()))"
    }
}