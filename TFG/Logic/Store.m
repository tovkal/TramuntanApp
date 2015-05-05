//
//  Store.m
//  TFG
//
//  Created by tovkal on 5/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import "Store.h"

@interface Store() {
    NSArray *pointsOfInterest;
}

@end

@implementation Store

+ (Store *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)setPointsOfInterest:(NSArray *)array
{
    pointsOfInterest = array;
}

- (NSArray *)getPointsOfInterest
{
    return pointsOfInterest;
}

@end
