//
//  DataParser.m
//  TFG
//
//  Created by Andrés Pizá on 19/4/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import "DataParser.h"
#import "XMLParser.h"
#import "TFG-Swift.h"
#import "Constants.h"

@interface DataParser()

@property (strong, nonatomic) NSString *lastKnownDatasource;

@end

@implementation DataParser

#pragma mark Singleton Methods

+ (id)sharedParser {
    static DataParser *sharedParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParser = [[self alloc] init];
    });
    return sharedParser;
}

- (id)init {
    if (self = [super init]) {
        [self parseData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(defaultsChanged:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
        
        self.lastKnownDatasource = [Utils getUserSetting:datasourceSettingKey];
    }
    return self;
}

#pragma mark Lazy inits

- (NSMutableArray *)mountains
{
    if (_mountains == nil) {
        _mountains = [[NSMutableArray alloc] init];
    }
    
    return _mountains;
}

#pragma mark Parser methods

- (void)parseData {
    XMLParser *parser  = [[XMLParser alloc] init];
    XMLElement *rootElement = [parser parseXML:self.lastKnownDatasource];
    XMLElement *mountainList = rootElement.subElements[1];
    
    for (XMLElement *mountain in mountainList.subElements) {
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSArray *attributeArray = @[@"name", @"alt_name", @"lat", @"lon", @"alt_lat", @"alt_lon", @"ele", @"alt_ele", @"postal_code"];
        
        for (XMLElement *attribute in mountain.subElements) {
            NSArray *values = [attribute.attributes allValues];
            NSUInteger item = [attributeArray indexOfObject:values[0]];
            
            switch (item) {
                case 0: //name
                case 1: //alt_name
                case 2: //lat
                case 3: //lon
                case 4: //alt_lat
                case 5: //alt_lon
                case 6: //ele
                case 7: //alt_ele
                    if (attribute.text != nil) {
                        [dictionary setObject:attribute.text forKey:attributeArray[item]];
                    }
                    break;
                case 8: //postal code
                    [dictionary setObject:[attribute.text componentsSeparatedByString:@", "] forKey:attributeArray[item]];
                    break;
                case NSIntegerMax: break;
                default:
                    NSLog(@"Error converting XML Data to Array, attribute key not found: %@", attribute.attributes);
                    break;
            }
        }
        
        [self.mountains addObject:dictionary];
    }
}

#pragma mark KVO
- (void)defaultsChanged:(NSNotification *)notification {
    if (![self.lastKnownDatasource isEqualToString:(NSString *)[Utils getUserSetting:datasourceSettingKey]]) {
        exit(0);
    }
}

@end
