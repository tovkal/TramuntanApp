//
//  Store.h
//  TramuntanApp
//
//  Created by tovkal on 5/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

/**
 *  Shared instance
 *
 *  @return Singleton instance
 */
+ (Store *)sharedInstance;

- (void)setPointsOfInterest:(NSArray *)array;
- (NSArray *)getPointsOfInterest;


@end
