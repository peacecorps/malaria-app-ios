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
    
    var endpoints: [String : Endpoint] = [
        Endpoints.Api.path() : ApiEndpoint(),
        Endpoints.Posts.path() : PostsEndpoint(),
        Endpoints.Regions.path() : RegionsEndpoint(),
        Endpoints.Volunteer.path() : VolunteersEndpoint(),
        Endpoints.Sectors.path() : SectorsEndpoint(),
        Endpoints.Projects.path() : ProjectsEndpoint(),
        Endpoints.Ptposts.path() : PtPostsEndpoint(),
        Endpoints.Goals.path() : GoalsEndpoint(),
        Endpoints.Indicators.path() : IndicatorsEndpoint(),
        Endpoints.Activity.path() : ActivitiesEndpoint(),
        Endpoints.Cohort.path() : CohortsEndpoint(),
        Endpoints.Outcomes.path() : OutcomesEndpoint(),
        Endpoints.Objectives.path() : ObjectivesEndpoint(),
        Endpoints.Measurement.path() : MeasurementsEndpoint(),
        Endpoints.Revposts.path() : RevPostsEndpoint(),
        Endpoints.Outputs.path() : OutputsEndpoint()
    ]
    
    func sync(path: String, save: Bool = false, failureHandler: ((url: String, error: NSError)->())? = nil, successHandler: ((url: String, object: NSManagedObject)->())? = nil){
        
        func expandedSuccessHandler(url: String, object: NSManagedObject){
            if let success = successHandler{
                success(url: url, object: object)
            }
            
            if (save){
                Logger.Info("Saving to coreData")
                CoreDataHelper.sharedInstance.saveContext()
            }
        }
        
        if let endpoint = endpoints[path]{
            remoteFetch(endpoint, failureHandler: failureHandler, successHandler: expandedSuccessHandler)
        }else{
            Logger.Error("Bad path provided to sync")
            if let failure = failureHandler{
                failure(url: path, error: NSError())
            }
        }
    }
    
    func syncAll(completitionHandler: (()->())? = nil){
        var count = endpoints.count
        func successHandler(url: String, object: NSManagedObject){
            CoreDataHelper.sharedInstance.saveContext()
            
            count--
            if(count == 0){
                Logger.Info("Sync complete")
                completitionHandler?()
            }
        }
        
        for (path, endpoint) in endpoints{
            sync(path, successHandler: successHandler)
        }
    }
    
    private func remoteFetch(endpoint: Endpoint, save: Bool = false, failureHandler: ((url: String, error: NSError)->())? = nil, successHandler: ((url: String, object: NSManagedObject)->())? = nil){
        
        Alamofire.request(.GET, endpoint.path, parameters: endpoint.parameters)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    Logger.Error("Error at \(endpoint.path)): \(error!)")
                }
                else {
                    Logger.Info("Connected to \(endpoint.path)")
                    endpoint.clearFromDatabase()
                    if let objectMapped = endpoint.retrieveJSONObject(JSON(json!)){
                        successHandler?(url: endpoint.path, object: objectMapped)
                    }else{
                        Logger.Error("Error parsing \(endpoint.path)")
                        failureHandler?(url: endpoint.path, error: error!)
                    }
                }
            }
    }
}