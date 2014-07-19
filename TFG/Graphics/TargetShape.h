//
//  TargetView.h
//  Testing
//
//  Created by Tovkal on 06/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface TargetShape : CAShapeLayer

+ (CAShapeLayer *) createTargetView:(CGPoint)atLocation;

@end
