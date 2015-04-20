//
//  DataParser.h
//  TFG
//
//  Created by Andrés Pizá on 19/4/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject

/**
 *  Array of mountains
 */
@property (strong, nonatomic) NSMutableArray *mountains;

/**
 *  Singleton instantiation
 *
 *  @return shared instance
 */
+ (id)sharedParser;

@end
