import Foundation

public class CoreDataContextManager{
    internal let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
}