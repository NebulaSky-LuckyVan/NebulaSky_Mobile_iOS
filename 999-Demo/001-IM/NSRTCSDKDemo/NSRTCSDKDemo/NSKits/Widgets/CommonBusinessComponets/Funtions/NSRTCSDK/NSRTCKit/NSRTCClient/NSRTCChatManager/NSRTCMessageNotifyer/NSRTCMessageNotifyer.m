//
//  NSRTCMessageNotifyer.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCMessageNotifyer.h"
#import "NSRTCConversation.h"
#import <UserNotifications/UserNotifications.h>

@implementation NSRTCMessageNotifyer

+ (void)registerLocalNotificationWithDelegate:(id<UNUserNotificationCenterDelegate>)delegate{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = delegate;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];
    
}
+ (void)pushLocalNotificationWithMessage:(NSRTCMessage *)message {
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        
        [self iOS10PushMessage:message];
    }
    else {
        [self iOS8PushMessage:message];
    }
}

+ (void)iOS10PushMessage:(NSRTCMessage *)message {
    
    
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:message.from arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:[NSRTCConversation getMessageTypeDescStrWithMessage:message] arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @1;
    content.userInfo = [message yy_modelToJSONObject];
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1 repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"MessageNew" content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"收到消息");
        }else{
            NSLog(@"收到消息,但是发送本地推送失败:%@",[error description]);
        }
    }];
}

+ (void)iOS8PushMessage:(NSRTCMessage *)message {
    
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    // 通知内容
    notification.alertBody = [NSString stringWithFormat:@"%@\n%@", message.from, [NSRTCConversation getMessageTypeDescStrWithMessage:message]];
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = @{@"fklsa":@"safdsadf"};
    notification.userInfo = userDict;
    
    
    // 执行通知注册
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


//获取当前屏幕显示的viewcontroller
+ (UINavigationController *)requestCurrentNavigationVC{
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
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBar = (UITabBarController*)result;
        result  = [self requestNavigationControler:tabBar];
    }
    UINavigationController *navigationCtrl = (UINavigationController*)result;
    
    return navigationCtrl;
}

+ (UINavigationController*)requestNavigationControler:(UIViewController*)viewController{
    UINavigationController *navigatonCtrl = nil;
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarCtrl = (UITabBarController*)viewController;
        UIViewController *vc = tabBarCtrl.selectedViewController;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            navigatonCtrl = (UINavigationController*)vc;
        }else{
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            navigatonCtrl = nav;
        }
    }
    return navigatonCtrl;
}
@end
