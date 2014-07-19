//
//  APBSettingsViewController.m
//  ARTest2
//
//  Created by Tovkal on 10/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "APBSettingsViewController.h"
#import "APBViewController.h"

@interface APBSettingsViewController ()
@property BOOL locationDebug;
@end

@implementation APBSettingsViewController

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
        APBViewController *vc = (APBViewController *) [tabBarController.viewControllers objectAtIndex:0]; //Segon de sa llista de sa tab bar
    
        vc.locationDebug = self.locationDebug;
    }
}

@end
