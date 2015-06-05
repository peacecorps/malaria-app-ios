import Foundation


public func <(x: NSDate, y: NSDate) -> Bool {
    return x.compare(y) == .OrderedAscending
}

public func >(x: NSDate, y: NSDate) -> Bool {
    return x.compare(y) == .OrderedDescending
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

extension NSDate : Comparable {}

extension NSDate{
    func formatWith(format: String) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    class func areDatesSameDay(dateOne: NSDate, dateTwo: NSDate) -> Bool {
        var calender = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear
        var compOne: NSDateComponents = calender.components(flags, fromDate: dateOne)
        var compTwo: NSDateComponents = calender.components(flags, fromDate: dateTwo);
        return (compOne.day == compTwo.day && compOne.month == compTwo.month && compOne.year == compTwo.year);
    }

    class func areDatesSameWeek(dateOne: NSDate, dateTwo: NSDate) -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let weekOfYear1 = calendar!.component(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: dateOne)
        let weekOfYear2 = calendar!.component(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: dateTwo)
        
        let year1 = calendar!.component(NSCalendarUnit.CalendarUnitYear, fromDate: dateOne)
        let year2 = calendar!.component(NSCalendarUnit.CalendarUnitYear, fromDate: dateTwo)
        
        
        return weekOfYear1 == weekOfYear2 && year1 == year2
    }
}