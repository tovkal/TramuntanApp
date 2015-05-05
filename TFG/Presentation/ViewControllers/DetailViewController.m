//
//  DetailViewController.m
//  TFG
//
//  Created by tovkal on 2/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import "DetailViewController.h"
#import "TFG-Swift.h"
#import <Pop/Pop.h>

@interface DetailViewController ()
#pragma mark Detail view

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wikiIcon;

@property (strong, nonatomic) NSString *wikiUrl;

@property (strong, nonatomic) DetailView *detailView;

@property CGFloat centerY;

@end

@implementation DetailViewController

+ (DetailViewController *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.detailView = (DetailView *)self.view;
    self.detailView.hidden = YES;
    self.centerY = self.detailView.center.y;
}

/**
 *  Update labels with mountain info
 *
 *  @param name     mountain name
 *  @param distance mountain distance
 *  @param altitude mountain altitude
 *  @param url      mountain url to wikipedia
 */
- (void)showWithName:(NSString *)name distance:(NSString *)distance altitude:(NSString *)altitude wikiUrl:(NSString *)url
{
    self.nameLabel.text = name;
    self.distanceLabel.text = [distance doubleValue] > 999 ? [NSString stringWithFormat:@"%.2f km", [distance doubleValue]/1000.0] : [NSString stringWithFormat:@"%.2f m", [distance doubleValue]];
    self.altitudeLabel.text = [NSString stringWithFormat:@"%.2f m", [altitude doubleValue]];
    
    if (url != nil && ![url  isEqual: @"NULL"]) {
        self.wikiUrl = url;
        self.wikiIcon.hidden = NO;
    } else {
        self.wikiUrl = nil;
        self.wikiIcon.hidden = YES; // Maybe set some alpha?
    }
    
    [self.detailView showWithAnimation:self.centerY];
}

/**
 *  Handle tap on the wiki icon, opening page in web browser
 *
 *  @param sender which icon was tapped
 */
- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
    if (self.wikiUrl != nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.wikiUrl]];
    }
}

/**
 *  Hide detail view if visible
 */
- (void)hide
{
    if (!self.detailView.hidden) {
        [self.detailView hideWithAnimation];
    }
}
@end
