//
//  AugmentedRealityViewController.m
//  TFG
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARViewController.h"
#import "APBXMLElement.h"
#import "APBXMLParser.h"
#import "Mountain.h"
#import "Constants.h"
#import "TFG-Swift.h"

@interface ARViewController ()
{
	vec4f_t *pointsOfInterestCoordinates;
}

//Array for XML Data
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, atomic) NSArray *pointsOfInterest;

//Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location; //Device location

//Motion
@property (strong, nonatomic) CMMotionManager *motionManager;

//GPS views
@property (strong, nonatomic) IBOutlet UILabel *gpsLabel;
@property (strong, nonatomic) IBOutlet UILabel *horAccLabel;
@property (strong, nonatomic) IBOutlet UILabel *verAccLabel;

@property (strong, nonatomic) ARView *arView;

@property (strong, nonatomic) TargetView *targetView;

@property (strong, nonatomic) DetailView *detailView;

// Previous location autorization status
@property CLAuthorizationStatus previousStatus;

// Settings properties
@property BOOL debugLocation;
@property BOOL debugAltitude;
@property BOOL debugAttitude;
@property BOOL enableGPSMessage;
@property float radius;
@property (strong, nonatomic) NSString *actualDatasource;
@property BOOL ignoreGPSSignal;

@end

@implementation ARViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.arView = [[ARView alloc] initWithFrame:self.view.frame];
	self.arView.delegate = self;
	self.view = self.arView;
	
	[self parseXML];
	[self initARData];
	
	[self setupDetailView];
	
	self.arView.pointsOfInterest = self.pointsOfInterest;
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateSettings];
	
	[self drawTarget];
	
	[self initGPSMessage];
	
	[self setupDetailViewConstraints];
	[self.detailView fadeOut];
	
	[self.arView start];
	[self startLocation];
	[self startMotion];
	
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self startDetectingMountainInsideTarget];
	});
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self.arView stop]; // TODO: This method blocks sometimes when changing to another tab bar item
	[self stopLocation];
	[self stopMotion];
	[self removeGPSMessage];
}

-(void)updateSettings
{
    self.debugLocation = [(NSNumber *) [Utils getUserSetting:debugLocationSettingKey] boolValue];
    self.debugAltitude = [(NSNumber *) [Utils getUserSetting:debugAltitudeSettingKey] boolValue];
    self.debugAttitude = [(NSNumber *) [Utils getUserSetting:debugAttitudeSettingKey] boolValue];
    self.enableGPSMessage = [(NSNumber *) [Utils getUserSetting:showGPSMessageSettingKey] boolValue];
    self.radius = [(NSNumber *) [Utils getUserSetting:radiusSettingKey] floatValue];
    
    // Check if datasource has changed. If so, update data
    if (![self.actualDatasource isEqualToString:(NSString *)[Utils getUserSetting:datasourceSettingKey]]) {
        exit(0);
    }
    
    self.ignoreGPSSignal = [(NSNumber *) [Utils getUserSetting:ignoreGPSSignalSettingKey] boolValue];
}

#pragma mark - Target view TEMPORARY
//TODO Find better location for this
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self drawTarget];
}

