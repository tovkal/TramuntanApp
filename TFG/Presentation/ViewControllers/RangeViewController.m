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

@interface RangeViewController ()

@property (weak, nonatomic) IBOutlet UISlider *rangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation RangeViewController

+ (RangeViewController *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.rangeSlider setMaximumTrackTintColor:[UIColor blackColor]];
    
    [DetailViewController sharedInstance].delegate = self;
    
    NSNumber *value = [Utils getUserSetting:radiusSettingKey];
    if (value != nil) {
        [self setDistance:value.floatValue];
        
        self.rangeSlider.value = value.floatValue;
    }
    
    self.view.hidden = YES;
}

- (IBAction)handleRangeChange:(UISlider *)sender
{
    [self setDistance:sender.value];
    
    [Utils saveUserSetting:radiusSettingKey value:[NSNumber numberWithFloat:sender.value]];
}

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
