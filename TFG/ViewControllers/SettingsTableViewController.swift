//
//  SettingsTableViewController.swift
//  TFG
//
//  Created by Tovkal on 21/09/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITabBarControllerDelegate {

	var debugLocation = false
	var debugAltitude = false
	var debugAttitude = false
	var enableGPSMessage = true
	
	var radius: Float = 0.0
	
	@IBOutlet var radiusLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Preserve selection between presentations
		self.clearsSelectionOnViewWillAppear = false
		
		self.tabBarController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 44.0
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 44.0
	}
	
	@IBAction func switchDidChange(sender: UISwitch) {
		switch (sender.tag) {
		case 1: //Location
			self.debugLocation = sender.on ? true : false
		case 2: //Altitude
			self.debugAltitude = sender.on ? true : false
		case 3: //Attitude
			self.debugAttitude = sender.on ? true : false
		case 4: //Disable GPS Message
			self.enableGPSMessage = sender.on ? true : false
		default:
			print("Switch unknown");
		}
	}

	@IBAction func radiusDidChange(sender: UISlider) {
		radius = sender.value
		self.radiusLabel.text = "Radius: \(Int(radius)) km."
	}
	
	func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
		
		if (viewController.tabBarItem.tag == 1) {
			if let viewControllers = tabBarController.viewControllers as? [UIViewController] {
				var vc: ARViewController = viewControllers[0] as ARViewController
				
				vc.debugLocation = self.debugLocation
				vc.debugAltitude = self.debugAltitude
				vc.debugAttitude = self.debugAttitude
				vc.enableGPSMessage = self.enableGPSMessage;
				vc.radius = radius
			}
		}
	}
	
}
