//
//  NSRTCMessageNotifyer.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 
#import "NSRTCMessage.h"
#import "NSRTCConversation.h"

@protocol UNUserNotificationCenterDelegate;
@interface NSRTCMessageNotifyer : NSObject




+ (void)registerLocalNotificationWithDelegate:(id<UNUserNotificationCenterDelegate>)delegate;
/**
 接收到消息发送本地推送
 
 @param message 消息
 */
+ (void)pushLocalNotificationWithMessage:(NSRTCMessage *)message;

+ (UINavigationController *)requestCurrentNavigationVC;

@end
 
