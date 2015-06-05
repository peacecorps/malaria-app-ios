import Foundation

public func ==(lhs: Registry, rhs: Registry) -> Bool {
    return NSDate.areDatesSameDay(lhs.date, dateTwo: rhs.date)
}

extension Registry : Equatable{ }