import Foundation

public func ==(lhs: Registry, rhs: Registry) -> Bool {
    return NSDate.areDatesSameDay(lhs.date, dateTwo: rhs.date)
}

extension Registry : Equatable{ }

extension Registry {
    convenience init(context: NSManagedObjectContext) {
        let entityName = getSimpleClassName(self.dynamicType)
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
}