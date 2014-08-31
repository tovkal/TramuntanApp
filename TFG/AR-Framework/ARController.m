//
//  ARController.m
//  TFG v2
//
//  Created by Tovkal on 31/08/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARController.h"

@interface ARController()

@property (strong, nonatomic) ARCoreLocationController *coreLocationController;
@property (strong, nonatomic) ARCoreMotionController *coreMotionControlller;

@property (strong, nonatomic) ARPointOfInterest *device;

@end

@implementation ARController

- (id) initWithFrame:(CGRect)frame
{
	self = [super init];
	
	self.arView = [[ARView alloc] initWithFrame:frame];
	
	return self;
}

- (void) startAR
{
	[self.arView start];
	[self startLocation];
	[self startMotion];
}

- (void) stopAR
{
	[self.arView stop];
	[self stopLocation];
	[self stopMotion];
}

- (void)startLocation
{
	self.coreLocationController = [[ARCoreLocationController alloc] init];
	self.coreLocationController.delegate = self;
	[self.coreLocationController start];
}

- (void)stopLocation
{
	[self.coreLocationController stop];
}

- (void)startMotion
{
	self.coreMotionControlller = [[ARCoreMotionController alloc] init];
	self.coreMotionControlller.delegate = self;
	[self.coreMotionControlller start];
	
}

- (void)stopMotion
{
	[self.coreMotionControlller stop];
}

#pragma mark - ARCLDelegate

- (void)didFindLocation:(CLLocation *)location
{
	self.device.location = location;
}

#pragma mark - ARCMDelegate

- (void)gotNewValues:(CMAttitude *)attitude
{
	
}

- (id)device
{
	if (_device == nil) {
		_device = [[ARPointOfInterest alloc] initWithView:nil atLat:0 andLon:0 withAltitude:0];
	}
	
	return _device;
}

@end
