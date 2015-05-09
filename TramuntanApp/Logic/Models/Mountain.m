//
//  Mountain.m
//  TramuntanApp
//
//  Created by Tovkal on 31/08/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "Mountain.h"

@implementation Mountain

- (instancetype) initWithName:(NSString *)name alternativeName:(NSString *)alt_name lat:(double)lat lon:(double)lon alternativeLat:(double)alt_lat alternativeLon:(double)alt_lon elevation:(double)ele alternativeElevation:(double)alt_ele postalCode:(NSString *)postalCode wikiUrl:(NSString *)wikiUrl withView:(UIView *)view
{
    self.name = name;
    self.alt_name = alt_name;
    
    self.location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    self.alt_loc = [[CLLocation alloc] initWithLatitude:alt_lat longitude:alt_lon];
    
    self.elevation = ele;
    self.alt_elevation = alt_ele;
    
    self.postalCode = postalCode;
    
    self.wikiUrl = wikiUrl;
    
    self.view = view;
    
    return [self init];
}

@end
