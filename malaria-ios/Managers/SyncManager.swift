import Alamofire
import SwiftyJSON

public class SyncManager : CoreDataContextManager{
    
    let user = "TestUser"
    let password = "password"
    
    public override init(context: NSManagedObjectContext!){
        super.init(context: context)
        
        // set up the base64-encoded credentials
        let loginString = NSString(format: "%@:%@", user, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders!.updateValue("Basic \(base64LoginString)", forKey: "Authorization")
    }
    
    public var endpoints: [String : Endpoint] = [
        EndpointType.Posts.path() : PostsEndpoint(),
    ]
    
    /// Syncs a specific endpoint
    ///
    /// :param: `String`: full path
    /// :param: `Bool`: Save context after success
    /// :param: `((url: String, error: NSError?)->())?`: completition Handler (default nil)
    public func sync(path: String, save: Bool = false, completionHandler: ((url: String, error: NSError?)->())? = nil){
        func expandedCompletionHandler(url: String, error: NSError?){
            completionHandler?(url: url, error: error)
            
            if (error != nil){
                Logger.Error(error!.localizedDescription)
            }else if (error == nil && save){
                Logger.Info("Saving to coreData")
                CoreDataHelper.sharedInstance.saveContext(self.context)
            }
        }
        
        if let endpoint = endpoints[path]{
            remoteFetch(endpoint, completion: expandedCompletionHandler)
        }else{
            Logger.Error("Bad path provided to sync")
            completionHandler?(url: path, error: NSError(domain: "UNREACHABLE", code: 9999, userInfo: [:]))
        }
    }
    
    /// Syncs every endpoint
    ///
    /// Runs the specified completition handler after syncing every endpoint.
    ///
    /// :param: `(()->())?`: completition handler (default nil)
    public func syncAll(completitionHandler: (()->())? = nil){
        var count = endpoints.count
        func completitionHandlerExpanded(url: String, error: NSError?){
            count--
            if(count == 0){
                Logger.Info("Sync complete")
                completitionHandler?()
            }
            
            Logger.Info("Saving to core data")
            CoreDataHelper.sharedInstance.saveContext(self.context)
        }
        
        for (path, endpoint) in endpoints{
            sync(path, completionHandler: completitionHandlerExpanded)
        }
    }
    
    private func remoteFetch(endpoint: Endpoint, save: Bool = false, completion: ((url: String, error: NSError?)->())? = nil){
        Logger.Info("Syncing: \(endpoint.path)")
        Alamofire.request(.GET, endpoint.path, parameters: ["format": "json"])
            .responseJSON { (req, res, json, error) in
                
                var resultError = error
                if(error == nil) {
                    endpoint.clearFromDatabase(self.context)
                    if let objectMapped = endpoint.retrieveJSONObject(JSON(json!), context: self.context){
                        Logger.Info("Success \(endpoint.path)")
                    }else{
                        Logger.Error("Error parsing \(endpoint.path)")
                        resultError = NSError(domain: "PARSE_ERROR", code: 9999, userInfo: [:])
                    }
                }
                
                completion?(url: endpoint.path, error: resultError)
            }
    }
}