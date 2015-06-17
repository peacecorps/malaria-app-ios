import Foundation
import UIKit

class RootEndpoint : Endpoint{
    override var entityName: String { get { return "Root" } }
    override var path: String { get { return Endpoints.Api.toString() } }
    override var mapping: RKEntityMapping {
        get {
            var mapping = RKEntityMapping.mapAtributesAndRelationships(entityName, attributes: ["users"])
            return mapping
        }}

}