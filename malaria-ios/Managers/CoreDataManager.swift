import Foundation

public class CoreDataContextManager{
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
}