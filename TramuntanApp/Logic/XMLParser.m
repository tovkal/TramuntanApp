//
//  XMLParser.m
//  MountainMapper
//
//  Created by Tovkal on 28/06/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "XMLParser.h"

@interface XMLParser()

@property (nonatomic, strong) XMLElement *rootElement;
@property (nonatomic, strong) XMLElement *currentElementPointer;
@property (nonatomic, strong) NSXMLParser *xmlParser;

@end
@implementation XMLParser

- (XMLElement *)parseXML:(NSString *)file {
    NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:file ofType:@"xml"];
    
    NSData *xml = [[NSData alloc] initWithContentsOfFile:xmlFilePath];
    
    self.xmlParser = [[NSXMLParser alloc] initWithData:xml];
    self.xmlParser.delegate = self;
    
    if ([self.xmlParser parse]) {
        NSLog(@"The XML is parsed");
    } else {
        NSLog(@"Failed to parse XML");
    }
    
    return self.rootElement;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.rootElement = nil;
    self.currentElementPointer = nil;
}

- (void)    parser:(NSXMLParser *)parser
   didStartElement:(NSString *)elementName
      namespaceURI:(NSString *)namespaceURI
     qualifiedName:(NSString *)qName
        attributes:(NSDictionary *)attributeDict {
    
    if (self.rootElement == nil){
        /* We don't have a root element. Create it and point to it */
        self.rootElement = [[XMLElement alloc] init];
        self.currentElementPointer = self.rootElement;
    }else{
        /* Already have root. Create new element and add it as one of
         the subelements of the current element */
        XMLElement *newElement = [[XMLElement alloc] init];
        newElement.parent = self.currentElementPointer;
        [self.currentElementPointer.subElements addObject:newElement];
        self.currentElementPointer = newElement;
    }
    self.currentElementPointer.name = elementName;
    self.currentElementPointer.attributes = attributeDict;
    
}

- (void)    parser:(NSXMLParser *)parser
   foundCharacters:(NSString *)string {
    if ([self.currentElementPointer.text length] > 0) {
        self.currentElementPointer.text = [self.currentElementPointer.text stringByAppendingString:string];
    } else {
        self.currentElementPointer.text = string;
    }
}

- (void)    parser:(NSXMLParser *)parser
     didEndElement:(NSString *)elementName
      namespaceURI:(NSString *)namespaceURI
     qualifiedName:(NSString *)qName {
    self.currentElementPointer = self.currentElementPointer.parent;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.currentElementPointer = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@", parseError);
}

@end
