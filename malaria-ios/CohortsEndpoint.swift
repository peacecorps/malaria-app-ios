import Foundation
import UIKit
import SwiftyJSON

class CohortsEndpoint : PostsEndpoint{
    override var path: String { get { return Endpoints.Cohort.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Cohorts.self } }
}