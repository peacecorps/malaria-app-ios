import Foundation

extension Int{
    var day: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitDay)
    }
    
    var month: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitMonth)
    }
    
    var year: (Int, NSCalendarUnit) {
        return (self, NSCalendarUnit.CalendarUnitYear)
    }
}

public func + (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
    return NSCalendar.currentCalendar().dateByAddingUnit(tuple.unit, value: tuple.value, toDate: date, options:.WrapComponents)!
}

public func - (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate {
    return NSCalendar.currentCalendar().dateByAddingUnit(tuple.unit, value: (-tuple.value), toDate: date, options:.WrapComponents)!
}

public func += (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
    date =  NSCalendar.currentCalendar().dateByAddingUnit(tuple.unit, value: tuple.value, toDate: date, options:.WrapComponents)!
}

public func -= (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) {
    date =  NSCalendar.currentCalendar().dateByAddingUnit(tuple.unit, value: -tuple.value, toDate: date, options:.WrapComponents)!
}