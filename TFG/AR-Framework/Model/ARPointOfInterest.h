//
//  PointOfInterest.h
//  AR-Framework
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol ARPointOfInterestDelegate

- (NSMutableArray *)poiData;

@end

@interface ARPointOfInterest : NSObject

@property (nonatomic) double altitude;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) UIView *view;

- (id) initWithView:(UIView *)view atLat:(double)lat andLon:(double)lon withAltitude:(double)altitude;

@end
