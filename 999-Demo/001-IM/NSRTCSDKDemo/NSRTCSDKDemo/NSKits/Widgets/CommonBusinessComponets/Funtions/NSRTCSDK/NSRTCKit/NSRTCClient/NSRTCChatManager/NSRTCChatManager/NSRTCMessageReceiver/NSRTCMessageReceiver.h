//
//  NSRTCChatManager+MessageReceiver.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/15.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface NSRTCMessageReceiver:NSObject

#pragma mark - message Output

/**
 收到富文本消息:文字、表情、图片、短音频、短视频
 
 @param msg 消息模型
 */
+ (void)receivedRichTextMessage:(NSDictionary *)msg;

/**
 收到P2P视频电话消息 单聊
 
 @param message 消息模型
 */
+ (void)receivedP2PVideoCallMessage:(NSDictionary *)message;
/**
 收到P2P音频电话消息 单聊
 
 @param message 消息模型
 */
+ (void)receivedP2PAudioCallMessage:(NSDictionary *)message;
/**
 收到P2P视频电话消息的拒接 单聊
 
 @param user 消息
 */
+ (void)receivedP2PVideoCallRejected:(NSString *)user;
@end
 
