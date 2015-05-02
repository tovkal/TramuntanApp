//
//  DetailViewController.h
//  TFG
//
//  Created by tovkal on 2/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARViewController.h"

@interface DetailViewController : UIViewController <UIGestureRecognizerDelegate>

- (void)showWithName:(NSString *)name distance:(NSString *)distance altitude:(NSString *)altitude wikiUrl:(NSString *)url;
- (void)hide;

@end
