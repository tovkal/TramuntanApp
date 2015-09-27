//
//  Utils.swift
//  TramuntanApp
//
//  Created by Andrés Pizá on 15/2/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

import Foundation

@objc class Utils: NSObject {
    
    private var lastRadius: Double?
    
    // class let datasourceSettingKey = "datasource" // Not suported yet, set in Constants.h
    
    // swiftSharedInstance is not accessible from ObjC
    class var swiftSharedInstance: Utils {
        struct Singleton {
            static let instance = Utils()
        }
        return Singleton.instance
    }
    
    // the sharedInstance class method can be reached from ObjC
    class func sharedInstance() -> Utils {
        return Utils.swiftSharedInstance
    }
    
    override init() {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateRangeSetting:", name: rangeNotification, object: nil)
        
        if let radius = getUserSetting(radiusSettingKey) as? Double where radius > 0 {
            self.lastRadius = radius
        }
    }
    
    // Save an object in NSUserDefaults for a given key
    func saveUserSetting(key: String, value: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(value, forKey: key)
        
        defaults.synchronize()
    }
    
    // Fetch an object in NSUSerDefaults for a given key
    func getUserSetting(key: String) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        return defaults.objectForKey(key)
    }
    
    /**
    Get radius setting or default 30 km in meters
    
    - returns: radius setting or default 30 km * 1000
    */
    func getRadiusInMeters() -> Double {
        
        var radius: Double = 30
        
        if self.lastRadius != nil {
            radius = self.lastRadius!
        }
        
        return radius * 1000
    }
    
    @objc private func updateRangeSetting(notification: NSNotification) {
        if let userInfo = notification.userInfo as? Dictionary<String, Double> {
            if let newRadius = userInfo[radiusSettingKey] {
                self.lastRadius = newRadius
                saveUserSetting(radiusSettingKey, value: newRadius)
            }
        }
    }
}