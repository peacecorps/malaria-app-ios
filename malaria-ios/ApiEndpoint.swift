import Foundation
import UIKit

class ApiEndpoint : Endpoint{
    override var entityName: String { get { return "Api" } }
    override var path: String { get { return Endpoints.Api.toString() } }
    override var mapping: RKEntityMapping {
        get {
            
            let attributes = [
                "users",
                "posts",
                "revposts",
                "regions" ,
                "sectors",
                "ptposts",
                "projects",
                "goals",
                "objectives",
                "indicators",
                "outputs",
                "outcomes",
                "activity",
                "measurement",
                "cohort",
                "volunteer"
            ]
            
            var mapping = RKEntityMapping.mapAtributesAndRelationships(entityName, attributes: attributes)
            return mapping
        }}

}