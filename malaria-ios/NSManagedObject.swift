import Foundation
import UIKit

extension NSManagedObject{
    public func deleteFromContext(context: NSManagedObjectContext){
        context.deleteObject(self)
    }
}