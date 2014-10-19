//
//  TargetView.m
//  Testing
//
//  Created by Tovkal on 06/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "TargetShape.h"

@implementation TargetShape

// TODO dashed rectangle. Use center to position. Diferent quan està apaisat? O sempre igual? UIBezierpath a una UIView

+ (CAShapeLayer *) createTargetView:(CGPoint)atLocation
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [[self makeCircleAtLocation:atLocation radius:15.0] CGPath];
    shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 2;
    
    return shapeLayer;
}


// Add CAShapeLayer to our view

+ (UIBezierPath *)makeCircleAtLocation:(CGPoint)location radius:(CGFloat)radius
{
    CGPoint circleCenter = location;
    CGFloat circleRadius = radius;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:circleCenter
                    radius:circleRadius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    return path;
}

@end
