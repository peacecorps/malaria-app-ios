import Foundation
import UIKit
import SwiftyJSON

class PostsEndpoint : Endpoint{
    override var path: String { get { return Endpoints.Posts.path() } }
    
    override func retrieveJSONObject(data: JSON) -> NSManagedObject?{
        
        if let results = data["results"].array{
            let collectionPosts = CollectionPosts.create(CollectionPosts.self)
            
            
            if results.count != 0{
                for json in results{
                    if  let owner = json["owner"].int64,
                        let title = json["title_post"].string,
                        let desc = json["description_post"].string,
                        let created = json["created"].string,
                        let updated = json["updated"].string,
                        let id = json["id"].int64{
                    
                            let post = Post.create(Post.self)
                            
                            post.owner = owner
                            post.title = title
                            post.post_description = desc
                            post.created_at = created
                            post.updated_at = updated
                            post.id = id
                            
                            collectionPosts.posts.addObject(post)
                    }else{
                        Logger.Error("Error parsing post")
                        return nil
                    }
                }
            }
            
            return collectionPosts
        }
        
        return nil
    }
    
    override func clearFromDatabase(){
        CollectionPosts.clear(CollectionPosts.self)
    }
}