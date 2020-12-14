//
//  NSPushNotificationService.m
//  NSPushNotificationService
//
//  Created by VanZhang on 2020/12/1.
//

#import "NSPushNotificationService.h"

#import <MPPushSDK/PushService.h>
#import <UserNotifications/UserNotifications.h>

#import <CoreLocation/CoreLocation.h>
#import <UserNotificationsUI/UNNotificationContentExtension.h>
#import <AVFoundation/AVFoundation.h>
@implementation NSPushNotificationService
-(NSPushNotificationService*(^)(NSDictionary * ))requestLaunchPushNotificationMonitor{
    return ^(NSDictionary *launchOptions){
        //Local && //Remote
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = [UIApplication sharedApplication].delegate;
            void (^CallRegisterHandler)(UNAuthorizationOptions) = ^(UNAuthorizationOptions options){
                [center requestAuthorizationWithOptions:options
                   completionHandler:^(BOOL granted, NSError * _Nullable error) {
                      // Enable or disable features based on authorization.
                    if (!error) {
                        NSLog(@"remote push regist success");
                    }else{
                        NSLog(@"remote push regist fail with err:%@",error);
                    }
                }];

            };
            UNAuthorizationOptions options  ;
            if (@available(iOS 13.0, *)) {
                options =(UNAuthorizationOptionAlert +
                          UNAuthorizationOptionSound +
                          UNAuthorizationOptionBadge +
                          UNAuthorizationOptionCarPlay+
                          UNAuthorizationOptionCriticalAlert+
                          UNAuthorizationOptionProvidesAppNotificationSettings) ;
            } else if (@available(iOS 12.0, *)) {
                options = (UNAuthorizationOptionAlert +
                               UNAuthorizationOptionSound +
                               UNAuthorizationOptionBadge +
                               UNAuthorizationOptionCarPlay+
                               UNAuthorizationOptionCriticalAlert+
                               UNAuthorizationOptionProvidesAppNotificationSettings);
            }else{
                options  = (UNAuthorizationOptionAlert +
                            UNAuthorizationOptionSound +
                            UNAuthorizationOptionBadge +
                            UNAuthorizationOptionCarPlay);
            }
            CallRegisterHandler(options);
        }else if (@available(iOS 8.0, *)){
            NSMutableSet <UIUserNotificationCategory *>*categoriees = [NSMutableSet set];
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:categoriees];
            //local
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            //remote
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }else{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
            #pragma clang diagnostic pop
        }
        return self;
    };
}
- (NSPushNotificationService*(^)(NSString*,BOOL))requestPushGateWay{
    return ^(NSString*pushGateWay,BOOL IsUat){
        
        //        if (PedestalEnv==0) {
        //            isUAT = NO;
        //        }else{
        //            isUAT = YES;
        //        }
        if (!pushGateWay) {
            pushGateWay = !IsUat?@"cn-hangzhou-mps-link.cloud.alipay.com":@"mpaas-mps-test.gdrcu.com";
        }
        NSLog(@"pushGateWay:%@",pushGateWay);
        [PushService setPushGateway:pushGateWay];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"finishAPNSRegisterAndSyncDeviceId" object:nil];
        return self;
    };
}
- (NSPushNotificationService*(^)(NSString*,NSData*))requestSetDeviceToken{
    return ^(NSString*deviceTokenString,NSData*deviceToken){
        [[PushService sharedService]setDeviceToken:deviceToken];
        return self;
    };
}
- (NSPushNotificationService*(^)(NSError *error ))requestRemotePushTokenRegisteFailHandler{
    return ^(NSError *error){
        NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
        return self;
    };
}

