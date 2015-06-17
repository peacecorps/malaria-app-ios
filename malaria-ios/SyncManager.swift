class SyncManager {
    static let sharedInstance = SyncManager()
    var endpoints: [Endpoint] = []
    
    init(){
        Logger.Info("Registering")
        endpoints.append(RootEndpoint())
        endpoints.map({ self.registerMapping($0) })
    }
    
    func syncAll(){
        endpoints.map({self.remoteFetch($0)})
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
        
        /*
        // set up the base64-encoded credentials
        let username = "TestUser"
        let password = "password"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        Logger.Warn("---> \(base64LoginString)")
        requestUrl.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        */
        
        Logger.Warn("HEREEEE")
        let dic = requestUrl.allHTTPHeaderFields
        println(dic)
        Logger.Warn("FINISHED HERE")
        
        var request = cds.objectManager!.managedObjectRequestOperationWithRequest(
            requestUrl,
            managedObjectContext: cdh.backgroundContext,
            success:
            {
                (RKObjectRequestOperation, RKMappingResult) -> Void in
                
                println(RKObjectRequestOperation.description)
                
                Logger.Info("Success");
            },
            failure: {
                (RKObjectRequestOperation, error) -> Void in
                
                Logger.Error("Error: \(error.description)")
                println(RKObjectRequestOperation.HTTPRequestOperation.description)
                
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
    
    
    
}