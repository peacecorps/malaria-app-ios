import Foundation
import CoreData

class CoreDataStore: NSObject{
    static let sharedInstance = CoreDataStore()
    
    
    let storeName = "Model"
    let storeFilename = "malaria-ios.sqlite"
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // Get module name
        var moduleName: String = inTestEnvironment ? "malaria_iosTests" : "malaria_ios"
        
        // Get model
        let modelURL = NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd")!
        var model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        // Create entity copies
        var newEntities = [NSEntityDescription]()
        for (_, entity) in enumerate(model.entities) {
            let newEntity = entity.copy() as! NSEntityDescription
            newEntity.managedObjectClassName = "\(moduleName).\(entity.managedObjectClassName)"
            newEntities.append(newEntity)
        }
        
        // Set correct subentities
        for (_, entity) in enumerate(newEntities) {
            var newSubEntities = [NSEntityDescription]()
            for subEntity in entity.subentities! {
                for (_, entity) in enumerate(newEntities) {
                    if subEntity.name == entity.name {
                        newSubEntities.append(entity)
                    }
                }
            }
            entity.subentities = newSubEntities
        }
        
        // Set model
        model = NSManagedObjectModel()
        model.entities = newEntities
        
        return model
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.storeFilename)
    
        var error: NSError?
        
        if coordinator!.addPersistentStoreWithType(
            NSSQLiteStoreType,
            configuration: nil,
            URL: url,
            options: [
                NSInferMappingModelAutomaticallyOption: true,
                NSMigratePersistentStoresAutomaticallyOption: true
            ], error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "PERSISTENT_CONFIGURATION", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        
        /*coordinator.addSQLitePersistentStoreAtPath(storePath as String, fromSeedDatabaseAtPath: nil, withConfiguration: nil,
            options: [
                NSInferMappingModelAutomaticallyOption: true,
                NSMigratePersistentStoresAutomaticallyOption: true
            ], error: &e)
            
        if(e != nil){
                var error: NSError? = nil
                coordinator = nil
                // Report any error we got.
                let dict = NSMutableDictionary()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
                Logger.Error("Serious error \(error), \(error!.userInfo)")
                abort()
        }
        
        coordinator.createManagedObjectContexts()
        coordinator.managedObjectCache = RKInMemoryManagedObjectCache(managedObjectContext: coordinator.persistentStoreManagedObjectContext)
        */
        return coordinator
        }()
}