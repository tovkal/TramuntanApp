//
//  APBXMLElement.h
//  MountainMapper
//
//  Created by Tovkal on 31/05/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APBXMLElement : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDictionary *attributes;
@property (nonatomic, strong) NSMutableArray *subElements;
@property (nonatomic, weak) APBXMLElement *parent;
@end
