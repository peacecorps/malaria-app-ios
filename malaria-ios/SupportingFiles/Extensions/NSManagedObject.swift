import Foundation
import UIKit

public extension NSManagedObject {

    ///Converts MyTarget.ClassName to ClassName
    private static func getSimpleClassName(c: AnyClass) -> String {
        return c.description().componentsSeparatedByString(".").last!
    }
    
    /// delete object from contect
    ///
    /// :param: `NSManagedObjectContext`: by default is the one defined in CoreDataHelper
    public func deleteFromContext(context: NSManagedObjectContext){
        context.deleteObject(self)
    }
    
    /// Instanciates a new NSManagedObject.
    ///
    /// After creation, his deletion must be done explicitly
    ///
    /// :param: `T.Type`: The class of any subclass of NSManagedObject
    /// :param: `NSManagedObjectContext`: by default is the one defined in CoreDataHelper
    /// :returns: `T`: A new NSManagedObject of the type given by argument
    public static func create<T : NSManagedObject>(entity: T.Type, context: NSManagedObjectContext) -> T{
        let name = getSimpleClassName(entity)
        
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: context) as! T
    }
    
    /// Retrieves every object in the CoreData.
    ///
    /// :param: `T.Type`: The class of any subclass of NSManagedObject
    /// :param: `NSManagedObjectContext`: by default is the one defined in CoreDataHelper
    /// :returns: `[T]`: A array of NSManagedObject of the type given by argument
    public static func retrieve<T : NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, fetchLimit: Int = Int.max, context : NSManagedObjectContext) -> [T]{
        let name = getSimpleClassName(entity)
        
        let fetchRequest = NSFetchRequest(entityName: name)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = fetchLimit
        
        return context.executeFetchRequest(fetchRequest, error: nil) as! [T]
    }
    
    /// Deletes every object in the CoreData.
    ///
    /// :param: `T.Type`: The class of any subclass of NSManagedObject
    /// :param: `NSManagedObjectContext`: by default is the one defined in CoreDataHelper
    public static func clear<T : NSManagedObject>(entity: T.Type, context : NSManagedObjectContext){
        let elements = entity.retrieve(entity, context: context)
        elements.map({context.deleteObject($0)})
    }
}