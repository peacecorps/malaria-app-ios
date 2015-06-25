import Foundation
import UIKit

class PostsEndpoint : Endpoint{
    override var path: String { get { return Endpoints.Posts.path() } }
}