//
//  ARController.m
//  TFG
//
//  Created by Tovkal on 21/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARController.h"

@interface ARController()

@property (strong, nonatomic) UIViewController *parentViewController;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDevice *videoDeviceInput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation ARController

- (id)initWithViewController:(UIViewController *)viewController
{
	self.parentViewController = viewController;
	
	[self startCamera];
		
	return self;
}

- (void)startCamera
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
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    
    //if you want to adjust the previewlayer frame, here!
    self.captureVideoPreviewLayer.frame = self.parentViewController.view.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.parentViewController.view.layer addSublayer: self.captureVideoPreviewLayer];
    [self.captureSession startRunning];

}

@end
