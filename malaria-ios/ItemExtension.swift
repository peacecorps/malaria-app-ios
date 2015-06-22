import Foundation
import CoreData

extension Item{
    
    convenience init(context: NSManagedObjectContext) {
        let entityName = getSimpleClassName(self.dynamicType)
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
}