//
//  AugmentedRealityViewController.m
//  TFG
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARViewController.h"
#import "ARController.h"
#import "TargetShape.h"

@interface ARViewController ()
@property (strong, nonatomic) ARController *ARController;
@property (weak, nonatomic) CAShapeLayer *targetLayer;

@end

@implementation ARViewController

- (void)loadView
{
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self.ARController = [[ARController alloc] initWithViewController:self];
	
	[self drawTarget];
}

- (void)drawTarget
{
    [self.targetLayer removeFromSuperlayer];
    
    CGRect bounds = self.view.bounds;
    CGPoint center = CGPointMake((bounds.size.width/(2+bounds.origin.x)), (bounds.size.height/(2+bounds.origin.y)));
    CAShapeLayer *targetLayer = [TargetShape createTargetView:center];
    
    self.targetLayer = targetLayer;
    
    [self.view.layer addSublayer:targetLayer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ARDelegate

- (NSMutableArray *)poiData
{
	NSMutableArray *data = [[NSMutableArray alloc] init];
	
	
	
	return data;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
