import Foundation
import UIKit
import SwiftyJSON

class ObjectivesEndpoint : PostsEndpoint{
    override var path: String { get { return Endpoints.Objectives.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Objectives.self } }
}