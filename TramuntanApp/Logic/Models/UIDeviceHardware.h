//
//  UIDeviceHardware.h
//  TramuntanApp
//
//  Created by Tovkal on 15/09/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//
//  Used to determine EXACT version of device software is running on.

#import <Foundation/Foundation.h>

@interface UIDeviceHardware : NSObject

+ (NSString *)platform;
+ (NSString *)platformString;
+ (NSString *)platformStringSimple;

@end
