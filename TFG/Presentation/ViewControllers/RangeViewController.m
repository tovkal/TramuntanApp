//
//  RangeViewController.m
//  TFG
//
//  Created by tovkal on 3/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import "RangeViewController.h"
#import "TFG-Swift.h"
#import "Constants.h"
#import <Pop/Pop.h>

@interface RangeViewController ()

#pragma mark View outlets

@property (weak, nonatomic) IBOutlet UIImageView *radiusIcon;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

#pragma mark Frame values

@property CGRect realRangeViewFrame;
@property CGRect dwarfedRangeViewFrame;

@end

@implementation RangeViewController

#pragma mark - View controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.radiusSlider setMaximumTrackTintColor:[UIColor blackColor]];
    
    [DetailViewController sharedInstance].delegate = self;
    
    NSNumber *value = [[Utils sharedInstance] getUserSetting:radiusSettingKey];
    if (value != nil) {
        [self setDistance:value.floatValue];
        
        self.radiusSlider.value = value.floatValue;
    }
    
    self.realRangeViewFrame = self.view.frame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.view.frame;
    frame.size.width = self.radiusIcon.frame.size.width + self.radiusIcon.frame.origin.x * 2;
    self.view.frame = frame;
    
    self.dwarfedRangeViewFrame = frame;
    
    self.radiusSlider.hidden = YES;
    self.distanceLabel.hidden = YES;
    
    self.view.layer.cornerRadius = self.view.frame.size.width / 2;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.radiusIcon.highlighted = NO;
}

- (void)removeFromParentViewController
{
    [super removeFromParentViewController];
    
    self.radiusIcon.highlighted = NO;
}

# pragma mark - Gesture recognizers

- (IBAction)handleRadiusIconTap:(UITapGestureRecognizer *)sender
{
    if (!self.radiusIcon.highlighted) {
        
        [self.view.layer pop_removeAnimationForKey:@"makeRound"];
        [self.view pop_removeAnimationForKey:@"makeSmall"];
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:self.realRangeViewFrame];
        animation.springBounciness = 10;
        animation.springSpeed = 5;
        animation.animationDidStartBlock = ^(POPAnimation *anim) {
            self.radiusSlider.hidden = NO;
            self.distanceLabel.hidden = NO;
            self.radiusIcon.highlighted = YES;
        };
        animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            self.radiusSlider.hidden = NO;
            self.distanceLabel.hidden = NO;
            self.radiusIcon.highlighted = YES;
        };
        [self.view pop_addAnimation:animation forKey:@"makeBig"];
        
        POPSpringAnimation *cornerAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
        cornerAnim.toValue = @(5.0f);
        cornerAnim.springBounciness = 10;
        cornerAnim.springSpeed = 6;
        [self.view.layer pop_addAnimation:cornerAnim forKey:@"makeRoundedRect"];
    } else {
        
        [self.view pop_removeAnimationForKey:@"makeBig"];
        [self.view.layer pop_removeAnimationForKey:@"makeRoundedRect"];
        
        POPSpringAnimation *cornerRadiusAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
        cornerRadiusAnim.toValue = @(self.dwarfedRangeViewFrame.size.width / 2);
        cornerRadiusAnim.springBounciness = 10;
        cornerRadiusAnim.springSpeed = 5;
        [self.view.layer pop_addAnimation:cornerRadiusAnim forKey:@"makeRound"];
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:self.dwarfedRangeViewFrame];
        animation.springBounciness = 10;
        animation.springSpeed = 5;
        animation.animationDidStartBlock = ^(POPAnimation *anim) {
            self.radiusSlider.hidden = YES;
            self.distanceLabel.hidden = YES;
        };
        animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            self.radiusIcon.highlighted = NO;
        };
        [self.view pop_addAnimation:animation forKey:@"makeSmall"];
    }
}

- (IBAction)handleRangeChange:(UISlider *)sender
{
    [self setDistance:sender.value];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:rangeNotification object:self userInfo:@{radiusSettingKey: [NSNumber numberWithFloat:sender.value]}];
}

#pragma mark - View methods

/**
 *  Set distance label text
 *
 *  @param distance distance value to set
 */
- (void)setDistance:(float)distance
{
    self.distanceLabel.text = [NSString stringWithFormat:@"%i km", (int) distance];
}

#pragma mark - Radius icon protocol
- (void)radiusMenuShouldHide:(BOOL)hide
{
    self.view.hidden = hide;
}

@end
