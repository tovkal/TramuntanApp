//
//  DetailView.swift
//  TFG
//
//  Created by Tovkal on 25/10/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class DetailView: UIView {
	
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!

	func fadeOut() {
        UIView.animateWithDuration(5, animations: {
            self.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.hidden = true
        })

	}
}
