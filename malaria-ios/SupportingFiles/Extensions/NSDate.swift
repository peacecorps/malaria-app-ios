import Foundation

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func >(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedDescending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a === b || a.compare(b) == NSComparisonResult.OrderedSame
}


extension NSDate : Comparable {}

public extension NSDate{
    
    ///retrieves the month
    var month: Int {
        return NSCalendar.currentCalendar().component(.CalendarUnitMonth, fromDate: self)
    }
    
    ///retrieves the day
    var day: Int {
        return NSCalendar.currentCalendar().component(.CalendarUnitDay, fromDate: self)
    }
    
    ///retrieves the year
    var year: Int{
        return NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitYear, fromDate: self)
    }
    
    var week: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: self)
    }
    
    var hour: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitHour, fromDate: self)
    }
    
    var minute: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitMinute, fromDate: self)
    }
    
    ///retrieves the end day of the current month
    var endOfCurrentMonth: Int{
        return (NSDate.from(year, month: month, day: 1) + 1.month - 1.minute).day
    }
    
    var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }
    
    var endOfDay: NSDate {
        return startOfDay + 1.day - 1.second
    }
    
    /// NSDate(timeIntervalSince1970: 0)
    static var min: NSDate {
        return NSDate(timeIntervalSince1970: 0)
    }
    
    /// NSDate(timeIntervalSince1970: Double.infinity)
    static var max: NSDate{
        return NSDate(timeIntervalSince1970: Double.infinity)
    }
    
    /// Returns a new customized date
    ///
    /// By default, the hour will be set to 00:00
    ///
    /// :param: `Int`: Year.
    /// :param: `Int`: Month.
    /// :param: `Int`: Day.
    /// :param: `Int` optional: Hour.
    /// :param: `Int` optional: Minute.
    /// :returns: `NSDate`: Customized NSDate.
    class func from(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> NSDate {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        c.minute = minute
    
        return NSCalendar.currentCalendar().dateFromComponents(c)!
    }
    
    /// Returns a string according in the format given by argumen
    ///
    /// :param: `String`: The format string (e.g. "yyyy-MM-dd")
    /// :returns: `String`
    func formatWith(format: String) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    
    func happensMonthsBefore(date: NSDate) -> Bool{
        return (self.year < date.year) || (self.year == date.year && self.month < date.month)
    }
    
    func happensMonthsAfter(date: NSDate) -> Bool{
        return (self.year > date.year) || (self.year == date.year && self.month > date.month)
    }
    
    /// Returns true if both dates represents the same day (day, month and year)
    ///
    /// :returns: `Bool`
    class func areDatesSameDay(dateOne: NSDate, dateTwo: NSDate) -> Bool {
        return dateOne.year == dateTwo.year && dateOne.month == dateTwo.month && dateOne.day == dateTwo.day
    }

    /// Returns true if both dates belong in the same week.
    ///
    /// :returns: `Bool`
    class func areDatesSameWeek(dateOne: NSDate, dateTwo: NSDate) -> Bool {
        return dateOne.year == dateTwo.year && dateOne.week == dateTwo.week
    }
    
    /// Returns true if both dates are in the same time.
    ///
    /// :returns: `Bool`
    class func areDatesSameTime(dateOne: NSDate, dateTwo: NSDate) -> Bool {
        return dateOne.hour == dateTwo.hour && dateOne.minute == dateTwo.minute
    }
}


/// Returns number of days between 2 dates.
///
/// If first argument occurs before the second argument, the result will be a negative Integer
///
/// :param: `NSDate`: the first date.
/// :param: `NSDate`: the second date.
/// :returns: `Int`: number of days between date1 and date2.
public func - (toDate: NSDate, fromDate: NSDate) -> Int {
    var calendar: NSCalendar = NSCalendar.currentCalendar()
    
    // Replace the hour (time) of both dates with 00:00 to take into account different timezones
    let toDateNormalized = calendar.startOfDayForDate(toDate)
    let fromDateNormalized = calendar.startOfDayForDate(fromDate)
    
    let components = calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate: fromDateNormalized, toDate: toDateNormalized, options: nil)
    
    return components.day
}