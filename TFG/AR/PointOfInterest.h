//
//  PointOfInterest.h
//  TFG
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PointOfInterest : NSObject

@property (strong, nonatomic) CLLocation *geographicLocation;
@property (strong, nonatomic) UIView *viewRepresentation;

@end
