//
//  ARController.m
//  TFG v2
//
//  Created by Tovkal on 31/08/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARController.h"
#import "ARUtils.h"

@interface ARController()
{
	CADisplayLink *displayLink;
}

@property (strong, nonatomic) ARCoreLocationController *coreLocationController;
@property (strong, nonatomic) ARCoreMotionController *coreMotionControlller;

@property (strong, nonatomic) ARPointOfInterest *device;

@property (strong, nonatomic) CMAttitude *attitude;

@end

vec4f_t *pointsOfInterestCoordinates;

@implementation ARController

- (id) initWithBounds:(CGRect)bounds
{
	self = [super init];
	
	self.arView = [[ARView alloc] initWithFrame:bounds];
	
	return self;
}

- (void) startAR
{
	[self.arView start];
	[self startLocation];
	[self startMotion];
	[self startDisplayLink];
	
}

- (void) stopAR
{
	[self.arView stop];
	[self stopLocation];
	[self stopMotion];
	[self stopDisplayLink];
}

- (void)startLocation
{
	self.coreLocationController = [[ARCoreLocationController alloc] init];
	self.coreLocationController.delegate = self;
	[self.coreLocationController start];
}

- (void)stopLocation
{
	[self.coreLocationController stop];
}

- (void)startMotion
{
	self.coreMotionControlller = [[ARCoreMotionController alloc] init];
	self.coreMotionControlller.delegate = self;
	[self.coreMotionControlller start];
	
}

- (void)stopMotion
{
	[self.coreMotionControlller stop];
}

- (void)startDisplayLink
{
	displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
	[displayLink setFrameInterval:1];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
	[displayLink invalidate];
	displayLink = nil;
}


- (void) updatePointsOfInterest
{
	if (pointsOfInterestCoordinates != NULL) {
		free(pointsOfInterestCoordinates);
	}
	pointsOfInterestCoordinates = (vec4f_t *)malloc(sizeof(vec4f_t)*self.pointsOfInterest.count);
	
	int i = 0;
	
	double myX, myY, myZ;
	latLonToEcef(self.device.location.coordinate.latitude, self.device.location.coordinate.longitude, self.device.location.altitude, &myX, &myY, &myZ);
	
	// Array of NSData instances, each of which contains a struct with the distance to a POI and the
	// POI's index into placesOfInterest
	// Will be used to ensure proper Z-ordering of UIViews
	typedef struct {
		float distance;
		int index;
	} DistanceAndIndex;
	NSMutableArray *orderedDistances = [NSMutableArray arrayWithCapacity:self.pointsOfInterest.count];
	
	// Compute the world coordinates of each place-of-interest
	for (ARPointOfInterest *poi in [self.pointsOfInterest objectEnumerator]) {
		double poiX, poiY, poiZ, e, n, u;
		
		latLonToEcef(poi.location.coordinate.latitude, poi.location.coordinate.longitude, poi.altitude, &poiX, &poiY, &poiZ);
		ecefToEnu(self.device.location.coordinate.latitude, self.device.location.coordinate.longitude, myX, myY, myZ, poiX, poiY, poiZ, &e, &n, &u);
		
		pointsOfInterestCoordinates[i][0] = (float)n;
		pointsOfInterestCoordinates[i][1] = -(float)e;
		pointsOfInterestCoordinates[i][2] = (float)u;
		pointsOfInterestCoordinates[i][3] = 1.0f;
		
		// Add struct containing distance and index to orderedDistances
		DistanceAndIndex distanceAndIndex;
		distanceAndIndex.distance = sqrtf(n*n + e*e);
		distanceAndIndex.index = i;
		[orderedDistances insertObject:[NSData dataWithBytes:&distanceAndIndex length:sizeof(distanceAndIndex)] atIndex:i++];
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
	
	// Add subviews in descending Z-order so they overlap properly
	for (NSData *d in [orderedDistances reverseObjectEnumerator]) {
		const DistanceAndIndex *distanceAndIndex = (const DistanceAndIndex *)d.bytes;
		ARPointOfInterest *poi = (ARPointOfInterest *)[self.pointsOfInterest objectAtIndex:distanceAndIndex->index];
		[self.arView addSubview:poi.view];
	}

}

- (void)onDisplayLink:(id)sender
{
	CMRotationMatrix r = self.attitude.rotationMatrix;
	transformFromCMRotationMatrix(self.arView->cameraTransform, &r);
	[self.arView setNeedsDisplay];
}


#pragma mark - ARCLDelegate

- (void)didFindLocation:(CLLocation *)location
{
	self.device.location = location;
	
	if (self.arView.pointsOfInterest != nil) {
		[self updatePointsOfInterest];
	}
}

#pragma mark - ARCMDelegate

- (void)gotNewValues:(CMAttitude *)attitude
{
	self.attitude = attitude;
}

- (id)device
{
	if (_device == nil) {
		_device = [[ARPointOfInterest alloc] initWithName:@"divice" atLat:0 andLon:0 withAltitude:0 withView:nil];
	}
	
	return _device;
}

@end
