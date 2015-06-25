class SyncManager {
    static let sharedInstance = SyncManager()
    var endpoints: [Endpoint] = []
    
    init(){
        Logger.Info("Registering")
        endpoints.append(ApiEndpoint())
        endpoints.map({ self.registerMapping($0) })
    }
    
    func syncAll(){
        endpoints.map({self.remoteFetch($0)})
    }
    
    private func remoteFetch(endpoint: Endpoint){
        
        //TODO: Check internet connection before doing request
        let cds = CoreDataStore.sharedInstance
        let cdh = CoreDataHelper.sharedInstance
        

    }
    
    private func registerMapping(endpoint: Endpoint) {
    }
    
    
    
}