- (void)drawTarget
{
	[self removeTarget];
		
    self.targetView = [[TargetView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
    self.targetView.opaque = NO;
    self.targetView.center = CGPointMake((self.view.frame.origin.x + (self.view.frame.size.width / 2)), (self.view.frame.origin.y + (self.view.frame.size.height / 2)));
	[self.view addSubview:self.targetView];
}

- (void)removeTarget
{
	if (self.targetView != nil) {
		[self.targetView removeFromSuperview];
	}
}

- (void)doNothing:(ARView *)arView{}

#pragma mark - XML Data

- (void)parseXML
{
	APBXMLParser *parser  = [[APBXMLParser alloc] init];
    self.actualDatasource = [Utils getUserSetting:datasourceSettingKey];
    APBXMLElement *rootElement = [parser parseXML:self.actualDatasource];
	
	[self toArray:rootElement];
}

- (void)toArray:(APBXMLElement *)rootElement
{
	APBXMLElement *database = rootElement.subElements[1];
	
	for (APBXMLElement *mountainElement in database.subElements) {
		
		NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
		
		NSArray *attributeArray = @[@"name", @"alt_name", @"lat", @"lon", @"alt_lat", @"alt_lon", @"ele", @"alt_ele", @"postal_code"];
		
		for (APBXMLElement *attribute in mountainElement.subElements) {
			NSArray *values = [attribute.attributes allValues];
			NSInteger item = [attributeArray indexOfObject:values[0]];
			
			switch (item) {
				case 0: //name
				case 1: //alt_name
				case 2: //lat
				case 3: //lon
				case 4: //alt_lat
				case 5: //alt_lon
				case 6: //ele
				case 7: //alt_ele
                    if (attribute.text != nil) {
                        [dictionary setObject:attribute.text forKey:attributeArray[item]];
                    }
					break;
				case 8: //postal code
					[dictionary setObject:[attribute.text componentsSeparatedByString:@", "] forKey:attributeArray[item]];
					break;
				case NSIntegerMax: break;
				default:
					NSLog(@"Error converting XML Data to Array, attribute key not found: %@", attribute.attributes);
					break;
			}
		}
		
		[self.data addObject:dictionary];
		
	}
}

- (NSMutableArray *)data
{
	if (_data == nil) {
		_data = [[NSMutableArray alloc] init];
	}
	
	return _data;
}

- (void)initARData
{
	NSMutableArray *mountainArray = [[NSMutableArray alloc] init];
	for (NSDictionary *mountain in self.data) {
		        
        MountainUIImageView *mountainView = [[MountainUIImageView alloc] init];
        mountainView.tag = [mountainArray count] + 1;
        
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
											withView:mountainView];
		
		[mountainArray addObject:m];
	}
	
	self.pointsOfInterest = mountainArray;
}

#pragma mark - Core Location

- (void)startLocation
{
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = 10; //meters

	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	
	if (status == kCLAuthorizationStatusNotDetermined) {
		[self.locationManager requestWhenInUseAuthorization];
		NSLog(@"Requesting permission");
	} else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
		[self.locationManager startUpdatingLocation];
	} else if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
		NSLog(@"Don't have Location permission");
	}

}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    if (!manager.heading) return YES; // Got nothing, We can assume we got to calibrate.
    else if (manager.heading.headingAccuracy < 0) return YES; // 0 means invalid heading, need to calibrate
    else if (manager.heading.headingAccuracy > 0.5)return YES; // 5 degrees is a small value correct for my needs, too.
    else return NO; // All is good. Compass is precise enough.
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // Avoid infinite calls between this and startLocation as startLocation will trigger this method
    if (self.previousStatus != status) {
        switch (status) {
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                [self startLocation];
                break;
            case kCLAuthorizationStatusNotDetermined:
                [self.locationManager requestWhenInUseAuthorization];
            default:
                break;
        }
    }
    
    self.previousStatus = status;
}

- (void)stopLocation
{
	[self.locationManager stopUpdatingLocation];
	self.locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	self.location = [locations lastObject];
	
	if (self.debugLocation) {
		NSLog(@"Current location (lat, lon) = %f, %f; horizontal accuracy = %f", self.location.coordinate.latitude, self.location.coordinate.longitude, self.location.horizontalAccuracy);
	}
	if (self.debugAltitude) {
		NSLog(@"Current altitude = %f, vertical accuracy = %f", self.location.altitude, self.location.verticalAccuracy);
	}
	
	[self showGPSMessage];

    if (self.pointsOfInterest != nil && [self haveRequiredGPSAccuracy]) {
		[self updatePointsOfInterestCoordinates];
	} else {
		[self showGPSMessage];
	}
}

- (BOOL)haveRequiredGPSAccuracy
{
    if (self.ignoreGPSSignal) {
        return YES;
    }
    
	if (self.location.verticalAccuracy < 15 && self.location.horizontalAccuracy < 20) {
		[self hideGPSMessage];
		return YES;
	} else {
		NSLog(@"GPS accuracy not enough, the GPSMessage showing... right?");
	}
	
	return NO;
}


- (void)initGPSMessage
{
	//20, 20
	UILabel *label = [[UILabel alloc] init];
	label.adjustsFontSizeToFitWidth = NO;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.center = CGPointMake(100.0f, 30.0f);
	label.textAlignment = NSTextAlignmentLeft;
	label.textColor = [UIColor redColor];
	label.text = @"Getting good GPS fix...";
	CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
	label.bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
	label.hidden = YES;
	
	self.gpsLabel = label;
	[self.view addSubview:self.gpsLabel];
	
	UILabel *label2 = [[UILabel alloc] init];
	label2.adjustsFontSizeToFitWidth = NO;
	label2.opaque = NO;
	label2.backgroundColor = [UIColor clearColor];
	label2.center = CGPointMake(100.0f, 50.0f);
	label2.textAlignment = NSTextAlignmentLeft;
	label2.textColor = [UIColor redColor];
	label2.text = @"Hor. Acc. = 0000m";
	CGSize size2 = [label2.text sizeWithAttributes:@{NSFontAttributeName: label2.font}];
	label2.bounds = CGRectMake(0.0f, 0.0f, size.width, size2.height);
	label2.hidden = YES;

	self.horAccLabel = label2;
	[self.view addSubview:self.horAccLabel];
	
	UILabel *label3 = [[UILabel alloc] init];
	label3.adjustsFontSizeToFitWidth = NO;
	label3.opaque = NO;
	label3.backgroundColor = [UIColor clearColor];
	label3.center = CGPointMake(100.0f, 70.0f);
	label3.textAlignment = NSTextAlignmentLeft;
	label3.textColor = [UIColor redColor];
	label3.text = @"Ver. Acc. = 0000m";
	CGSize size3 = [label3.text sizeWithAttributes:@{NSFontAttributeName: label3.font}];
	label3.bounds = CGRectMake(0.0f, 0.0f, size.width, size3.height);
	label3.hidden = YES;
	
	self.verAccLabel = label3;
	[self.view addSubview:self.verAccLabel];

}


