//
//  XMLParser.h
//  MountainMapper
//
//  Created by Tovkal on 28/06/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLElement.h"

@interface XMLParser : NSObject <NSXMLParserDelegate>

- (XMLElement *)parseXML:(NSString *)file;

@end
