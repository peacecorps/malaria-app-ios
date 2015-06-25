import Alamofire
import SwiftyJSON

class SyncManager {
    static let sharedInstance = SyncManager()
    
    let user = "TestUser"
    let password = "password"
    
    init(){
        // set up the base64-encoded credentials
        let loginString = NSString(format: "%@:%@", user, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders!.updateValue("Basic \(base64LoginString)", forKey: "Authorization")
    }
    
    var endpoints: [Endpoint] = [
        ApiEndpoint()
    ]
    
    func sync(endpoint: Endpoint, save: Bool = false){
        endpoint.clearFromDatabase()
        remoteFetch(endpoint)
        
        if (save){
            CoreDataHelper.sharedInstance.saveContext()
        }
    }
    
    func syncAll(){
        endpoints.map({ self.sync($0) })
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    private func remoteFetch(endpoint: Endpoint, save: Bool = false){
        //TODO: Check internet connection before doing request
        
        Alamofire.request(.GET, endpoint.path, parameters: endpoint.parameters)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    Logger.Error("Error at \(endpoint.path)): \(error)")
                }
                else {
                    Logger.Info("Connect at \(endpoint.path)")
                    
                    if let obj = endpoint.retrieveJSONObject(JSON(json!)){
                        Logger.Info(Api.retrieve(Api.self).count)
                    }else {
                        Logger.Error("Error parsing \(endpoint.path)")
                    }
                }
        }
    }
    
    private func registerMapping(endpoint: Endpoint) {
    }
    
    
    
}