//
//  StoreTests.m
//  TramuntanApp
//
//  Created by Andrés Pizá on 18/7/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TramuntanApp-Swift.h"
#import "Store.h"
#import "Mountain.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@interface StoreTests : XCTestCase

@end

@implementation StoreTests

- (void)testStore {
    [[Utils sharedInstance] saveUserSetting:datasourceSettingKey value:@"muntanyes_dev"];

    Store *store = [Store sharedInstance];
    
    Mountain *mountain = [store getPointsOfInterest][0];
    
    XCTAssertEqualObjects(mountain.name, @"Torre Asima");
    XCTAssertEqualObjects(mountain.alt_name, @"NULL");
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:39.601748 longitude:2.673369];
    
    XCTAssertEqual(mountain.location.coordinate.latitude, location.coordinate.latitude);
    XCTAssertEqual(mountain.location.coordinate.longitude, location.coordinate.longitude);
    XCTAssertEqual(mountain.alt_loc.coordinate.latitude, [[CLLocation alloc] init].coordinate.latitude);
    XCTAssertEqual(mountain.alt_loc.coordinate.longitude, [[CLLocation alloc] init].coordinate.longitude);
    XCTAssertEqual(mountain.elevation, 60);
    XCTAssertEqual(mountain.alt_elevation, 0);
    XCTAssertEqualObjects(mountain.postalCode, @[@"7018"]);
    XCTAssertEqualObjects(mountain.wikiUrl, @"http://es.wikipedia.org/wiki/Torre_Asima");
    XCTAssertNotNil(mountain.view);
    XCTAssertEqual(mountain.distance, 0);
}
@end
