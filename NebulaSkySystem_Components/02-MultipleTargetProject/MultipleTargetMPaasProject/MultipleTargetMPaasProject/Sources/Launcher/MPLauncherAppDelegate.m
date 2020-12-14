//
//  MPLauncherAppDelegate.m
//  MultipleTargetMPaasProject
//
//  Created by VanZhang on 2020/11/20.
//  Copyright © 2020 ORGNIZATION_NAME. All rights reserved.
//

#import "MPLauncherAppDelegate.h"
#import "MPViewController.h"

@interface MPLauncherAppDelegate ()

@property (nonatomic, strong) MPViewController* rootVC;

@end

@implementation MPLauncherAppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        self.rootVC = [[MPViewController alloc] init];
    }
    return self;
}

- (UIViewController *)rootControllerInApplication:(DTMicroApplication *)application
{
    return self.rootVC;
}

- (void)application:(DTMicroApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
}

- (void)application:(DTMicroApplication *)application willResumeWithOptions:(NSDictionary *)launchOptions
{
    
}

@end
