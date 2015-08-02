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
    
    private lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = CoreDataStore.sharedInstance.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    /// Creates a new background context with the mainContext as parent
    /// :returns: `NSManagedObjectContext`
    public func createBackgroundContext() -> NSManagedObjectContext?{
        let coordinator = CoreDataStore.sharedInstance.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.parentContext = self.managedObjectContext
        return backgroundContext
    }
    
    /// save the context.
    /// :param: `NSManagedObjectContext`: context to be saved
    public func saveContext (context: NSManagedObjectContext) {
        var error: NSError?
        if context.hasChanges && !context.save(&error) {
            Logger.Error("Unresolved error \(error), \(error!.userInfo)")
        }
    }
    
    
    /// Callback for multi-threading. Syncronizes the background context with the main context. Then the parent context, that has direct connection with persistent storage saves.
    internal func contextDidSaveContext(notification: NSNotification) {
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
