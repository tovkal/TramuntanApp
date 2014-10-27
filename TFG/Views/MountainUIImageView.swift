//
//  MountainUIImageView.swift
//  TFG
//
//  Created by tovkal on 23/10/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class MountainUIImageView: UIImageView {
    
    override init() {
        let frame = CGRectMake(0, 0, 20, 20)

        super.init(frame: frame)
        
        let image = UIImage(named: "Icon")
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.image = image
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
