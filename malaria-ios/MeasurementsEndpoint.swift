import Foundation
import UIKit
import SwiftyJSON

class MeasurementsEndpoint : PostsEndpoint{
    override var path: String { get { return Endpoints.Measurement.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Measurements.self } }
}