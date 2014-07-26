//
//  ARCoreMotionController.m
//  TFG
//
//  Created by Tovkal on 26/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARCoreMotionController.h"

@interface ARCoreMotionController()

@property (strong, nonatomic) CMMotionManager *coreMotionManager;

@end

@implementation ARCoreMotionController

- (void)setup
{
	self.coreMotionManager = [[CMMotionManager alloc] init];
	[NSTimer scheduledTimerWithTimeInterval:0.1
									 target:self
								   selector:@selector(gotValues)
								   userInfo:nil
									repeats:YES];
	self.coreMotionManager.deviceMotionUpdateInterval = 0.05; //seconds
	[self.coreMotionManager startDeviceMotionUpdates];
	
}

- (void)gotValues
{
	if (self.coreMotionManager.deviceMotion.attitude != nil) {
		[self.delegate performSelector:@selector(gotNewValues:) withObject:self.coreMotionManager.deviceMotion.attitude];
	}
}

@end