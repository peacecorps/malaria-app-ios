import Foundation
import UIKit
import SwiftyJSON

class GoalsEndpoint : PostsEndpoint{
    override var path: String { get { return Endpoints.Goals.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Goals.self } }
}