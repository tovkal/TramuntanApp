//
//  APBViewController.m
//  ARTest1
//
//  Created by Tovkal on 02/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARViewController.h"

@interface ARViewController ()
// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (strong, nonatomic) AVCaptureDevice *videoDeviceInput;

@end

@implementation ARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAndExposeTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tapRecognizer];

    
    [self initCapture];
}

- (void)initCapture
{
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    
    self.videoDeviceInput = inputDevice;
    
    if (!captureInput) {
        return;
    }
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    /* captureOutput:didOutputSampleBuffer:fromConnection delegate method !*/
    //[captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    
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
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    
    //if you want to adjust the previewlayer frame, here!
    self.captureVideoPreviewLayer.frame = self.view.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.captureVideoPreviewLayer];
    [self.captureSession startRunning];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
}

- (void) orientationChanged:(NSNotification *)notification
{
    CGRect bounds = CGRectMake(0, 0, 1, 1);
    
    int xInt = 0;
    int yInt = 0;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //its iphone
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480) {
            // iPhone Classic
            xInt = 320;
            yInt = 480;
        }
        else if(result.height == 568) {
            // iPhone 5
            xInt = 320;
            yInt = 568;
        }
    } else {
        //its ipad
        xInt = 768;
        yInt = 1024;
    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    BOOL rotate = YES;
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            bounds = CGRectMake(0, 0, yInt, xInt);
            self.captureVideoPreviewLayer.affineTransform = CGAffineTransformMakeRotation(M_PI + M_PI_2); // 270 degress
            break;
        case UIDeviceOrientationLandscapeRight:
            bounds = CGRectMake(0, 0, yInt, xInt);
            self.captureVideoPreviewLayer.affineTransform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotate = NO;
            //bounds = CGRectMake(0, 0, xInt, yInt);
            //self.captureVideoPreviewLayer.affineTransform = CGAffineTransformMakeRotation(M_PI); // 180 degrees
            break;
        default:
            bounds = CGRectMake(0, 0, xInt, yInt);
            self.captureVideoPreviewLayer.affineTransform = CGAffineTransformMakeRotation(0.0);
            break;
    }
    
    if (rotate) {
        self.captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    }
}

#pragma mark - Tap-to-focus

- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *) self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *device = self.videoDeviceInput;
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    });
}


@end
