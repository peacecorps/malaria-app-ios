import Foundation

public class Manager{
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
}