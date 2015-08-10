import Foundation

/// Abstract class for all managers
public class CoreDataContextManager{
    /// Associated NSManagedObjectContext, shared with subclasses
    internal let context: NSManagedObjectContext
    
    /// Init
    public init(context: NSManagedObjectContext){
        self.context = context
    }
}