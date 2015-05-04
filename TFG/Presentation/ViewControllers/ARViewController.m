//
//  AugmentedRealityViewController.m
//  TFG
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARViewController.h"
#import "XMLElement.h"
#import "XMLParser.h"
#import "Mountain.h"
#import "TFG-Swift.h"
#import "Constants.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DataParser.h"
#import "LocationController.h"
#import "DetailViewController.h"
#import "RangeViewController.H"

@interface ARViewController ()
{
    vec4f_t *pointsOfInterestCoordinates;
}

/**
 *  Array of mountains for augmented reality
 */
@property (strong, atomic) NSArray *pointsOfInterest;

//Motion
@property (strong, nonatomic) CMMotionManager *motionManager;

/**
 *  Augmented Reality view
 */
@property (strong, nonatomic) ARView *arView;

/**
 *  Crosshair view
 */
@property (strong, nonatomic) TargetView *targetView;

// Previous location autorization status
@property CLAuthorizationStatus previousStatus;

// Settings properties
@property BOOL debugLocation;
@property BOOL debugAltitude;
@property BOOL debugAttitude;
@property BOOL enableGPSMessage;
@property BOOL ignoreGPSSignal;

/**
 *  Mountain inside crosshairs timer
 */
@property (strong, nonatomic) NSTimer *mountainInTargetTimer;

/**
 *  Boolean to control if a SVProgressHUD is already on screen, to avoid having multiple HUDs. // TODO andres.piza 21/04/2015 - Check this is so, I'm not sure if there are more than one
 */
@property BOOL isGPSHUDOn;

#pragma mark Detail View
@property (strong, nonatomic) UIView *detailViewContainer;

@property (strong, nonatomic) DetailViewController *detailViewController;

@property NSInteger lastMountain;

#pragma mark Range view
@property (strong, nonatomic) UIView *rangeViewContainer;

@property (strong, nonatomic) RangeViewController *rangeViewController;

@end

@implementation ARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arView = [[ARView alloc] initWithFrame:self.view.frame];
    self.arView.delegate = self;
    self.view = self.arView;
    
    [self initARData];
    
    [self setupDetailView];
    [self setupRangeView];
    
    self.arView.pointsOfInterest = self.pointsOfInterest;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateSettings];
    
    [self drawTarget];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTargetViewPosition:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    LocationController *sharedInstance = [LocationController sharedInstance];
    sharedInstance.delegate = self;
    
    [self.arView start];
    [self startMotion];
    
    self.mountainInTargetTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(detectMountainInsideTarget) userInfo:nil repeats:YES];
    
    self.lastMountain = -1;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.mountainInTargetTimer invalidate];
    
    LocationController *sharedInstance = [LocationController sharedInstance];
    sharedInstance.delegate = nil;
    
    [self.arView stop];
    [self stopMotion];
    [self dismissGPSHUD];
}

- (void)updateSettings
{
    self.debugLocation = [(NSNumber *) [[Utils sharedInstance] getUserSetting:debugLocationSettingKey] boolValue];
    self.debugAltitude = [(NSNumber *) [[Utils sharedInstance] getUserSetting:debugAltitudeSettingKey] boolValue];
    self.debugAttitude = [(NSNumber *) [[Utils sharedInstance] getUserSetting:debugAttitudeSettingKey] boolValue];
    self.enableGPSMessage = [(NSNumber *) [[Utils sharedInstance] getUserSetting:showGPSMessageSettingKey] boolValue];
    self.ignoreGPSSignal = [(NSNumber *) [[Utils sharedInstance] getUserSetting:ignoreGPSSignalSettingKey] boolValue];
}

#pragma mark - Target view
/**
 *  Processes rotation notifications, updating the TargetView position
 *
 *  @param notification UIApplicationDidChangeStatusBarOrientationNotification
 */
- (void)updateTargetViewPosition:(NSNotification *)notification
{
    self.view.frame = UIScreen.mainScreen.bounds;
    self.targetView.center = CGPointMake((self.view.frame.origin.x + (self.view.frame.size.width / 2)), (self.view.frame.origin.y + (self.view.frame.size.height / 2)));
}

/**
 *  Adds the TargetView to the center of the screen
 */
- (void)drawTarget
{
    self.targetView = TargetView.sharedInstance;
    self.targetView.center = CGPointMake((self.view.frame.origin.x + (self.view.frame.size.width / 2)), (self.view.frame.origin.y + (self.view.frame.size.height / 2)));
    [self.view addSubview:self.targetView];
}

/**
 *  Removes the TargetView from the view hierarchy
 */
- (void)removeTarget
{
    if (self.targetView != nil) {
        [self.targetView removeFromSuperview];
    }
}

