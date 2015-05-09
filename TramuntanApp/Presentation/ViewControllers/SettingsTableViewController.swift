//
//  SettingsTableViewController.swift
//  TramuntanApp
//
//  Created by Tovkal on 21/09/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var datasourceControl: UISegmentedControl!
    @IBOutlet weak var ignoreGPSSignal: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if let datasource = Utils.sharedInstance().getUserSetting(datasourceSettingKey) as? String {
            self.datasourceControl.selectedSegmentIndex = datasource == "muntanyes_dev" ? 0 : 1
        }
        
        if let ignoreGPSSignal = Utils.sharedInstance().getUserSetting(ignoreGPSSignalSettingKey) as? Bool {
            self.ignoreGPSSignal.on = ignoreGPSSignal
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
