import Foundation

public class CoreDataHelper: NSObject {
    public static let sharedInstance = CoreDataHelper()
    
    override init(){
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidSaveContext:", name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = CoreDataStore.sharedInstance.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    public func createBackgroundContext() -> NSManagedObjectContext?{
        let coordinator = CoreDataStore.sharedInstance.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.parentContext = self.managedObjectContext
        return backgroundContext
    }
    
    public func saveContext (context: NSManagedObjectContext) {
        var error: NSError?
        if context.hasChanges && !context.save(&error) {
            Logger.Error("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
    }
    
    // call back function by saveContext, support multi-thread
    func contextDidSaveContext(notification: NSNotification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender != self.managedObjectContext {
            Logger.Info("Syncing with mainContext")
            self.managedObjectContext!.performBlock {
                self.managedObjectContext!.mergeChangesFromContextDidSaveNotification(notification)
                self.saveContext(self.managedObjectContext!)
            }
        }
    }
}