- (void)showGPSMessage
{
	if (self.enableGPSMessage) {
		[self.gpsLabel		setHidden:NO];
		self.horAccLabel.text = [NSString stringWithFormat:@"Hor. Acc. = %f", self.location.horizontalAccuracy];
		[self.horAccLabel	setHidden:NO];
		self.verAccLabel.text = [NSString stringWithFormat:@"Ver. Acc. = %f", self.location.verticalAccuracy];
		[self.verAccLabel	setHidden:NO];
	}
}

- (void)hideGPSMessage
{
	[self.gpsLabel		setHidden:YES];
	[self.horAccLabel	setHidden:YES];
	[self.verAccLabel	setHidden:YES];
}

- (void)removeGPSMessage
{
	self.gpsLabel = nil;
	self.horAccLabel = nil;
	self.verAccLabel = nil;
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

- (void)updatePointsOfInterestCoordinates
{
	if (pointsOfInterestCoordinates != NULL) {
		free(pointsOfInterestCoordinates);
	}
	
	pointsOfInterestCoordinates = (vec4f_t *)malloc(sizeof(vec4f_t)*self.pointsOfInterest.count);
	
	int i = 0;
	
	double myX, myY, myZ;
	latLonToEcef(self.location.coordinate.latitude, self.location.coordinate.longitude, self.location.altitude, &myX, &myY, &myZ);
	
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
		ecefToEnu(self.location.coordinate.latitude, self.location.coordinate.longitude, myX, myY, myZ, poiX, poiY, poiZ, &e, &n, &u);
		
		pointsOfInterestCoordinates[i][0] = (float)n;
		pointsOfInterestCoordinates[i][1] = -(float)e;
		pointsOfInterestCoordinates[i][2] = (float)u;
		pointsOfInterestCoordinates[i][3] = 1.0f;
		
		// Add struct containing distance and index to orderedDistances
		DistanceAndIndex distanceAndIndex;
		distanceAndIndex.distance = sqrtf(n*n + e*e);
		distanceAndIndex.index = i;
		[orderedDistances insertObject:[NSData dataWithBytes:&distanceAndIndex length:sizeof(distanceAndIndex)] atIndex:i++];
		
		poi.distance = [self.location distanceFromLocation:poi.location] / 1000.0;
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
		Mountain *poi = (Mountain *)[self.pointsOfInterest objectAtIndex:distanceAndIndex->index];
        
        if (self.radius * 1000 > distanceAndIndex->distance) {
            [view.mountainContainer addSubview:poi.view];
        }
	}
	
	view->pointsOfInterestCoordinates = pointsOfInterestCoordinates;
	
	// Set painting radius
	if (self.radius == 0.0) {
		view.radius = 30.0;
	} else {
		view.radius = self.radius;
	}

}

#pragma mark - Detail View


- (void)setupDetailView
{
	self.detailView =[[[NSBundle mainBundle] loadNibNamed:@"DetailView" owner:self options:nil] lastObject];
	[self.view addSubview:self.detailView];
}

- (void)setupDetailViewConstraints
{
	id topGuide = self.topLayoutGuide;
	NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_detailView, topGuide);
	NSLayoutConstraint *constraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[_detailView]" options:0 metrics:nil views:viewsDictionary] firstObject];
	[self.view addConstraint:constraint];
}

- (NSInteger)viewIntersectsWithAnotherView:(UIView *)selectedView
{
	ARView *view = (ARView *)self.view;
	// Copy to avoid concurrency problems
	__block NSArray *subViewsInMountainContainerView = nil;
	dispatch_sync(dispatch_get_main_queue(), ^{
		subViewsInMountainContainerView = [[view.mountainContainer subviews] copy]; // TODO too much memory? blocking much?
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

- (void)startDetectingMountainInsideTarget
{
	while (true) {
        NSInteger mountainIndex = [self viewIntersectsWithAnotherView:self.targetView];
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self updateDetailViewForMountainIndex:mountainIndex];
		});
	}
}

- (void)updateDetailViewForMountainIndex:(NSInteger)mountainIndex
{
	if (mountainIndex != 0) {
		Mountain *targeted = [self.pointsOfInterest objectAtIndex:mountainIndex - 1];
			self.detailView.nameLabel.text = targeted.name;
			self.detailView.distanceLabel.text = [NSString stringWithFormat:@"%f", targeted.distance];
			self.detailView.altitudeLabel.text = [NSString stringWithFormat:@"%f", targeted.altitude];
			self.detailView.alpha = 1.0f;
			self.detailView.hidden = NO;
	} else if (mountainIndex == 0 && !self.detailView.hidden && self.detailView.isNotFadingOut) {
			[self.detailView fadeOut];
	}
}

@end
