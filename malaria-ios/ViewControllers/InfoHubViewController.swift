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
    
    var posts2: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func refresh() -> Bool{
        Logger.Info("Fetching from coreData")
        
        posts2 = Post.retrieve(Post.self)
        /*
        let info = Posts.retrieve(Posts.self)
        if info.count > 0{
        posts2 = info[0].posts.convertToArray()
        return true
        }*/
        println(posts2.count)
        
        collectionView.reloadData()
        
        return posts2.count != 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Logger.Info("infoViewController will appear")
        
        if !refresh(){
            SyncManager.sharedInstance.sync(EndpointType.Posts.path(), save: true, completionHandler: {Void in self.refresh()})
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts2.count
    }
    
    @IBAction func settingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self), animated: true, completion: nil)
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let post = posts2[indexPath.row]
        var  cell = collectionView.dequeueReusableCellWithReuseIdentifier("postCollectionCell", forIndexPath: indexPath) as! PeaceCorpsMessageCollectionViewCell
        
        cell.postBtn.titleLabel?.numberOfLines = 0
        cell.postBtn.titleLabel?.textAlignment = .Center
        cell.postBtn.setTitle(post.title, forState: .Normal)
        return cell
    }
}

class PeaceCorpsMessageCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var postBtn: UIButton!
}