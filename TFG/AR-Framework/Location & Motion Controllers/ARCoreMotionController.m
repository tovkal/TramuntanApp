//
//  ARCoreMotionController.m
//  AR-Framework
//
//  Created by Tovkal on 26/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARCoreMotionController.h"

@interface ARCoreMotionController()

@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ARCoreMotionController

- (void)start
{
	self.motionManager = [[CMMotionManager alloc] init];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
									 target:self
								   selector:@selector(gotValues)
								   userInfo:nil
									repeats:YES];
	self.motionManager.deviceMotionUpdateInterval = 0.05; //seconds
	//Show calibration HUD when required.
	self.motionManager.showsDeviceMovementDisplay = YES;
	[self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
	
}

- (void)stop
{
	[self.timer invalidate];
	[self.motionManager stopDeviceMotionUpdates];
	self.motionManager = nil;
}

- (void)gotValues
{
	if (self.motionManager.deviceMotion.attitude != nil) {
		[self.delegate performSelector:@selector(gotNewValues:) withObject:self.motionManager.deviceMotion.attitude];
	}
}

@end