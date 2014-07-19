//
//  Triangle.m
//  Testing
//
//  Created by Tovkal on 13/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:CGPointMake(15, 2)];
	[path addLineToPoint:CGPointMake(28, 30)];
	[path addLineToPoint:CGPointMake(2, 30)];
	[path closePath];
	[[UIColor greenColor] setFill];
	[[UIColor redColor] setStroke];
	[path fill];
	[path stroke];
}

- (void)setup
{
	self.backgroundColor = nil;
	self.opaque = NO;
	self.contentMode = UIViewContentModeRedraw;
}

//Gets called when created from Storyboard
- (void)awakeFromNib
{
	//If created in Storyboard
	[self setup];
}

//Gets called when created from code (alloc init)
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point
{
	return [self initWithFrame:CGRectMake(point.x, point.y, 30, 30)];
}

@end
