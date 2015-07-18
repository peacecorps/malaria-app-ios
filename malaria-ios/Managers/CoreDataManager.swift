import Foundation

public class CoreDataContextManager{
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
}