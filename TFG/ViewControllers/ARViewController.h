//
//  AugmentedRealityViewController.h
//  TFG
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARPointOfInterest.h"
#import <CoreLocation/CoreLocation.h>
#import "ARCoreLocationController.h"

@interface ARViewController : UIViewController <CLLocationManagerDelegate, ARPointOfInterestDelegate, ARCLDelegate>
@property BOOL locationDebug;

@end
