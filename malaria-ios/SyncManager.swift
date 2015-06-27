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
    
    func sync(path: String, save: Bool = false){
        if let endpoint = endpoints[path]{
            endpoint.clearFromDatabase()
            remoteFetch(endpoint)
            
            if (save){
                CoreDataHelper.sharedInstance.saveContext()
            }
        }else{
            Logger.Error("Bad path provided to sync")
        }
    }
    
    func syncAll(){
        for (path, endpoint) in endpoints{
            sync(path)
        }
        
        CoreDataHelper.sharedInstance.saveContext()
        Logger.Info("Sync complete")
    }
    
    private func remoteFetch(endpoint: Endpoint, save: Bool = false){
        //TODO: Check internet connection before doing request
        
        Alamofire.request(.GET, endpoint.path, parameters: endpoint.parameters)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    Logger.Error("Error at \(endpoint.path)): \(error!)")
                }
                else {
                    Logger.Info("Connected to \(endpoint.path)")
                    
                    if endpoint.retrieveJSONObject(JSON(json!)) == nil{
                        Logger.Error("Error parsing \(endpoint.path)")
                    }
                }
            }
    }
}