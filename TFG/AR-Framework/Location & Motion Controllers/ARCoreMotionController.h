//
//  ARCoreMotionController.h
//  TFG
//
//  Created by Tovkal on 26/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

@protocol ARCMDelegate <NSObject>

- (void)gotNewValues:(CMAttitude *)attitude;

@end

@interface ARCoreMotionController : NSObject

@property (assign, nonatomic) id<ARCMDelegate> delegate;

- (void)setup;

@end
