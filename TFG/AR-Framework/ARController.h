//
//  ARController.h
//  TFG v2
//
//  Created by Tovkal on 31/08/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARView.h"
#import "ARCoreLocationController.h"
#import "ARCoreMotionController.h"
#import "ARPointOfInterest.h"

@interface ARController : NSObject <ARCLDelegate, ARCMDelegate>

@property (strong, nonatomic) ARView *arView;

@property (strong, nonatomic) NSArray *pointsOfInterest;

- (id) initWithBounds:(CGRect)bounds;
- (void) startAR;
- (void) stopAR;

@end
