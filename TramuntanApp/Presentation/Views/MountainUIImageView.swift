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
        let frame = CGRect(x: 0, y: 0, width: 12, height: 10)
        
        super.init(frame: frame)
        
        let image = UIImage(named: "mountain")
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
