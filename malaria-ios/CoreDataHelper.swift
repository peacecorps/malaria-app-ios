import Foundation

class CoreDataHelper: NSObject {
    
    let store: CoreDataStore!
    
    override init(){
        store = getAppDelegate().cds
        super.init()
    }
    
    lazy var backgroundContext: NSManagedObjectContext? = {
        let coordinator = self.store.persistentStoreCoordinator?.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
        }()
    
    func saveContext (context: NSManagedObjectContext) {
        var error: NSError?
        if context.hasChanges && !context.save(&error) {
            logger("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
    }
    
    func saveContext () {
        self.saveContext( self.backgroundContext! )
    }
}
