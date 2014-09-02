//
//  PointOfInterest.m
//  AR-Framework
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARPointOfInterest.h"

@implementation ARPointOfInterest

- (id) initWithName:(NSString *)name atLat:(double)lat andLon:(double)lon withAltitude:(double)altitude withView:(UIView *)view
{
	self = [super init];
	self.view = view;
	self.location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
	self.altitude = altitude;
	
	return self;
}


@end
