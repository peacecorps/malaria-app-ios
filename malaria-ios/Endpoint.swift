import SwiftyJSON

class Endpoint{
    /// default parameters for every request.
    ///
    /// :returns: `[String : String]`
    var parameters: [String: String]    { get { return ["format": "json"]}}
    
    /// full url to the endpoint
    ///
    /// :returns: `String`
    var path: String                    { get { fatalError("getEndpoint not implemented")} }
    
    func retrieveJSONObject(data: JSON) -> NSManagedObject?{
        fatalError("getEntityName not implemented")
    }
    
    func clearFromDatabase() {
        fatalError("clearFromCoreData not implemented")
    }
}



