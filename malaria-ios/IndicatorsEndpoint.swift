import Foundation
import UIKit
import SwiftyJSON

class IndicatorsEndpoint : CollectionPostsEndpoint{
    override var path: String { get { return Endpoints.Indicators.path() } }
    override var subCollectionsPostsType: CollectionPosts.Type { get { return Indicators.self } }
}