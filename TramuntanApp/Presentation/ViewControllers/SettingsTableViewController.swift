//
//  SettingsTableViewController.swift
//  TramuntanApp
//
//  Created by Tovkal on 21/09/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.tableView.delegate = self
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) where cell.reuseIdentifier == "email_support" {
            
            UIApplication.sharedApplication().openURL(NSURL(string: "mailto:tramuntanapp@tovkal.com?subject=[TramuntanApp Support] Subject".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        }
    }
}
