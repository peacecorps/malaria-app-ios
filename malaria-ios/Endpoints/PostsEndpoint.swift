import Foundation
import UIKit
import SwiftyJSON

public class PostsEndpoint : CollectionPostsEndpoint{
    override public var path: String { get { return EndpointType.Posts.path() } }
    
    ///if there is another endpoint with the same json structure, just change the type
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Posts.self } }
}