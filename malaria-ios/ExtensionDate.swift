import Foundation

extension NSDate{
    
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
    
    class func nextWeek(date: NSDate) -> NSDate{
        var components = NSDateComponents()
        components.setValue(1, forComponent: NSCalendarUnit.CalendarUnitWeekOfYear);
        
        let date: NSDate = NSDate()
        var expirationDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))
        
        return expirationDate!
    }
    
    class func nextDay(date: NSDate)-> NSDate{
        var components = NSDateComponents()
        components.setValue(1, forComponent: NSCalendarUnit.CalendarUnitDay);
        
        let date: NSDate = NSDate()
        var expirationDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))
        
        return expirationDate!
    }
}