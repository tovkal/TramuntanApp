//
//  APBSettingsViewController.m
//  ARTest2
//
//  Created by Tovkal on 10/07/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "SettingsViewController.h"
#import "MyARViewController.h"

@interface SettingsViewController ()
@property BOOL locationDebug;
@end

@implementation SettingsViewController

- (void)loadView
{
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
        MyARViewController *vc = (MyARViewController *) [tabBarController.viewControllers objectAtIndex:0]; //Segon de sa llista de sa tab bar
    
        vc.locationDebug = self.locationDebug;
    }
}

@end
