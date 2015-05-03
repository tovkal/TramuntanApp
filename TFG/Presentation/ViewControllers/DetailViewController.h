//
//  DetailViewController.h
//  TFG
//
//  Created by tovkal on 2/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARViewController.h"

@protocol RadiusIconTapped

@required
- (void)radiusMenuShouldHide:(BOOL)hide;

@end

@interface DetailViewController : UIViewController <UIGestureRecognizerDelegate>

/**
 *  Shared instance
 *
 *  @return Singleton instance
 */
+ (DetailViewController *)sharedInstance;

@property (nonatomic, weak) id  delegate;

- (void)showWithName:(NSString *)name distance:(NSString *)distance altitude:(NSString *)altitude wikiUrl:(NSString *)url;
- (void)hide;

@end
