//
//  LocationController.h
//  TramuntanApp
//
//  Created by Andrés Pizá on 21/4/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationControllerDelegate

@required
- (void)locationUpdate:(CLLocation *)location;

@end

@interface LocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, weak) id  delegate;

/**
 *  Shared instance
 *
 *  @return Singleton instance
 */
+ (LocationController *)sharedInstance;

/**
 *  Start updating locations, if we have permission. If not, ask for it.
 */
- (void)startLocation;

/**
 *  Stop location updates.
 */
- (void)stopLocation;

@end
