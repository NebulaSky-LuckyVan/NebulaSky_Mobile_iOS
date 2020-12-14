//
//  AppDelegate.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//

#import "AppDelegate.h"
#import "NSPushNotificationService.h"
#import "YNETTabBarController.h"

#import "NSLoginPageController.h"


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDImageCache.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (strong, nonatomic) NSLoginPageController *loginViewController;


@end


@implementation AppDelegate
- (NSLoginPageController *)loginViewController{
    if (!_loginViewController) {
        _loginViewController = [[NSLoginPageController alloc]init];
    }
    return _loginViewController;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
#pragma mark   SetupKeyWindow
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [NSPushNotificationService sharedService].requestLaunchPushNotificationMonitor(launchOptions);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kDidLogin]) {
        [self.window setRootViewController:[[YNETTabBarController alloc] init]];
        [self.window makeKeyAndVisible];
    }else{
        [self.window setRootViewController:self.loginViewController];
        [self.window makeKeyAndVisible];
    }
    [self registerRTCMessageNotifyer];
    [self resetRootPageMonitor];
    /*cache */
    [[NSURLCache sharedURLCache]setMemoryCapacity:(8*1024*1024)];
    [[NSURLCache sharedURLCache]setDiskCapacity:(50*1024*1024)];
//  [SDImageCache sharedImageCache].config.maxMemoryCost = 8*1024*1024;
    /*keyboard*/
    //Make the operationSetting useable on each page of application Interfaces
    [IQKeyboardManager sharedManager].enable = YES;
    //If withdraw the keyboard when touch resign outside the first responder
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //设置按钮
    //    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    // 最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘。
    return YES;
}
- (void)resetRootPageMonitor{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"loginSuccess" object:nil]subscribeNext:^(NSNotification *notice) {
        [self.window setRootViewController:[[YNETTabBarController alloc] init]];
        [self.window makeKeyAndVisible];
    }];
}
#pragma mark - Private
//后台情况下保持socket通信
- (void)applicationDidEnterBackground:(UIApplication *)application{
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}
- (void)registerRTCMessageNotifyer{
    NSString *noticeName = @"P2PVideoCallMessage";
    id noticeObject = nil;
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:noticeName object:noticeObject]subscribeNext:^(NSNotification *notice) {
        NSDictionary *dataDict = notice.object; ;
        UIViewController *vc = [self requestCurrentVC];
        NSRTCAVLivePhoneCallViewController *phoneCall = [NSRTCAVLivePhoneCallViewController receivePhoneCall:NSRTCAVLivePhoneCallVideoCall phoneCallInfo:dataDict];
        [vc presentViewController:phoneCall animated:YES completion:nil];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"P2PAudioCallMessage" object:noticeObject]subscribeNext:^(NSNotification *notice) {
        NSDictionary *dataDict = notice.object; ;
        UIViewController *vc = [self requestCurrentVC];
        NSRTCAVLivePhoneCallViewController *phoneCall = [NSRTCAVLivePhoneCallViewController receivePhoneCall:NSRTCAVLivePhoneCallAudioCall phoneCallInfo:dataDict];
        [vc presentViewController:phoneCall animated:YES completion:nil];
    }];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)requestCurrentVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    return result;
}

@end
