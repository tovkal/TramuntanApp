//
//  ARCoreLocationController.m
//  AR-Framework
//
//  Created by Tovkal on 23/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARCoreLocationController.h"

@interface ARCoreLocationController()
@property (strong, nonatomic) CLLocationManager *locationManager;

//TODO Remove after debug
@property (strong, nonatomic) CLLocation *lastLocation;
@end

@implementation ARCoreLocationController

- (void)start
{
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	//TODO test if this filter is enough
	self.locationManager.distanceFilter = 10; //meters
		
	[self.locationManager startUpdatingLocation];
	[self.locationManager startUpdatingHeading];
	
}

- (void)stop
{
	[self.locationManager stopUpdatingLocation];
	[self.locationManager stopUpdatingHeading];
	self.locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
	
	if (self.lastLocation) {
		NSLog(@"Distance betwen last and newest location: %f", [self.lastLocation distanceFromLocation:location]);
	}
		
	self.lastLocation = location;
	
	[self.delegate performSelector:@selector(didFindLocation:) withObject:location];
	
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
	[self.delegate performSelector:@selector(didUpdateHeading:) withObject:newHeading];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration: (CLLocationManager *)manager {
    return YES;
}

@end
