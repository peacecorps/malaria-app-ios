import Foundation
import UIKit

class InfoHubViewController : UIViewController{
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()

    private var viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
    private var syncManager: SyncManager!
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncManager = SyncManager(context: viewContext)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        refreshControl.tintColor = UIColor(hex: 0xE46D71)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.addTarget(self, action: "pullRefreshHandler", forControlEvents: UIControlEvents.ValueChanged)
        
        collectionView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshScreen()
    }
    
    func pullRefreshHandler(){
        Logger.Info("Pull refresh")
        syncManager.sync(EndpointType.Posts.path(), save: true, completionHandler: {(url: String, error: NSError?) in
            if let e = error {
                self.presentViewController(self.createAlertViewError(e), animated: true, completion: nil)
            }else {
                self.refreshFromCoreData()
            }
            
            self.refreshControl.endRefreshing()
        })
    }
    
   func refreshScreen() {
        if !refreshFromCoreData(){
            syncManager.sync(EndpointType.Posts.path(), save: true, completionHandler: {(url: String, error: NSError?) in
                if error != nil{
                    
                    delay(0.5){
                        var confirmAlert = UIAlertController(title: self.NoInformationAvailableAlertText.title, message: self.NoInformationAvailableAlertText.message, preferredStyle: .Alert)
                        confirmAlert.addAction(UIAlertAction(title: self.AlertOptions.ok, style: .Default, handler: nil))
                        
                        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            self.presentViewController(confirmAlert, animated: true, completion: nil)
                        })
                    }
                    
                }else{
                    self.refreshFromCoreData()
                }})
        }
    }
    
    private func createAlertViewError(error : NSError) -> UIAlertController {
        var refreshAlert = UIAlertController(title: CantUpdateFromPeaceCorpsAlertText.title, message: CantUpdateFromPeaceCorpsAlertText.message, preferredStyle: .Alert)
        
        if error.code == -1009 {
            refreshAlert.message = NoInternetConnectionAlertText.message
            refreshAlert.addAction(UIAlertAction(title: AlertOptions.settings, style: .Default, handler: { _ in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }))
        }
        
        refreshAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
        return refreshAlert
    }
    
    private func refreshFromCoreData() -> Bool{
        Logger.Info("Fetching from coreData")
        if let newPosts = Posts.retrieve(Posts.self, context: viewContext).first {
            posts = newPosts.posts.convertToArray().sorted({$0.title < $1.title})
            collectionView.reloadData()
            return true
        }
        
        return false
    }
    
    @IBAction func settingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            let view = UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self) as SetupScreenViewController
            self.presentViewController(view, animated: true, completion: nil)
        }
    }
}

extension InfoHubViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("postCollectionCell", forIndexPath: indexPath) as! PeaceCorpsMessageCollectionViewCell
        
        cell.postBtn.titleLabel?.numberOfLines = 0
        cell.postBtn.titleLabel?.textAlignment = .Center
        
        //these two calls in sequence removes animation on title change
        cell.postBtn.titleLabel?.text = post.title
        cell.postBtn.setTitle(post.title, forState: .Normal)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let postView = UIStoryboard.instantiate(viewControllerClass: PostDetailedViewController.self)
        postView.post = posts[indexPath.row]
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(postView, animated: true, completion: nil)
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let spacing = determineSpacing()
        return UIEdgeInsetsMake(0, spacing, 0, spacing)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return determineSpacing()
    }
    
    private func determineSpacing() -> CGFloat{
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let numberItems = floor(screenWidth/PeaceCorpsMessageCollectionViewCell.CellWidth)
        let remainingScreen = screenWidth - numberItems*PeaceCorpsMessageCollectionViewCell.CellWidth
        
        return floor(remainingScreen/(numberItems - 1 + 2)) //left and right margin plus space between cells (numItems - 1)
    }
}

//alert messages
extension InfoHubViewController {
    typealias AlertText = (title: String, message: String)
    
    private var NoInformationAvailableAlertText: AlertText {get {
        return ("No available message from Peace Corps", "")
    }}
    
    private var CantUpdateFromPeaceCorpsAlertText: AlertText {get {
        return ("Couldn't Update Peace Corps Messages.", "Please try again later")
    }}
    
    private var NoInternetConnectionAlertText: AlertText {get {
        return ("Couldn't Update Peace Corps Messages.", "No available internet connection. Try again later")
    }}
    
    //type of alerts options
    private var AlertOptions: (ok: String, cancel: String, settings: String) {get {
        return ("ok", "Cancel", "Settings")
    }}
    
}

class PeaceCorpsMessageCollectionViewCell : UICollectionViewCell{
    static let CellWidth: CGFloat = 140
    @IBOutlet weak var postBtn: UIButton!
}