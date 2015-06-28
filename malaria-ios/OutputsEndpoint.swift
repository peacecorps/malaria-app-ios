import Foundation
import UIKit
import SwiftyJSON

class OutputsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return Endpoints.Outputs.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Outputs.self } }
}