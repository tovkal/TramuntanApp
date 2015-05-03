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
@property (weak, nonatomic) IBOutlet UIImageView *radiusIcon;

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
    self.distanceLabel.text = distance;
    self.altitudeLabel.text = altitude;
    
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
 *  Handle tap in the wiki and radius icons
 *
 *  @param sender which icon was tapped
 */
- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 1:
            [self handleWikiTap];
            break;
        case 2:
            [self handleRadiusTap];
            break;
        default:
            break;
    }
}

/**
 *  Handle tap on the wiki icon, opening page in web browser
 */
- (void)handleWikiTap
{
    if (self.wikiUrl != nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.wikiUrl]];
    }
}

/**
 *  Show or hide raidus view
 */
- (void)handleRadiusTap
{
    self.radiusIcon.highlighted = !self.radiusIcon.highlighted;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(radiusMenuShouldHide:)]) {
        [self.delegate radiusMenuShouldHide:!self.radiusIcon.highlighted];
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
