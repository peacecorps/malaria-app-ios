import Foundation
import UIKit


class PostDetailedViewController : UIViewController{
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UITextView!

    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postDescription.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        postTitle.text = post.title
        postDescription.text = post.post_description

        postDescription.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    @IBAction func goBackBtnHandler(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}