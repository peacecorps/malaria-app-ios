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
    
    ///retrieves the day of the week
    var weekday: Int {
        return NSCalendar.currentCalendar().component(.CalendarUnitWeekday, fromDate: self)
    }
    
    ///retrieves the year
    var year: Int{
        return NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitYear, fromDate: self)
    }
    
    ///retrieves the week
    var week: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: self)
    }
    
    ///retrieves the hour
    var hour: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitHour, fromDate: self)
    }
    
    ///retrieves the minute
    var minute: Int {
        return NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitMinute, fromDate: self)
    }
    
    ///retrieves the end day of the current month
    var endOfCurrentMonth: Int{
        return (NSDate.from(year, month: month, day: 1) + 1.month - 1.minute).day
    }
    
    ///retrieves the start of the day (using startOfDayForDate)
    var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }
    
    ///retrieves the end of the day (23:59:59)
    var endOfDay: NSDate {
        return startOfDay + 1.day - 1.second
    }
    
    /// retrieves the start of the day of the week
    var startOfWeek: NSDate {
        return (self - weekday.day).startOfDay
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
    func formatWith(_ format: String = "dd-MMMM-yyyy hh:mm") -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    /// Returns true if happens before the date given as argument
    ///
    /// :param: `NSDate`: The day to compare to
    /// :returns: `Bool`
    func happensMonthsBefore(date: NSDate) -> Bool{
        return (self.year < date.year) || (self.year == date.year && self.month < date.month)
    }
    
    /// Returns true if happens after the date given as argument
    ///
    /// :param: `NSDate`: the day to compare
    /// :returns: `Bool`
    func happensMonthsAfter(date: NSDate) -> Bool{
        return (self.year > date.year) || (self.year == date.year && self.month > date.month)
    }
    
    /// Returns true if both dates represents the same day (day, month and year)
    /// :param: `NSDate`: the day to compare
    /// :returns: `Bool`
    func sameDayAs(dateTwo: NSDate) -> Bool {
        return self.year == dateTwo.year && self.month == dateTwo.month && self.day == dateTwo.day
    }

    /// Returns true if both dates belong in the same week. Also takes into account year transition
    ///
    /// :param: `NSDate`: the day to compare
    /// :returns: `Bool`
    func sameWeekAs(dateTwo: NSDate) -> Bool {
        return (self.year == dateTwo.year && self.week == dateTwo.week) || self.startOfWeek.sameDayAs(dateTwo.startOfWeek)
    }

    /// Returns true if both dates happens in the same month.
    ///
    /// :param: `NSDate`: the day to compare
    /// :returns: `Bool`
    func sameMonthAs(dateTwo: NSDate) -> Bool {
        return (self.year == dateTwo.year && self.month == dateTwo.month)
    }
    
    /// Returns true if both dates are in the same time.
    ///
    /// :returns: `Bool`
    func sameClockTimeAs(dateTwo: NSDate) -> Bool {
        return self.hour == dateTwo.hour && self.minute == dateTwo.minute
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