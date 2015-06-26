import Foundation
import UIKit
import SwiftyJSON

class ActivitiesEndpoint : PostsEndpoint{
    override var path: String { get { return Endpoints.Activity.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Activities.self } }
}