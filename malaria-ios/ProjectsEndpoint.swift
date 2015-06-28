import Foundation
import UIKit
import SwiftyJSON

class ProjectsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return Endpoints.Projects.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Projects.self } }
}