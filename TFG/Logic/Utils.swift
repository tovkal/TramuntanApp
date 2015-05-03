//
//  Utils.swift
//  TFG
//
//  Created by Andrés Pizá on 15/2/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

import Foundation

@objc class Utils {
    
    // class let datasourceSettingKey = "datasource" // Not suported yet, set in Constants.h
    
    // Save an object in NSUserDefaults for a given key
    class func saveUserSetting(key: String, value: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(value, forKey: key)
        
        defaults.synchronize()
    }
    
    // Fetch an object in NSUSerDefaults for a given key
    class func getUserSetting(key: String) -> AnyObject? {
        var defaults = NSUserDefaults.standardUserDefaults()
        
        return defaults.objectForKey(key)
    }
    
    /**
    Get radius setting or default 30 in meters
    
    :returns: radius setting or default 30 * 1000
    */
    class func getRadiusInMeters() -> Float {
        
        var radius: Float = 30
        
        if let radiusSetting = getUserSetting(radiusSettingKey) as? Float where radiusSetting > 0 {
            radius = radiusSetting
        }
        
        return radius * 1000
    }
}