//
//  App1LauncherMicroAppDelegate.m
//  DobuleMicroApplications
//
//  Created by VanZhang on 2020/11/17.
//  Copyright © 2020 Alibaba. All rights reserved.
//

#import "App1LauncherMicroAppDelegate.h"
 
#import "MPTabBarViewController.h"

@interface App1LauncherMicroAppDelegate ()<DTMicroApplicationDelegate>

@property (nonatomic, strong) MPTabBarViewController* rootVC;

@end

@implementation App1LauncherMicroAppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *baseImgs = [NSArray arrayWithObjects:
                             @"TabBar_HomeBar",
                             @"TabBar_Friends", nil];
        NSArray *selectImgs = [NSArray arrayWithObjects:
                               @"TabBar_HomeBar_Sel",
                               @"TabBar_Friends_Sel", nil];
        
        UIViewController* tab1ViewController = (UIViewController *) [self createLoggingViewController:@"DemoViewController"];
        UIViewController* tab2ViewController = [[DTViewController alloc] init];
        
        
        NSArray *navArray = @[tab1ViewController,tab2ViewController];
        NSArray *titles = @[@"Tab1", @"Tab2"];
        for (int i = 0; i < [navArray count]; i ++)
        {
            UIImage *bImg = [UIImage imageNamed:baseImgs[i]];
            UIImage *selectImg = [UIImage imageNamed:selectImgs[i]];
            
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titles[i] image:bImg selectedImage:selectImg];
            item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.tag = i;
            [(UIViewController *)navArray[i] setTabBarItem:item];
            ((UIViewController *)navArray[i]).title = titles[i];
        }
        
        self.rootVC = [[MPTabBarViewController alloc] init];
        self.rootVC.viewControllers = navArray;
        self.rootVC.selectedIndex = 0;
        [self.rootVC.delegate tabBarController:self.rootVC didSelectViewController:tab1ViewController];
    }
    return self;
}

- (id)createLoggingViewController:(NSString *)className
{
    id vc;
    Class cl = NSClassFromString(className);
    if (cl != Nil) {
        vc = [[cl alloc]init];
    }
    else {
        vc = (DTViewController *)[[DTViewController alloc] init];
    }
    return vc;
}


- (UIViewController *)rootControllerInApplication:(DTMicroApplication *)application
{
    return self.rootVC;
}

- (void)applicationDidFinishLaunching:(DTMicroApplication *)application
{
    NSLog(@"%s",__func__);
}

- (void)application:(DTMicroApplication *)application willResumeWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s",__func__);
}
@end
