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
	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        var rectangleView = UIBezierPath(roundedRect: CGRectMake(0, 0, width, height), cornerRadius: cornerRadius)
        var filling = UIColor.redColor()
        filling.setStroke()
        rectangleView.stroke()
    }

}
