//
//  PostDetailedViewController.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 03/07/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import UIKit


class PostDetailedViewController : UIViewController{
    var post: Post!
    let BackgroundImageId = "background"
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: BackgroundImageId)!)
        
        postTitle.text = post.title
        postDescription.text = post.post_description
    }
    
    @IBAction func goBackBtnHandler(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}