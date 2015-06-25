import Alamofire
import SwiftyJSON

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
        
        Alamofire.request(.GET, endpoint.path, parameters: endpoint.parameters())
            .responseJSON { (req, res, json, error) in
                println(json)
                println(error)
                
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    NSLog("Success: \(endpoint.path)")
                    var error: NSError?
                    endpoint.retrieveJSONObject(JSON(json!))
                    
                    CoreDataHelper.sharedInstance.saveContext()
                    
                    if Api.retrieve(Api.self).count > 0 {
                        Logger.Info("SUCESSS")
                    }
                    
                    if let e = error{
                        Logger.Error("Bad parse")
                    }
                }
        }
    }
    
    private func registerMapping(endpoint: Endpoint) {
    }
    
    
    
}