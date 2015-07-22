//
//  UISlider.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 22/07/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import UIKit

extension UISlider {
    @IBInspectable var yScale: CGFloat {
        get {
            return self.transform.ty
        }
        set(value) {
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, value)
        }
    }
    
    @IBInspectable var showThumbImage: Bool {
        get {
            return self.thumbImageForState(.Normal) == UIImage()
        }
        set(value) {
            if value == false {
                self.setThumbImage(UIImage(), forState: .Normal)
            }
        }
    }
    
    @IBInspectable var rightColor: UIColor {
        get {
            return self.maximumTrackTintColor ?? UIColor.clearColor()
        }
        
        set(value){
            self.maximumTrackTintColor = value
        }
    }
    
    /*
    slider.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, BarHeightScale)
    slider.maximumTrackTintColor = UIColor.whiteColor()
    */
}
