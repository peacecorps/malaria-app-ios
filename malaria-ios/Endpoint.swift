class Endpoint{
    
    var entityName: String { get { fatalError("getEntityName not implemented")} }
    var path: String { get { fatalError("getEndpoint not implemented")} }
    var mapping: RKEntityMapping { get { fatalError("getMapping not implemented")} }
    var isPublic: Bool { return true }
    
    func parameters() -> [String: String] { return ["format": "json"] }
    
    func clearFromDatabase() {
        let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        
        let fetch = NSFetchRequest(entityName: entityName)
        fetch.includesPropertyValues = false //only fetch the managedObjectID
        
        var result = context.executeFetchRequest(fetch, error: nil) as! [NSManagedObject]
        result.map(context.deleteObject)
        
        CoreDataHelper.sharedInstance.saveContext(context)
    }
    
    func mapAtributesAndRelationships(name:String, attributes: [String], relationships: [String:RKEntityMapping] = [:]) -> RKEntityMapping{
        let managedObjectStore: RKManagedObjectStore = CoreDataStore.sharedInstance.persistentStoreCoordinator!
        
        let rootMap = RKEntityMapping(forEntityForName: name, inManagedObjectStore: managedObjectStore)
        
        for childKey in attributes{
            let attMap = RKAttributeMapping(fromKeyPath: childKey, toKeyPath: childKey)
            rootMap.addPropertyMapping(attMap)
        }
        
        for (childKey, childMap) in relationships{
            let relMap = RKRelationshipMapping(fromKeyPath: childKey, toKeyPath: childKey, withMapping: childMap)
            rootMap.addPropertyMapping(relMap)
        }
        return rootMap
    }

}



