//
//  ARCoreLocationController.h
//  TFG
//
//  Created by Tovkal on 23/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol ARCLDelegate <NSObject>

- (void)didFindLocation:(CLLocation *)location;

@end

@interface ARCoreLocationController : NSObject <CLLocationManagerDelegate>
@property (assign, nonatomic) id<ARCLDelegate> delegate;

- (void)setup;
@end
