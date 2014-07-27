//
//  AugmentedRealityViewController.h
//  TFG
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARCoreLocationController.h"
#import "ARCoreMotionController.h"
#import "ARView.h"

@interface ARViewController : UIViewController <CLLocationManagerDelegate, ARCLDelegate, ARCMDelegate>

@property BOOL locationDebug;
@property BOOL headingDebug;
@property BOOL altitudeDebug;

@end
