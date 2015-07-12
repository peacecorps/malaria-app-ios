//
//  InfoHubViewController.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 02/07/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import UIKit

class InfoHubViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    
    let refreshControl = UIRefreshControl()
    
    var viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
    
    var syncManager: SyncManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncManager = SyncManager(context: viewContext)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl.addTarget(self, action: "pullRefreshHandler", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    func pullRefreshHandler(){
        println("pull refresh")
        
        syncManager.sync(EndpointType.Posts.path(), save: true,
            completionHandler: {Void in
                self.refresh()
                self.refreshControl.endRefreshing()
        })
    }
    
    func refresh() -> Bool{
        Logger.Info("Fetching from coreData")
        let info = Posts.retrieve(Posts.self, context: viewContext)
        if info.count > 0{
            posts = info[0].posts.convertToArray()
            posts.sort({$0.title < $1.title})
            collectionView.reloadData()
            return true
        }
        
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Logger.Info("infoViewController will appear")
        
        if !refresh(){
            syncManager.sync(EndpointType.Posts.path(), save: true, completionHandler: {Void in self.refresh()})
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    @IBAction func settingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self), animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        var  cell = collectionView.dequeueReusableCellWithReuseIdentifier("postCollectionCell", forIndexPath: indexPath) as! PeaceCorpsMessageCollectionViewCell
        
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

        Logger.Info("Called didSelectItemAtIndexPath")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(postView, animated: true, completion: nil)
        }
        
    }
}

class PeaceCorpsMessageCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var postBtn: UIButton!
}