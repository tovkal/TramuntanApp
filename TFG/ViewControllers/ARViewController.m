//
//  AugmentedRealityViewController.m
//  TFG
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARViewController.h"
#import "TargetShape.h"
#import "ARView.h"

@interface ARViewController ()
@property (strong, nonatomic) ARView *myView;

@property (strong, nonatomic) ARCoreLocationController *clController;
@end

@implementation ARViewController

- (void)viewDidLoad
{
	self.myView = [[ARView alloc] initWithFrame:self.view.frame];
	self.view = self.myView;	
	[self.myView drawTarget];
		
	[self setupDelegates];
}

- (void)viewWillAppear:(BOOL)animated
{
	//When the view is setup, draw target because if we do it before and the view starts in landscape the target will not be drawn properly as view.bounds are not correct yet
	[self.myView drawTarget];
}

- (void) setupDelegates
{
	self.clController = [[ARCoreLocationController alloc] init];
	self.clController.delegate = self;
	[self.clController setup];
}

#pragma mark - ARDelegate

- (NSMutableArray *)poiData
{
	NSMutableArray *data = [[NSMutableArray alloc] init];
	
	return data;
}

#pragma mark - ARCLDelegate

- (void)didFindLocation:(CLLocation *)location
{
	if (self.locationDebug){
		NSLog(@"%@", location);
	}
}

@end
