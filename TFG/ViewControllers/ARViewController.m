//
//  AugmentedRealityViewController.m
//  TFG
//
//  Created by Tovkal on 19/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARViewController.h"
#import "TargetShape.h"
#import "APBXMLElement.h"
#import "APBXMLParser.h"
#import "Mountain.h"
#import "ARController.h"

@interface ARViewController ()
@property (strong, nonatomic) ARController *ar;

//TODO temporary
@property (weak, nonatomic) CAShapeLayer *targetLayer;

//Array for XML Data
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation ARViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.ar = [[ARController alloc] initWithFrame:self.view.frame];
	self.view = self.ar.arView;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self drawTarget];
	
	[self.ar startAR];
	
	[self parseXML];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self.ar startAR];
}

#pragma mark - ARDelegate

- (NSMutableArray *)poiData
{
	NSMutableArray *data = [[NSMutableArray alloc] init];
	
	return data;
}

#pragma mark - Target view TEMPORARY
//TODO Find better location for this
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self drawTarget];
}

- (void)drawTarget
{
	[self removeTarget];
	
	CGRect bounds = self.view.bounds;
    CGPoint center = CGPointMake((bounds.size.width/(2+bounds.origin.x)), (bounds.size.height/(2+bounds.origin.y)));
    CAShapeLayer *targetLayer = [TargetShape createTargetView:center];
    
    self.targetLayer = targetLayer;
    
    [self.view.layer addSublayer:targetLayer];
}

- (void)removeTarget
{
	if (self.targetLayer != nil) {
		[self.targetLayer removeFromSuperlayer];
	}
}

- (void)doNothing:(ARView *)arView{}

#pragma mark - XML Data

- (void)parseXML
{
	APBXMLParser *parser  = [[APBXMLParser alloc] init];
	APBXMLElement *rootElement = [parser parseXML:@"muntanyes_dev"];
	
	[self toArray:rootElement];
}

- (void)toArray:(APBXMLElement *)rootElement
{
	APBXMLElement *database = rootElement.subElements[1];
	
	for (APBXMLElement *mountainElement in database.subElements) {
		
		NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
		
		NSArray *attributeArray = @[@"name", @"alt_name", @"lat", @"lon", @"alt_lat", @"alt_lon", @"ele", @"alt_ele", @"postal_code"];
		
		for (APBXMLElement *attribute in mountainElement.subElements) {
			NSArray *values = [attribute.attributes allValues];
			NSInteger item = [attributeArray indexOfObject:values[0]];
			
			switch (item) {
				case 0: //name
				case 1: //alt_name
				case 2: //lat
				case 3: //lon
				case 4: //alt_lat
				case 5: //alt_lon
				case 6: //ele
				case 7: //alt:ele
					[dictionary setObject:attribute.text forKey:attributeArray[item]];
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
		
		[self.data addObject:dictionary];
		
	}
}

- (NSMutableArray *)data
{
	if (_data == nil) {
		_data = [[NSMutableArray alloc] init];
	}
	
	return _data;
}

@end
