//
//  DetailView.swift
//  TramuntanApp
//
//  Created by Tovkal on 25/10/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    fileprivate let showAnimationKey = "detail_show_animation"
    fileprivate let hideAnimationKey = "detail_hide_animation"
    
    fileprivate var showing = false
    fileprivate var hiding = false
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    func showWithAnimation(_ point: CGFloat) {
        self.layer.pop_removeAnimation(forKey: hideAnimationKey)
        
        
        if !self.showing {
            self.isHidden = false
            
            self.showing = true
            
            let animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation?.fromValue = self.center.y
            animation?.toValue = point
            animation?.springSpeed = 15
            animation?.springBounciness = 10
            animation?.completionBlock = {(animation, finished) in
                self.showing = false;
            }
            
            self.layer.pop_add(animation, forKey: showAnimationKey)
        }
    }
    
    func hideWithAnimation() {
        self.layer.pop_removeAnimation(forKey: showAnimationKey)
        
        if !self.hiding {
            self.hiding = true
            
            let animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation?.toValue = -(self.center.y + self.frame.size.height/2)
            animation?.springSpeed = 15
            animation?.springBounciness = 10
            animation?.beginTime = CACurrentMediaTime() + 3
            animation?.completionBlock = {(animation, finished) in
                self.isHidden = true
                self.hiding = false
            }
            
            self.layer.pop_add(animation, forKey: hideAnimationKey)
        }
    }
}
