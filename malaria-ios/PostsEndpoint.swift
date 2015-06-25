import Foundation
import UIKit

class PostsEndpoint : Endpoint{
    override var entityName: String { get { return "Posts" } }
    override var path: String { get { return Endpoints.Posts.path() } }
}