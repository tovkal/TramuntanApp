//
//  Mountain.m
//  TFG v2
//
//  Created by Tovkal on 31/08/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "Mountain.h"

@implementation Mountain

- (instancetype) initWithName:(NSString *)name alternativeName:(NSString *)alt_name lat:(double)lat lon:(double)lon alternativeLat:(double)alt_lat alternativeLon:(double)alt_lon alt:(double)alt alternativeAltitude:(double)alt_altitude postalCode:(NSString *)postalCode withView:(UIView *)view
{
	if (self = [super init]) {
		self.location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
		self.altitude = alt;
		self.view = view;
	}
	
	self.name = name;
	self.alt_name = alt_name;
	self.alt_loc = [[CLLocation alloc] initWithLatitude:alt_lat longitude:alt_lon];
	self.alt_altitude = alt_altitude;
	self.postalCode = postalCode;
	
	return self;
}

@end
