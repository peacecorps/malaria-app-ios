import Foundation
import UIKit
import SwiftyJSON

public class PostsEndpoint : CollectionPostsEndpoint{
    override public var path: String { get { return EndpointType.Posts.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Posts.self } }
}