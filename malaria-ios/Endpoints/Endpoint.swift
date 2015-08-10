import SwiftyJSON

/// Endpoint protocol for retrieving and storing information from the remote json server
public protocol Endpoint{
    /// Full url to the endpoint
     var path: String { get }
    
    /// Parses the json and retrieves a NSManagedObject
    ///
    /// Keep in mind that the object is created in the CoreData,
    /// therefore any deletion must be done explicitly.
    ///
    /// :param: `JSON`: json data
    /// :param: `NSManagedObjectContext`: Current context
    ///
    /// :returns: `NSManagedObject?`: The parsed object or nil if parse failed
    func retrieveJSONObject(data: JSON, context: NSManagedObjectContext) -> NSManagedObject?
    
    /// Clear all NSManagedObjects used by the endpoint
    ///
    /// :param: `NSManagedObjectContext`: Current context
    func clearFromDatabase(context: NSManagedObjectContext)
}



