//
//  Mountain.h
//  TFG v2
//
//  Created by Tovkal on 31/08/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARPointOfInterest.h"

@interface Mountain : ARPointOfInterest

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *alt_name;
@property (strong, nonatomic) CLLocation *alt_loc;
@property (nonatomic) double alt_altitude;
@property (strong, nonatomic) NSString *postalCode;

- (instancetype) initWithName:(NSString *)name alternativeName:(NSString *)alt_name lat:(double)lat lon:(double)lon alternativeLat:(double)alt_lat alternativeLon:(double)alt_lon alt:(double)alt alternativeAltitude:(double)alt_altitude postalCode:(NSString *)postalCode withView:(UIView *)view;

@end
