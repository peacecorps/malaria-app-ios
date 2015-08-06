import Foundation


//decoupled from the backend. This enum is only relevant for the frontend
public extension Medicine{
    enum Pill : String{
        static let allValues = [Pill.Doxycycline, Pill.Malarone, Pill.Mefloquine]
        
        case Doxycycline = "Doxycycline"
        case Malarone = "Malarone"
        case Mefloquine = "Mefloquine"
        
        /// returns the interval of the pill
        /// :returns: `Int`: the pill interval
        public func interval() -> Int {
            return self == Medicine.Pill.Mefloquine ? 7 : 1
        }
        
        /// returns the name of the pill
        /// :returns: `String`: the name of the pill
        public func name() -> String{
            return self.rawValue
        }
    }
}