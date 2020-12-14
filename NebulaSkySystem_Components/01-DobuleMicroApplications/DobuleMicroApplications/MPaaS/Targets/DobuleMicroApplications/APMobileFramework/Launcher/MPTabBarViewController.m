//
//  MPTabBarViewController.m
//  DobuleMicroApplications
//
//  Created by VanZhang on 2020/11/17.
//  Copyright © 2020 ORGNIZATION_NAME. All rights reserved.
//

#import "MPTabBarViewController.h"

@interface MPTabBarViewController ()

@end

@implementation MPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.title = viewController.title;
    self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItems = viewController.navigationItem.leftBarButtonItems;
    self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems;
}


@end
