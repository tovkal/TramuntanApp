//
//  APBXMLParser.h
//  MountainMapper
//
//  Created by Tovkal on 28/06/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APBXMLElement.h"

@interface APBXMLParser : NSObject <NSXMLParserDelegate>

- (APBXMLElement *)parseXML:(NSString *)file;

@end