-(NSString*)genrationDeviceTokenStringWithDeviceToken:(NSData*)deviceToken{
/// Required - 注册 DeviceToken
    NSString *token = @"" ;
    if (@available(iOS 13.0, *)) {
        token = [self requestHexStringTransformFromData:deviceToken];
        NSLog(@"iOS 13之后的deviceToken的获取方式");
      } else {
          token = [[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@"<>"]];
          token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
          NSLog(@"iOS 13之前的deviceToken的获取方式");
      }
    if (deviceToken != nil&&token.length>0) {
        NSLog(@"deviceToken:%@",token);
    }
    return token;
}
- (NSPushNotificationService*(^)(NSString*))requestBindUserIdHandler{
    return ^(NSString*bindUserId){
        [[PushService sharedService]pushBindWithUserId:bindUserId completion:^(NSException *error) {
            if (!error) {
                 NSLog(@"绑定用户成功,用户id:%@",bindUserId);
            }else{
                NSLog(@"绑定用户失败reason:%@",error.reason);
            }
        }];
        return self;
    };
}
-(NSPushNotificationService*(^)(BOOL ))requestSetShakeSwitchStatus{
    return ^(BOOL enable){
        [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"IsOpenShake"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return self;
    };
}

- (BOOL)requestCurrShakeSwitchStatus{
    return  [[NSUserDefaults standardUserDefaults]boolForKey:@"IsOpenShake"];
}
- (NSString *)requestHexStringTransformFromData:(NSData *)data {
    NSUInteger len = [data length];
    char *chars = (char *)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < len; i ++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}


#pragma mark todo Notes calculate！！！
-(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    //    [UIApplication sharedApplication]
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self remotePushHandleWithUserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
 

- (void)didReceiveLocalNotification:(UILocalNotification *)notification{
    [self localPushHandleWithUserInfo:notification.userInfo];
    //判断是否开启震动
    BOOL isOpen = [self requestCurrShakeSwitchStatus];
    !isOpen?:AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)remotePushHandleActionWithIdentifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo responseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler{
    [self logDic:responseInfo];
    [self remotePushHandleWithUserInfo:userInfo];
    
    //判断是否开启震动
    BOOL isOpen = [self requestCurrShakeSwitchStatus];
    !isOpen?:AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)localPushHandleActionWithIdentifier:(NSString *)identifier localNotification:(UILocalNotification *)notification responseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler{
    [self logDic:responseInfo];
    [self localPushHandleWithUserInfo:notification.userInfo];
}
#pragma mark 收到通知 点击屏幕上的通知点击 的处理
-(void)remotePushHandleWithUserInfo:(NSDictionary*)userInfo notificationResponse:(UNNotificationResponse *)response  API_AVAILABLE(ios(10.0)){
    [self remotePushCommonHandlerWithResponse:response notification:nil];
}
#pragma mark 收到通知后的统一处理
-(void)remotePushHandleWithUserInfo:(NSDictionary*)userInfo notificcation:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    [self remotePushCommonHandlerWithResponse:nil notification:notification];
}

#pragma Private
- (void)remotePushCommonHandlerWithResponse:(UNNotificationResponse*)response notification:(UNNotification*)notificationInfo API_AVAILABLE(ios(10.0)){
  
    if(@available(iOS 10.0, *)){
        UNNotification *notification = nil;
        if(response){
            notification = response.notification;
        }else{
            notification = notificationInfo;
        }
        
        if(notification){
               UNNotificationRequest *request = notification.request; // 收到推送的请求
               NSString *identifier = request.identifier;
               NSDate *date = notification.date;
            
            
               UNNotificationContent *content = request.content; // 收到推送的消息内容
               NSString *title = content.title;  // 推送消息的标题
               NSString *subtitle = content.subtitle;  // 推送消息的副标题
               NSString *body = content.body;    // 推送消息体
               NSDictionary * userInfo = content.userInfo;
            
               UNNotificationSound *sound = content.sound;  // 推送消息的声音
               NSNumber *badge = content.badge;  // 推送消息的角标
               UNNotificationTrigger *trigger = request.trigger;
             
               
               if([trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//点击
                   [self remotePushHandleWithUserInfo:userInfo];
               }else{//无点击事件 而出发的回调--> 为本地通知
                   [self localPushHandleWithUserInfo:userInfo];
               }
            NSLog(@"iOS10 收到本地通知:{\ntitle:%@,\nsubtitle:%@,\nbody:%@,\nuserInfo：%@\nbadge：%@,\nsound：%@,\nidentifier:%@,\ndate:%@\n}",
                  title,subtitle,body,userInfo,badge,sound,identifier,date);
        }
    }
}
//统一处理推送信息
//local
- (void)localPushHandleWithUserInfo:(NSDictionary*)userInfo{
    if (userInfo.allValues.count>0&&userInfo.allKeys) {
        NSDictionary *apsInfo =  userInfo[@"aps"];
        NSInteger badgeNum =    [apsInfo[@"badge"] integerValue];
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:badgeNum];
        NSArray *keys = [userInfo allKeys];
        NSLog(@"userInfo_keys:%@",keys);
    }
    NSLog(@"收到本地通知:%@", [self logDic:userInfo]);
}
//统一处理推送信息
//remote
- (void)remotePushHandleWithUserInfo:(NSDictionary*)userInfo{
           //当APP在前台运行时，不做处理
    
    //            NSDictionary *remoteNotification = [tfdic objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
       switch ([UIApplication sharedApplication].applicationState) {
           case UIApplicationStateActive:{
//               NSLog(@"当APP在前台运行时,不做处理");
               if (@available(iOS 10.0,*)) {
                   NSDictionary *aps = userInfo[@"aps"];
                   NSDictionary *alert = aps[@"alert"];
                   NSString *title = alert[@"title"];
                   NSString *body = alert[@"body"];
                   NSString *t = @"console_1605148672068";
                   
                   UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
                   content.title = title;
                   content.subtitle = @"";
                   content.body = body;
                   content.userInfo = alert;
                   UNNotificationSound *sound = [UNNotificationSound defaultSound];
                   content.sound = sound;
                   content.badge = @(1);
                   // 多少秒后发送,可以将固定的日期转化为时间
                   NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:2] timeIntervalSinceNow];
                   
                   // repeats，是否重复，如果重复的话时间必须大于60s，要不会报错
                   UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];

                   UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:t content:content trigger:trigger];
                   [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                       if (!error) {
                           NSLog(@"远程推送前台处理成功");
                       }else{
                           NSLog(@"远程推送前台处理失败:%@",error);
                       }
                   }];
               }else{
                   UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                   localNotification.userInfo = userInfo;
                   localNotification.soundName = UILocalNotificationDefaultSoundName;
                   localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                   localNotification.fireDate = [NSDate date];
                   [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
               }
           }break;
           case UIApplicationStateInactive:{
               //当APP在后台运行时，当有通知栏消息时，点击它，就会执行下面的方法跳转到相应的页面
               NSLog(@"当APP在后台运行时,当有通知栏消息时,点击它");
               
           }break;
           case UIApplicationStateBackground:{
               //当APP在后台运行时，当有通知栏消息时，点击它，就会执行下面的方法跳转到相应的页面
               NSLog(@"当APP在后台运行时,当有通知栏消息时,用户未触发");
           }break;
           default:
               break;
       }
    if (userInfo.allValues.count>0&&userInfo.allKeys) {
        NSDictionary *apsInfo =  userInfo[@"aps"];
        NSInteger badgeNum =    [apsInfo[@"badge"] integerValue];
        !badgeNum?:[[UIApplication sharedApplication]setApplicationIconBadgeNumber:badgeNum];
        NSArray *keys = [userInfo allKeys];
        NSLog(@"userInfo_keys:%@",keys);
        
    }
    NSLog(@"收到远程通知:%@", [self logDic:userInfo]);
}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListWithData:tempData
                                              options:NSPropertyListImmutable
                                               format:nil
                                                error:nil];
    
    NSLog(@"通知处理后的结果====%@",str);
    return str;
}
#pragma Private
#pragma mark Todo
+ (void)createLocalNoticeWithAlertTitle:(NSString*)alertTitle  alertBody:(NSString*)alertBody userInfo:(NSDictionary*)userInfo {
    
    UILocalNotification *localNoticeInfo = [[UILocalNotification alloc]init];
    localNoticeInfo.alertTitle = alertTitle;
    localNoticeInfo.alertBody = alertBody;
    localNoticeInfo.applicationIconBadgeNumber = 1;
    localNoticeInfo.userInfo = userInfo;
    localNoticeInfo.soundName = UILocalNotificationDefaultSoundName;
    
    localNoticeInfo.fireDate = [NSDate date];
    localNoticeInfo.timeZone = [NSTimeZone systemTimeZone];
    localNoticeInfo.repeatInterval = NSCalendarUnitMinute;
    localNoticeInfo.repeatCalendar = [NSCalendar currentCalendar];
    
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(0, 0);
//    CLLocationDistance radius  = 0;
//    NSString* regionIdentifier  = @"";
//    CLRegion *region = [[CLRegion alloc]initCircularRegionWithCenter:center radius:radius identifier:regionIdentifier];
//    localNoticeInfo.region = region;
//
//
//    localNoticeInfo.category  = @"";
//    localNoticeInfo.alertLaunchImage  = @"";
//    localNoticeInfo.alertAction  = @"";
    [[UIApplication sharedApplication]scheduleLocalNotification:localNoticeInfo];
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key{
  // 获取所有本地通知数组
  NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
  for (UILocalNotification *notification in localNotifications) {
      NSDictionary *userInfo = notification.userInfo;
      NSString *info = userInfo[key];
      !(userInfo&&!info)?:[[UIApplication sharedApplication] cancelLocalNotification:notification];
  }
}

// cancel All LocalNotifications
+ (void)cancelAllLocalNotifications{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}


















+ (instancetype)sharedService{
    return [NSPushNotificationService sharedInstance];
}
//===============SingleTon====================//
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopy{
    return _instance;
}
- (id)copy{
    return _instance;
}
+ (instancetype)sharedInstance{
    return [[self alloc]init];
}
//===================================//
@end
