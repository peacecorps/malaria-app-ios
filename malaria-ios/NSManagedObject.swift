import Foundation
import UIKit

extension NSManagedObject{
    public func deleteFromContext(context: NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!){
        context.deleteObject(self)
    }
    
    class func create<T : NSManagedObject>(entity: T.Type, context: NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!) -> T{
        let name = getSimpleClassName(entity)
        //Logger.Info("Creating \(name)")
        
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: context) as! T
    }
    
    class func retrieve<T : NSManagedObject>(entity: T.Type, context : NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!) -> [T]{
        let name = getSimpleClassName(entity)
        
        let fetchRequest = NSFetchRequest(entityName: name)
        return context.executeFetchRequest(fetchRequest, error: nil) as! [T]
    }
    
    class func getSimpleClassName(c: AnyClass) -> String {
        return c.description().componentsSeparatedByString(".").last!
    }
    
    class func clear<T : NSManagedObject>(entity: T.Type, context : NSManagedObjectContext = CoreDataHelper.sharedInstance.backgroundContext!){
        let elements = entity.retrieve(entity, context: context)
        elements.map({context.deleteObject($0)})
    }
}