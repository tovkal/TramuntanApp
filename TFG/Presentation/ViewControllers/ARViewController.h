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

@end
