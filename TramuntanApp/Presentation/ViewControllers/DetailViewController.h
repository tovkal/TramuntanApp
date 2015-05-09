//
//  DetailViewController.h
//  TramuntanApp
//
//  Created by tovkal on 2/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARViewController.h"

@interface DetailViewController : UIViewController <UIGestureRecognizerDelegate>

/**
 *  Shared instance
 *
 *  @return Singleton instance
 */
+ (DetailViewController *)sharedInstance;

@property (nonatomic, weak) id  delegate;

- (void)showWithName:(NSString *)name distance:(NSString *)distance elevation:(NSString *)elevation wikiUrl:(NSString *)url;
- (void)hide;

@end
