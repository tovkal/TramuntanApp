//
//  DetailViewController.m
//  TFG
//
//  Created by tovkal on 2/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import "DetailViewController.h"
#import "TFG-Swift.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wikiIcon;
@property (weak, nonatomic) IBOutlet UIImageView *raidusIcon;

@property (strong, nonatomic) NSString *wikiUrl;

@property (strong, nonatomic) DetailView *detailView;

@property (strong, nonatomic) ARViewController *parent;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.detailView = (DetailView *)self.view;
}

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
    
    self.view.alpha = 1.0;
    self.view.hidden = false;
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
    if (self.wikiUrl != nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.wikiUrl]];
    }
}

- (void)hide
{
    if (!self.detailView.hidden && !self.detailView.isFadingOut) {
        [self.detailView fadeOut];
    }
}
@end
