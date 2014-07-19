//
//  APBXMLElement.m
//  MountainMapper
//
//  Created by Tovkal on 31/05/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "APBXMLElement.h"

@implementation APBXMLElement

- (NSMutableArray *) subElements{
    if (_subElements == nil){
        _subElements = [[NSMutableArray alloc] init];
    }
    return _subElements; }

@end
