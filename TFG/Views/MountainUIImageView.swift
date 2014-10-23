//
//  MountainUIImageView.swift
//  TFG
//
//  Created by tovkal on 23/10/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class MountainUIImageView: UIImageView {
    
    init(position: CGPoint) {
        let frame = CGRectMake(0, 0, 20, 20)

        super.init(frame: frame)
        
        let image = UIImage(named: "Icon")
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.image = image
        self.center = position
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
