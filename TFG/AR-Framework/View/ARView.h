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

@interface ARView : UIView
{
	@public
	mat4f_t cameraTransform;
	
	@public
	vec4f_t *placesOfInterestCoordinates;
}

@property (strong, nonatomic) NSArray *pointsOfInterest;

- (id)initWithFrame:(CGRect)frame;
- (void)start;
- (void)stop;

@end
