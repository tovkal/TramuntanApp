//
//  APBSettingsViewController.m
//  TFG
//
//  Created by Tovkal on 10/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "SettingsViewController.h"
#import "ARViewController.h"

@interface SettingsViewController ()

@property BOOL locationDebug;
@property BOOL headingDebug;
@property BOOL altitudeDebug;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.locationDebug = NO;
    
    self.tabBarController.delegate = self;
}

- (IBAction)didChange:(UISwitch *)sender
{
	switch (sender.tag) {
		case 1: //Location
			self.locationDebug = sender.isOn ? YES : NO;
			break;
		case 2: //Heading
			self.headingDebug = sender.isOn ? YES : NO;
			break;
		case 3: //Altitude
			self.altitudeDebug = sender.isOn ? YES : NO;
			break;
		default:
			break;
	}
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    if (viewController.tabBarItem.tag == 1) {
        ARViewController *vc = (ARViewController *) [tabBarController.viewControllers objectAtIndex:1]; //Segon de sa llista de sa tab bar
    
        vc.locationDebug = self.locationDebug;
		vc.headingDebug = self.headingDebug;
		vc.altitudeDebug = self.altitudeDebug;
    }
}

@end
