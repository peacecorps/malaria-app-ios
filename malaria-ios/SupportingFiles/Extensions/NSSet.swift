import Foundation

public extension NSSet {
    /// Converts the NSSet to a array
    ///
    /// :returns: `[T]`
    public func convertToArray<T>() -> [T]{
        return allObjects.map {$0 as! T}
        
    }
}