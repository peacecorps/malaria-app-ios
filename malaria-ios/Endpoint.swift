import SwiftyJSON

class Endpoint{
    var parameters: [String: String]    { get { return ["format": "json"]}}
    var path: String                    { get { fatalError("getEndpoint not implemented")} }
    
    func retrieveJSONObject(data: JSON) -> NSManagedObject?{
        fatalError("getEntityName not implemented")
    }
    
    func clearFromDatabase() {
        fatalError("clearFromCoreData not implemented")
    }
}



