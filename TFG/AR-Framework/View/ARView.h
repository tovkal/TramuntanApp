//
//  ARView.h
//  AR-Framework
//
//  Created by Tovkal on 23/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ARUtils.h"
#import <CoreMotion/CoreMotion.h>

@protocol AttitudeDelegate <NSObject>

- (CMAttitude *)fetchAttitude;

@end

@interface ARView : UIView
{
	@public
	vec4f_t *pointsOfInterestCoordinates;
}

@property (strong, nonatomic) NSArray *pointsOfInterest;

@property (assign, nonatomic) id<AttitudeDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)start;
- (void)stop;

@end
