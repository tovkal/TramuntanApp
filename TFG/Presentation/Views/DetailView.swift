//
//  DetailView.swift
//  TFG
//
//  Created by Tovkal on 25/10/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    var isFadingOut = false
    
    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    func fadeOut() {
        if (!self.hidden) {
            UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.isFadingOut = true
                self.alpha = 0.0
                }, completion: {
                    (value: Bool) in
                    self.hidden = true
                    self.isFadingOut = false
            })
        }
    }
}
