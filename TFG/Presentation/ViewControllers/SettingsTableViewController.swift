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
    @IBOutlet weak var ignoreGPSSignal: UISwitch!
    @IBOutlet weak var horizontalFOVLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if let locationDebug = Utils.sharedInstance().getUserSetting(debugLocationSettingKey) as? Bool {
            self.locationDebugSwitch.on = locationDebug
        }
        
        if let altitudeDebug = Utils.sharedInstance().getUserSetting(debugAltitudeSettingKey) as? Bool {
            self.altitudeDebugSwitch.on = altitudeDebug
        }
        
        if let attitudeDebug = Utils.sharedInstance().getUserSetting(debugAttitudeSettingKey) as? Bool {
            self.attitudeDebugSwitch.on = attitudeDebug
        }
        
        if let enableGPSMessage = Utils.sharedInstance().getUserSetting(showGPSMessageSettingKey) as? Bool {
            self.enableGPSMessageSwitch.on = enableGPSMessage
        }
        
        if let datasource = Utils.sharedInstance().getUserSetting(datasourceSettingKey) as? String {
            self.datasourceControl.selectedSegmentIndex = datasource == "muntanyes_dev" ? 0 : 1
        }
        
        if let ignoreGPSSignal = Utils.sharedInstance().getUserSetting(ignoreGPSSignalSettingKey) as? Bool {
            self.ignoreGPSSignal.on = ignoreGPSSignal
        }
        
        if let fov = Utils.sharedInstance().getUserSetting(fovSettingKey) as? Float {
            self.horizontalFOVLabel.text = "\(fov)"
        }
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
            Utils.sharedInstance().saveUserSetting(debugLocationSettingKey, value: self.locationDebugSwitch.on)
        case 2: //Altitude
            Utils.sharedInstance().saveUserSetting(debugAltitudeSettingKey, value: self.altitudeDebugSwitch.on)
        case 3: //Attitude
            Utils.sharedInstance().saveUserSetting(debugAttitudeSettingKey, value: self.attitudeDebugSwitch.on)
        case 4: //Disable GPS Message
            Utils.sharedInstance().saveUserSetting(showGPSMessageSettingKey, value: self.enableGPSMessageSwitch.on)
        case 5:
            Utils.sharedInstance().saveUserSetting(ignoreGPSSignalSettingKey, value: self.ignoreGPSSignal.on)
        default:
            print("Switch unknown");
        }
    }
    
    @IBAction func changeDatasource(sender: UISegmentedControl) {
        
        switch(sender.selectedSegmentIndex) {
        case 0:
            Utils.sharedInstance().saveUserSetting(datasourceSettingKey, value: "muntanyes_dev")
        case 1:
            Utils.sharedInstance().saveUserSetting(datasourceSettingKey, value: "muntanyes8")
        default:
            break;
        }
    }
}
