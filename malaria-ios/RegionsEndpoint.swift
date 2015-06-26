import Foundation
import UIKit
import SwiftyJSON

class RegionsEndpoint : PostsEndpoint{
    override var path: String { get { return Endpoints.Regions.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Regions.self } }
}