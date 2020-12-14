//
//  NSPushNotificationService.h
//  NSPushNotificationService
//
//  Created by VanZhang on 2020/12/1.
//

#import <UIKit/UIKit.h>
 

@interface NSPushNotificationService : NSObject
+ (instancetype)sharedService;

- (NSPushNotificationService*(^)(NSDictionary *launchOptions))requestLaunchPushNotificationMonitor;
- (NSString*)genrationDeviceTokenStringWithDeviceToken:(NSData*)deviceToken;
- (NSPushNotificationService*(^)(NSString*pushGateWay,BOOL IsUat))requestPushGateWay;
- (NSPushNotificationService*(^)(NSString*deviceTokenString,NSData*deviceToken))requestSetDeviceToken;

- (NSPushNotificationService*(^)(NSError *error))requestRemotePushTokenRegisteFailHandler; 
- (NSPushNotificationService*(^)(NSString*bindUserId))requestBindUserIdHandler;

- (NSPushNotificationService*(^)(BOOL enable))requestSetShakeSwitchStatus;
- (BOOL)requestCurrShakeSwitchStatus;


#pragma mark 收到通知后的统一处理

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler ;

- (void)remotePushHandleActionWithIdentifier:(NSString*)identifier userInfo:(NSDictionary*)userInfo responseInfo:(NSDictionary*)responseInfo completionHandler:(void (^)(void))completionHandler;
 

- (void)didReceiveLocalNotification:(UILocalNotification *)notification ;

- (void)localPushHandleActionWithIdentifier:(NSString*)identifier localNotification:(UILocalNotification*)notification responseInfo:(NSDictionary*)responseInfo completionHandler:(void (^)(void))completionHandler;



 
 

#pragma Private
#pragma mark Todo
+ (void)createLocalNoticeWithAlertTitle:(NSString*)alertTitle  alertBody:(NSString*)alertBody userInfo:(NSDictionary*)userInfo ;

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key ;

// cancel All LocalNotifications
+ (void)cancelAllLocalNotifications;




@end
 
