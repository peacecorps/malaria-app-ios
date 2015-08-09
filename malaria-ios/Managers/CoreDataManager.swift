import Foundation

public class CoreDataContextManager{
    internal let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext){
        self.context = context
    }
}