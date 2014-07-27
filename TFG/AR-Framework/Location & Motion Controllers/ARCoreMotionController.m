//
//  ARCoreMotionController.m
//  AR-Framework
//
//  Created by Tovkal on 26/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARCoreMotionController.h"

@interface ARCoreMotionController()

@property (strong, nonatomic) CMMotionManager *coreMotionManager;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ARCoreMotionController

- (void)start
{
	self.coreMotionManager = [[CMMotionManager alloc] init];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
									 target:self
								   selector:@selector(gotValues)
								   userInfo:nil
									repeats:YES];
	self.coreMotionManager.deviceMotionUpdateInterval = 0.05; //seconds
	[self.coreMotionManager startDeviceMotionUpdates];
	
}

- (void)stop
{
	[self.timer invalidate];
	[self.coreMotionManager stopDeviceMotionUpdates];
	self.coreMotionManager = nil;
}

- (void)gotValues
{
	if (self.coreMotionManager.deviceMotion.attitude != nil) {
		[self.delegate performSelector:@selector(gotNewValues:) withObject:self.coreMotionManager.deviceMotion.attitude];
	}
}

@end