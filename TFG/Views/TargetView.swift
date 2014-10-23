//
//  TargetView.swift
//  TFG
//
//  Created by Tovkal on 14/10/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class TargetView: UIView {
    
    let width: CGFloat = 50
    let height: CGFloat = 50
    let cornerRadius: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.opaque = false
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        var center = CGPointMake((self.frame.origin.x + (self.frame.size.width / 2)),
            (self.frame.origin.y + (self.frame.size.height / 2)))
        print(center)
        var rectangleView = UIBezierPath(roundedRect: CGRectMake(center.x - width/2, center.y - height/2, width, height), cornerRadius: cornerRadius)
        var filling = UIColor.redColor()
        filling.setStroke()
        rectangleView.stroke()
    }

}
