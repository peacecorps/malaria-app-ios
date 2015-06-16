class SyncManager {
    let sharedInstance = SyncManager()
    var endpoints: [String : Endpoint] = [:]
    
    init(){
    
    }
    
    private func remoteFetch(endpoint: Endpoint){
        //TODO: Check internet connection before doing request
        let cds = CoreDataStore.sharedInstance
        let cdh = CoreDataHelper.sharedInstance
        
        var requestUrl = cds.objectManager!.requestWithObject(
            nil,
            method: RKRequestMethod.GET,
            path: endpoint.path,
            parameters: endpoint.parameters())
        
        var request = cds.objectManager!.managedObjectRequestOperationWithRequest(
            requestUrl,
            managedObjectContext: cdh.backgroundContext,
            success:
            {
                (RKObjectRequestOperation, RKMappingResult) -> Void in
                Logger.Info("Success");
            },
            failure: {
                (RKObjectRequestOperation, error) -> Void in
                Logger.Error("Error: \(error.description)")
            })
        
        request.start()
    }

    private func registerMapping(endpoint: Endpoint) {
        let responseDescriptor = RKResponseDescriptor(
            mapping: endpoint.mapping,
            method: RKRequestMethod.GET,
            pathPattern: endpoint.path,
            keyPath: nil,
            statusCodes: NSIndexSet(index: 200))
        CoreDataStore.sharedInstance.objectManager!.addResponseDescriptor(responseDescriptor)
    }
    
    func registerEndpoint(e: Endpoint){
        endpoints.updateValue(e, forKey: e.path)
    }
    
    
}