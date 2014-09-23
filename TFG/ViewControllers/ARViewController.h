//
//  AugmentedRealityViewController.h
//  TFG
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "ARView.h"

@interface ARViewController : UIViewController <CLLocationManagerDelegate, AttitudeDelegate>

@property BOOL debugLocation;
@property BOOL debugAltitude;
@property BOOL debugAttitude;
@property BOOL enableGPSMessage;
@property float radius;

@end
