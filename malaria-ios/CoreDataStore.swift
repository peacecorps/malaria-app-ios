import Foundation
import CoreData

class CoreDataStore: NSObject{
    
    let storeName = "Model"
    let storeFilename = "malaria-ios.sqlite"
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        return model
        }()
    
    lazy var persistentStoreCoordinator: RKManagedObjectStore? = {
        var coordinator = RKManagedObjectStore(managedObjectModel: self.managedObjectModel)
        self.objectManager!.managedObjectStore = coordinator
        coordinator.createPersistentStoreCoordinator()
        
        var storePath: NSString = RKApplicationDataDirectory().stringByAppendingPathComponent(self.storeFilename)
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator.addSQLitePersistentStoreAtPath(storePath as String, fromSeedDatabaseAtPath: nil, withConfiguration: nil,
            options: [
                NSInferMappingModelAutomaticallyOption: true,
                NSMigratePersistentStoresAutomaticallyOption: true
            ], error: nil) == nil {
                
                coordinator = nil
                // Report any error we got.
                let dict = NSMutableDictionary()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
                logger("Unresolved error \(error), \(error!.userInfo)")
                abort()
        }
        
        coordinator.createManagedObjectContexts()
        coordinator.managedObjectCache = RKInMemoryManagedObjectCache(managedObjectContext: coordinator.persistentStoreManagedObjectContext)
        
        return coordinator
        }()
    
    
    lazy var objectManager: RKObjectManager? = {
        
        let objectManager: RKObjectManager = RKObjectManager(baseURL: NSURL(string: "base_url"))
        objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
        
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        return objectManager
        }()
}