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
    self.locationDebug = sender.isOn ? YES : NO;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    if (viewController.tabBarItem.tag == 1) {
        ARViewController *vc = (ARViewController *) [tabBarController.viewControllers objectAtIndex:1]; //Segon de sa llista de sa tab bar
    
        vc.locationDebug = self.locationDebug;
    }
}

@end