#pragma mark - Augmented reality data
- (void)initARData
{
    NSMutableArray *mountainArray = [[NSMutableArray alloc] init];
    DataParser *sharedParser = [DataParser sharedParser];
    for (NSDictionary *mountain in sharedParser.mountains) {
        
        MountainUIImageView *mountainView = [[MountainUIImageView alloc] init];
        mountainView.tag = (NSInteger) ([mountainArray count] + 1);
        
        if ([mountain valueForKey:@"name"] == nil || [mountain valueForKey:@"lat"] == nil || [mountain valueForKey:@"lon"] == nil || [mountain valueForKey:@"ele"] == nil) {
            continue;
        }
        
        Mountain *m = [[Mountain alloc] initWithName:[mountain valueForKey:@"name"]
                                     alternativeName:[mountain valueForKey:@"alt_name"]
                                                 lat:[[mountain valueForKey:@"lat"] doubleValue]
                                                 lon:[[mountain valueForKey:@"lon"] doubleValue]
                                      alternativeLat:[[mountain valueForKey:@"alt_lat"] doubleValue]
                                      alternativeLon:[[mountain valueForKey:@"alt_lon"] doubleValue]
                                                 alt:[[mountain valueForKey:@"ele"] doubleValue]
                                 alternativeAltitude:[[mountain valueForKey:@"alt_ele"] doubleValue]
                                          postalCode:[mountain valueForKey:@"postal code"]
                                             wikiUrl:[mountain valueForKey:@"wikipedia"]
                                            withView:mountainView];
        
        [mountainArray addObject:m];
    }
    
    self.pointsOfInterest = mountainArray;
}

#pragma mark - Core Location controller delegate
/**
 *  Delegate method with new gps location
 *
 *  @param location the new location
 */
- (void)locationUpdate:(CLLocation *)location
{
    // Debugging traces
    if (self.debugLocation) {
        NSLog(@"Current location (lat, lon) = %f, %f; horizontal accuracy = %f", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    }
    if (self.debugAltitude) {
        NSLog(@"Current altitude = %f, vertical accuracy = %f", location.altitude, location.verticalAccuracy);
    }
    
    if (self.pointsOfInterest != nil && [self isAccuracyGoodForLocation:location]) {
        [self updatePointsOfInterestCoordinatesWithLocation:location];
    }
}

/**
 *  Check if the location is good enough for calcullations. If it's not, show a HUD informing the user he needs to wait for a better gps fix.
 *
 *  @param location the location to check the accuracy of
 *
 *  @return true if good, false if not
 */
- (BOOL)isAccuracyGoodForLocation:(CLLocation *)location
{
    if (self.ignoreGPSSignal) {
        [self dismissGPSHUD];
        return YES;
    }
    
    if (location.verticalAccuracy < 15 && location.horizontalAccuracy < 20) {
        [self dismissGPSHUD];
        return YES;
    } else if (!self.isGPSHUDOn) {
        [SVProgressHUD showWithStatus:@"Getting GPS position..."];
        self.isGPSHUDOn = YES;
        NSLog(@"GPS accuracy not enough, the HDU showing... right?");
    }
    
    NSLog(@"Ver, Hor: %f, %f", location.verticalAccuracy, location.horizontalAccuracy);
    
    return NO;
}

#pragma mark - Core Motion

- (void)startMotion
{
    self.motionManager = [[CMMotionManager alloc] init];
    
    self.motionManager.magnetometerUpdateInterval = 0.01;
    self.motionManager.deviceMotionUpdateInterval = 0.01; // = 20ms || 1.0/20.0 = 0.05; //seconds
    
    //Show calibration HUD when required.
    self.motionManager.showsDeviceMovementDisplay = YES;
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
}

- (void)stopMotion
{
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}

- (CMAttitude *)fetchAttitude
{
    if (self.debugAttitude) {
        NSLog(@"Fetching Attitude for View");
    }
    return self.motionManager.deviceMotion.attitude;
}

//From pARk
#pragma mark - POI management

- (void)updatePointsOfInterestCoordinatesWithLocation:(CLLocation *)deviceLocation
{
    if (pointsOfInterestCoordinates != NULL) {
        free(pointsOfInterestCoordinates);
    }
    
    pointsOfInterestCoordinates = (vec4f_t *)malloc(sizeof(vec4f_t)*self.pointsOfInterest.count);
    
    int i = 0;
    
    double myX, myY, myZ;
    latLonToEcef(deviceLocation.coordinate.latitude, deviceLocation.coordinate.longitude, deviceLocation.altitude, &myX, &myY, &myZ);
    
    // Array of NSData instances, each of which contains a struct with the distance to a POI and the
    // POI's index into placesOfInterest
    // Will be used to ensure proper Z-ordering of UIViews
    typedef struct {
        float distance;
        int index;
    } DistanceAndIndex;
    NSMutableArray *orderedDistances = [NSMutableArray arrayWithCapacity:[self.pointsOfInterest count]];
    
    // Compute the world coordinates of each place-of-interest
    for (Mountain *poi in self.pointsOfInterest) {
        double poiX, poiY, poiZ, e, n, u;
        
        latLonToEcef(poi.location.coordinate.latitude, poi.location.coordinate.longitude, poi.altitude, &poiX, &poiY, &poiZ);
        ecefToEnu(deviceLocation.coordinate.latitude, deviceLocation.coordinate.longitude, myX, myY, myZ, poiX, poiY, poiZ, &e, &n, &u);
        
        pointsOfInterestCoordinates[i][0] = (float)n;
        pointsOfInterestCoordinates[i][1] = -(float)e;
        pointsOfInterestCoordinates[i][2] = (float)u;
        pointsOfInterestCoordinates[i][3] = 1.0f;
        
        // Add struct containing distance and index to orderedDistances
        DistanceAndIndex distanceAndIndex;
        distanceAndIndex.distance = sqrtf((float) (n*n + e*e));
        distanceAndIndex.index = i;
        [orderedDistances insertObject:[NSData dataWithBytes:&distanceAndIndex length:sizeof(distanceAndIndex)] atIndex:(NSUInteger) i++];
        
        poi.distance = [deviceLocation distanceFromLocation:poi.location] / 1000.0;
    }
    
    // Sort orderedDistances in ascending order based on distance from the user
    [orderedDistances sortUsingComparator:(NSComparator)^(NSData *a, NSData *b) {
        const DistanceAndIndex *aData = (const DistanceAndIndex *)a.bytes;
        const DistanceAndIndex *bData = (const DistanceAndIndex *)b.bytes;
        if (aData->distance < bData->distance) {
            return NSOrderedAscending;
        } else if (aData->distance > bData->distance) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    ARView *view = (ARView *)self.view;
    
    // Add subviews in descending Z-order so they overlap properly
    for (NSData *d in [orderedDistances reverseObjectEnumerator]) {
        const DistanceAndIndex *distanceAndIndex = (const DistanceAndIndex *)d.bytes;
        Mountain *poi = (Mountain *)[self.pointsOfInterest objectAtIndex:(NSUInteger) distanceAndIndex->index];
        poi.distance = distanceAndIndex->distance;
        
        if ([[Utils sharedInstance] getRadiusInMeters] > poi.distance) {
            [view.mountainContainer addSubview:poi.view];
        }
    }
    
    view->pointsOfInterestCoordinates = pointsOfInterestCoordinates;
}

#pragma mark - Detail View

- (void)setupDetailView
{
    self.detailViewController = [DetailViewController sharedInstance];
    UIView *detailView = self.detailViewController.view;
    
    self.detailViewContainer = [[UIView alloc] initWithFrame:detailView.frame];
    self.detailViewContainer.opaque = NO;
    [self.detailViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.detailViewContainer];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailViewContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.detailViewContainer.frame.size.width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailViewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.detailViewContainer.frame.size.height]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailViewContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailViewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0]];
    
    [self.detailViewContainer addSubview:detailView];
    [self.detailViewController didMoveToParentViewController:self];
}

