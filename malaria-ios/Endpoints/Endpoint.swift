import SwiftyJSON

protocol Endpoint{
    /// full url to the endpoint
    ///
    /// :returns: `String`
    var path: String                    { get }
    
    /// Parses the json and retrieves a NSManagedObject
    ///
    /// Keep in mind that the object is created in the CoreData,
    /// therefore any deletion must be done explicitly.
    ///
    /// :returns: `NSManagedObject?`: The parsed object or nil if parse failed
    func retrieveJSONObject(data: JSON, context: NSManagedObjectContext) -> NSManagedObject?
    
    /// Clear all NSManagedObjects used by the endpoint
    func clearFromDatabase(context: NSManagedObjectContext)
}



