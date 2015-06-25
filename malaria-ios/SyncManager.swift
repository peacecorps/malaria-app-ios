import Alamofire

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
        
        let user = "TestUser"
        let password = "password"
        
        // set up the base64-encoded credentials
        let loginString = NSString(format: "%@:%@", user, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders!.updateValue("Basic \(base64LoginString)", forKey: "Authorization")

        
       /*
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Authorization2"] = "Basic \(base64LoginString)"
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        let manager = Alamofire.Manager(configuration: configuration)
        */

        
        Alamofire.request(.GET, endpoint.path, parameters: endpoint.parameters())
            .authenticate(user: user, password: password)
            .responseJSON { (req, res, json, error) in
                println(json)
                println(error)
                
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    //NSLog("Success: \(url)")
                    //var json = JSON(json!)
                }
        }
    }
    
    private func registerMapping(endpoint: Endpoint) {
    }
    
    
    
}