- (NSInteger)viewIntersectsWithAnotherView:(UIView *)selectedView
{
    ARView *view = (ARView *)self.view;
    // Copy to avoid concurrency problems
    __block NSArray *subViewsInMountainContainerView = nil;
    dispatch_sync(dispatch_get_main_queue(), ^{
        subViewsInMountainContainerView = [[view.mountainContainer subviews] copy];
    });
    if (subViewsInMountainContainerView == nil) {
        NSLog(@"ContainerView reference is broken, can't look for target intersection.");
    } else {
        for (UIView *aView in subViewsInMountainContainerView) {
            
            if (![selectedView isEqual:aView] && !aView.hidden) {
                if (CGRectIntersectsRect(selectedView.frame, aView.frame)) {
                    return aView.tag;
                }
            }
        }
    }
    
    return 0;
}

- (void)detectMountainInsideTarget
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger mountainIndex = [self viewIntersectsWithAnotherView:self.targetView];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self updateDetailViewForMountainIndex:mountainIndex];
        });
    });
}

- (void)updateDetailViewForMountainIndex:(NSInteger)mountainIndex
{
    
    if (mountainIndex != self.lastMountain) {
        self.lastMountain = mountainIndex;
    } else {
        return;
    }
    
    if (mountainIndex != 0) {
        Mountain *mountain = [self.pointsOfInterest objectAtIndex:(NSUInteger) mountainIndex - 1];
        [self.detailViewController showWithName:mountain.name distance:[NSString stringWithFormat:@"%f", mountain.distance] altitude:[NSString stringWithFormat:@"%f", mountain.altitude] wikiUrl:mountain.wikiUrl];
    } else {
        [self.detailViewController hide];
    }
}

#pragma mark - Range view
- (void)setupRangeView
{
    self.rangeViewController = [RangeViewController sharedInstance];
    UIView *rangeView = self.rangeViewController.view;
    
    self.rangeViewContainer = [[UIView alloc] initWithFrame:rangeView.frame];
    self.rangeViewContainer.opaque = NO;
    [self.rangeViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.rangeViewContainer];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rangeViewContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.rangeViewContainer.frame.size.width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rangeViewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.rangeViewContainer.frame.size.height]];    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rangeViewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rangeViewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10.0]];
    
    [self.rangeViewContainer addSubview:rangeView];
    [self.rangeViewController didMoveToParentViewController:self];
}

#pragma mark - Small utils
/**
 *  Dismisses SVProgressHUD and sets to false the isGPSHUDOn boolean
 */
- (void)dismissGPSHUD
{
    self.isGPSHUDOn = NO;
    [SVProgressHUD dismiss];
}

@end
