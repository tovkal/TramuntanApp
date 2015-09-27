//
//  MountainUIImageView.swift
//  TramuntanApp
//
//  Created by tovkal on 23/10/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class MountainUIImageView: UIImageView {
    
    init() {
        let frame = CGRectMake(0, 0, 12, 10)
        
        super.init(frame: frame)
        
        let image = UIImage(named: "mountain")
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
