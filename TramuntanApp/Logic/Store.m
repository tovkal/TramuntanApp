//
//  Store.m
//  TramuntanApp
//
//  Created by tovkal on 5/5/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import "Store.h"
#import "DataParser.h"
#import "TramuntanApp-Swift.h"
#import "Mountain.h"

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

- (id)init {
    if (self = [super init]) {
        [self initPointOfInterests];
    }
    
    return self;
}

- (void)setPointsOfInterest:(NSArray *)array
{
    pointsOfInterest = array;
}

- (NSArray *)getPointsOfInterest
{
    return pointsOfInterest;
}

- (void)initPointOfInterests
{
    NSMutableArray *mountainArray = [[NSMutableArray alloc] init];
    DataParser *sharedParser = [DataParser sharedParser];
    for (NSDictionary *mountain in sharedParser.mountains) {
        
        MountainUIImageView *mountainView = [[MountainUIImageView alloc] init];
        mountainView.tag = (NSInteger) ([mountainArray count] + 1);
        
        if ([mountain valueForKey:@"name"] == nil || [mountain valueForKey:@"lat"] == nil || [mountain valueForKey:@"lon"] == nil || [mountain valueForKey:@"ele"] == nil || [[mountain valueForKey:@"name"] isEqual: @"NULL"] || [[mountain valueForKey:@"lat"] isEqual: @"NULL"] || [[mountain valueForKey:@"lon"] isEqual: @"NULL"] || [[mountain valueForKey:@"ele"] isEqual: @"NULL"]) {
            continue;
        }
        
        Mountain *m = [[Mountain alloc] initWithName:[mountain valueForKey:@"name"]
                                     alternativeName:[mountain valueForKey:@"alt_name"]
                                                 lat:[[mountain valueForKey:@"lat"] doubleValue]
                                                 lon:[[mountain valueForKey:@"lon"] doubleValue]
                                      alternativeLat:[[mountain valueForKey:@"alt_lat"] doubleValue]
                                      alternativeLon:[[mountain valueForKey:@"alt_lon"] doubleValue]
                                           elevation:[[mountain valueForKey:@"ele"] doubleValue]
                                alternativeElevation:[[mountain valueForKey:@"alt_ele"] doubleValue]
                                          postalCode:[mountain valueForKey:@"postal_code"]
                                             wikiUrl:[mountain valueForKey:@"wikipedia"]
                                            withView:mountainView];
        
        [mountainArray addObject:m];
    }
    
    self.pointsOfInterest = mountainArray;
}


@end
