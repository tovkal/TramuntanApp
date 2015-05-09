//
//  LocationController.m
//  TramuntanApp
//
//  Created by Andrés Pizá on 21/4/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController

#pragma mark - Singleton methods
- (id)init
{
    self = [super init];
    
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10; // meters
        
        [self startLocation];
    }
    
    return self;
}

+ (LocationController *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Core location methods
/**
 *  Start updating locations, if we have permission. If not, ask for it.
 */
- (void)startLocation
{
    CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
    
    switch (currentStatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization]; // TODO andres.piza 21/04/2015 - Test this is right
        default:
            NSLog(@"No permissions"); // TODO andres.piza 21/04/2015 - Do something about it, show screen of why we need permission
            break;
    }
}

/**
 *  Stop location updates.
 */
- (void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
}

/**
 *  Permission situation changed.
 *
 *  @param manager What location manager
 *  @param status  What's the news
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self startLocation];
}

/**
 *  Check if heading error is good enough for our needs or should we calibrate.
 *
 *  @param manager What location manager
 *
 *  @return True if needs callibration, false if not.
 */
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    if (!manager.heading) return YES; // Got nothing, We can assume we got to calibrate.
    else if (manager.heading.headingAccuracy < 0) return YES; // 0 means invalid heading, need to calibrate
    else if (manager.heading.headingAccuracy > 0.5)return YES; // 5 degrees is a small value correct for my needs, too.
    else return NO; // All is good. Compass is precise enough.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationUpdate:)]) {
        [self.delegate locationUpdate:self.location];
    }
}

@end
