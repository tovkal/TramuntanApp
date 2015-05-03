//
//  RangeView.swift
//  TFG
//
//  Created by tovkal on 3/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

import UIKit

class RangeView: UIView {
    
    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
