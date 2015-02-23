//
//  TargetView.swift
//  TFG
//
//  Created by Tovkal on 14/10/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class TargetView: UIView {
    
    let size: CGFloat = 25
    let cornerRadius: CGFloat = 4
	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        var rectangleView = UIBezierPath(roundedRect: CGRectMake(1, 1, size, size), cornerRadius: cornerRadius)
        var filling = UIColor.redColor()
        filling.setStroke()
		rectangleView.lineWidth = 1
        rectangleView.stroke()
    }

}
