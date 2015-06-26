import Foundation
import UIKit
import SwiftyJSON

class SectorsEndpoint : PostsEndpoint{
    override var path: String { get { return Endpoints.Sectors.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Sectors.self } }
}