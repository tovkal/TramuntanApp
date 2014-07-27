//
//  ARCoreLocationController.h
//  AR-Framework
//
//  Created by Tovkal on 23/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@protocol ARCLDelegate <NSObject>

- (void)didFindLocation:	(CLLocation *)	location;
- (void)didUpdateHeading:	(CLHeading *)	heading;

@end

@interface ARCoreLocationController : NSObject <CLLocationManagerDelegate>

@property (assign, nonatomic) id<ARCLDelegate> delegate;

- (void)start;
- (void)stop;

@end
