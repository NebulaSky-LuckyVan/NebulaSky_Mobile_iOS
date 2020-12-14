//
//  MBPLauncherMicroApp1AppDelegate.m
//  DobulePlatformApplications
//
//  Created by VanZhang on 2020/11/19.
//

#import "MBPLauncherMicroApp1AppDelegate.h"

#import "MBPTabBarController.h"


@interface MBPLauncherMicroApp1AppDelegate ()<NSMicroApplicationDelegate>

@property (nonatomic, strong) MBPTabBarController* rootVC;

@end

@implementation MBPLauncherMicroApp1AppDelegate

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
       UIViewController* tab2ViewController = [[NSViewController alloc] init];
       
       
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
       
       self.rootVC = [[MBPTabBarController alloc] init];
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
       vc = (NSViewController *)[[NSViewController alloc] init];
   }
   return vc;
}


- (UIViewController *)rootControllerInApplication:(NSMicroApplication *)application
{
   return self.rootVC;
}

- (void)applicationDidFinishLaunching:(NSMicroApplication *)application
{
   NSLog(@"%s",__func__);
}

- (void)application:(NSMicroApplication *)application willResumeWithOptions:(NSDictionary *)launchOptions
{
   NSLog(@"%s",__func__);
}
@end
