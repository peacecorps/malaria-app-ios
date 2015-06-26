import Foundation
import UIKit
import SwiftyJSON

class VolunteersEndpoint : PostsEndpoint{
    override var path: String { get { return Endpoints.Volunteer.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Volunteers.self } }
}