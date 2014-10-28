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
	
	var isNotFadingOut = true

	func fadeOut() {
		if (!self.hidden) {
			UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
				self.isNotFadingOut = false
				self.alpha = 0.0
				}, completion: {
					(value: Bool) in
					self.hidden = true
					self.isNotFadingOut = true
			})
		}
	}
}
