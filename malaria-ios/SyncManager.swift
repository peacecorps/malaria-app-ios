class SyncManager {
    let sharedInstance = SyncManager()
    var endpoints: [String : Endpoint] = [:]
    
    init(){
    
    }
    
    func registerEndpoint(e: Endpoint){
        endpoints.updateValue(e, forKey: e.path)
    }
    
    
}