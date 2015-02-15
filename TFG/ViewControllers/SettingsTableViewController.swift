//
//  SettingsTableViewController.swift
//  TFG
//
//  Created by Tovkal on 21/09/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITabBarControllerDelegate {
	
    @IBOutlet weak var locationDebugSwitch: UISwitch!
    @IBOutlet weak var altitudeDebugSwitch: UISwitch!
    @IBOutlet weak var attitudeDebugSwitch: UISwitch!
    @IBOutlet weak var enableGPSMessageSwitch: UISwitch!
    @IBOutlet weak var datasourceControl: UISegmentedControl!
    @IBOutlet weak var radiusSlider: UISlider!
	@IBOutlet var radiusLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Preserve selection between presentations
		self.clearsSelectionOnViewWillAppear = false
		
		self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.locationDebugSwitch.on = Utils.getUserSetting(debugLocationSettingKey) as Bool
        self.altitudeDebugSwitch.on = Utils.getUserSetting(debugAltitudeSettingKey) as Bool
        self.attitudeDebugSwitch.on = Utils.getUserSetting(debugAttitudeSettingKey) as Bool
        self.enableGPSMessageSwitch.on = Utils.getUserSetting(showGPSMessageSettingKey) as Bool

        if let datasource = Utils.getUserSetting(datasourceSettingKey) as? String {
            self.datasourceControl.selectedSegmentIndex = datasource == "muntanyes_dev" ? 0 : 1

        }
        self.radiusSlider.value = Utils.getUserSetting(radiusSettingKey) as Float
        updateRadiusLable(Int(self.radiusSlider.value))

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
                Utils.saveUserSetting(debugLocationSettingKey, value: self.locationDebugSwitch.on)
            case 2: //Altitude
                Utils.saveUserSetting(debugAltitudeSettingKey, value: self.altitudeDebugSwitch.on)
            case 3: //Attitude
                Utils.saveUserSetting(debugAttitudeSettingKey, value: self.attitudeDebugSwitch.on)
            case 4: //Disable GPS Message
                Utils.saveUserSetting(showGPSMessageSettingKey, value: self.enableGPSMessageSwitch.on)
            default:
                print("Switch unknown");
        }
    }

    @IBAction func changeDatasource(sender: UISegmentedControl) {
        
        switch(sender.selectedSegmentIndex) {
            case 0:
                Utils.saveUserSetting(datasourceSettingKey, value: "muntanyes_dev")
                break;
            case 1:
                Utils.saveUserSetting(datasourceSettingKey, value: "muntanyes_8")
                break;
            default:
                break;
        }
    }
    
	@IBAction func radiusDidChange(sender: UISlider) {
        Utils.saveUserSetting(radiusSettingKey, value: sender.value)
        updateRadiusLable(Int(sender.value))
	}
    
    private func updateRadiusLable(value: Int) {
  		self.radiusLabel.text = "Radius: \(value) km."
    }
}
