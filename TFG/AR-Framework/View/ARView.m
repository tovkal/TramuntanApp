//
//  ARView.m
//  AR-Framework
//
//  Created by Tovkal on 23/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARView.h"
#import "TargetShape.h"
#import "Mountain.h"
#import "ARUtils.h"

@interface ARView()
{
	mat4f_t projectionTransform;
	mat4f_t cameraTransform;
}

@property (strong, nonatomic) UIView *captureView;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDevice *videoDeviceInput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureLayer;

@property (strong, nonatomic) CADisplayLink *displayLink;

@end


@implementation ARView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initialize];
    }
    return self;
}

- (void)initialize
{
	self.captureView = [[UIView alloc] initWithFrame:self.bounds];
	self.captureView.bounds = self.bounds;
	[self addSubview:self.captureView];
	[self sendSubviewToBack:self.captureView];
	
	// Initialize projection matrix
	//Fov angle from: http://stackoverflow.com/a/3594424/1283228
	createProjectionMatrix(projectionTransform, 61.4f*DEGREES_TO_RADIANS, self.bounds.size.width*1.0f / self.bounds.size.height, 0.25f, 1000.0f);

}

- (void)start
{
	AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	NSError *deviceInputError = nil;
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&deviceInputError];
	self.videoDeviceInput = inputDevice;
	
	if (!captureInput || deviceInputError != nil) {
		NSLog(@"Error during init of AVView");
	}
	
	AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
	
	NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
	NSNumber *value = [NSNumber numberWithUnsignedInteger:kCVPixelFormatType_32BGRA];
	NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
	
	[captureOutput setVideoSettings:videoSettings];
	
	self.captureSession = [[AVCaptureSession alloc] init];
    
    NSString *preset = 0;
    
    if (!preset) {
        preset = AVCaptureSessionPresetMedium;
    }
    
    self.captureSession.sessionPreset = preset;
    
    if ([self.captureSession canAddInput:captureInput]) {
        [self.captureSession addInput:captureInput];
    }
    
    if ([self.captureSession canAddOutput:captureOutput]) {
        [self.captureSession addOutput:captureOutput];
    }
    
    //handle prevLayer
    if (!self.captureLayer) {
        self.captureLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    
    //if you want to adjust the previewlayer frame, here!
	self.captureLayer.frame = self.captureView.bounds;
    self.captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.captureView.layer addSublayer: self.captureLayer];
    
	// Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self.captureSession startRunning];
	});
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	//If view starts in landscape, rotate the AV view.
	if ([[UIDevice currentDevice] orientation] != UIDeviceOrientationPortrait) {
		[self orientationChanged:nil];
	}
	
	[self startDisplayLink];
}

- (void)stop
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self.captureSession stopRunning];
	});
	[self.captureLayer removeFromSuperlayer];
	self.captureSession = nil;
	self.captureLayer = nil;
	
	[self stopDisplayLink];
}

- (void)startDisplayLink
{
	self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
	[self.displayLink setFrameInterval:1];
	[self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
	[self.displayLink invalidate];
	self.displayLink = nil;
}

- (void)onDisplayLink:(id)sender
{
	CMAttitude *a = [self.delegate performSelector:@selector(fetchAttitude)];
	if (a != nil) {
		CMRotationMatrix r = a.rotationMatrix;
		transformFromCMRotationMatrix(cameraTransform, &r);
		[self setNeedsDisplay];
	}
}

#pragma mark - View
- (void)orientationChanged:(NSNotification *)notification
{
	CGRect bounds = CGRectMake(0, 0, 1, 1);
    
    int xInt = 0;
    int yInt = 0;
	
	CGSize screenSize = [[UIScreen mainScreen] bounds].size;
	
	xInt = screenSize.width;
	yInt = screenSize.height;
	
    //TODO Test if it works on iPad. I think there's no need to hardcode the screen sizes.
	
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        //its iphone
//        CGSize result = [[UIScreen mainScreen] bounds].size;
//        if(result.height == 480) {
//            // iPhone Classic
//            xInt = 320;
//            yInt = 480;
//        }
//        else if(result.height == 568) {
//            // iPhone 5
//            xInt = 320;
//            yInt = 568;
//        }
//    } else {
//        //its ipad
//        xInt = 768;
//        yInt = 1024;
//    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    BOOL rotate = YES;
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            bounds = CGRectMake(0, 0, yInt, xInt);
            self.captureLayer.affineTransform = CGAffineTransformMakeRotation(M_PI + M_PI_2); // 270 degress
            break;
        case UIDeviceOrientationLandscapeRight:
            bounds = CGRectMake(0, 0, yInt, xInt);
            self.captureLayer.affineTransform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotate = NO;
            //bounds = CGRectMake(0, 0, xInt, yInt);
            //self.captureVideoPreviewLayer.affineTransform = CGAffineTransformMakeRotation(M_PI); // 180 degrees
            break;
		case UIDeviceOrientationFaceDown:
		case UIDeviceOrientationFaceUp:
			rotate = NO;
			break;
        default: //Portrait
            bounds = CGRectMake(0, 0, xInt, yInt);
            self.captureLayer.affineTransform = CGAffineTransformMakeRotation(0.0);
            break;
    }
    
    if (rotate) {
        self.captureLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    }
}

- (void)drawRect:(CGRect)rect
{
	if (self.pointsOfInterestCoordinates == nil) {
		return;
	}
	
	mat4f_t projectionCameraTransform;
	multiplyMatrixAndMatrix(projectionCameraTransform, projectionTransform, cameraTransform);
	
	int i = 0;
	for (Mountain *poi in [self.pointsOfInterest objectEnumerator]) {
		vec4f_t v;
		
		vec4f_t *poiCoordinates = [ARUtils getCoordinatesForIndex:i inArray:self.pointsOfInterestCoordinates];
		
		multiplyMatrixAndVector(v, projectionCameraTransform, poiCoordinates[i]);
		
		float x = (v[0] / v[3] + 1.0f) * 0.5f;
		float y = (v[1] / v[3] + 1.0f) * 0.5f;
		if (v[2] < 0.0f) {
			poi.view.center = CGPointMake(x*self.bounds.size.width, self.bounds.size.height-y*self.bounds.size.height);
			poi.view.hidden = NO;
		} else {
			poi.view.hidden = YES;
		}
		i++;
	}
}

@end
