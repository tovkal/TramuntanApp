//
//  DetailView.swift
//  TFG
//
//  Created by Tovkal on 25/10/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    private let showAnimationKey = "detail_show_animation"
    private let hideAnimationKey = "detail_hide_animation"
    
    private var showing = false
    private var hiding = false
    
    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    func showWithAnimation(point: CGFloat) {
        self.layer.pop_removeAnimationForKey(hideAnimationKey)
        
        
        if !self.showing {
            self.hidden = false
            
            self.showing = true
            
            var animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation.fromValue = self.center.y
            animation.toValue = point
            animation.springSpeed = 15
            animation.springBounciness = 10
            animation.completionBlock = {(animation, finished) in
                self.showing = false;
            }
            
            self.layer.pop_addAnimation(animation, forKey: showAnimationKey)
        }
    }
    
    func hideWithAnimation() {
        self.layer.pop_removeAnimationForKey(showAnimationKey)
        
        if !self.hiding {
            self.hiding = true
            
            var animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation.toValue = -(self.center.y + self.frame.size.height/2)
            animation.springSpeed = 15
            animation.springBounciness = 10
            animation.beginTime = CACurrentMediaTime() + 3
            animation.completionBlock = {(animation, finished) in
                self.hidden = true
                self.hiding = false
            }
            
            self.layer.pop_addAnimation(animation, forKey: hideAnimationKey)
        }
    }
}
