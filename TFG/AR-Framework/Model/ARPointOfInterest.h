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

@property (nonatomic) double distance;
@property (nonatomic) double altitude;
@property (nonatomic) double azimuth;

@property (strong, nonatomic) CLLocation *geographicLocation;
@property (strong, nonatomic) UIView *viewRepresentation;

@end
