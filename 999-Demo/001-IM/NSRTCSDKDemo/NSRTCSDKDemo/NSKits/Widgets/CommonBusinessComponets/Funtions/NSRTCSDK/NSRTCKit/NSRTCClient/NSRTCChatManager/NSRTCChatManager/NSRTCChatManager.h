//
//  NSRTCChatManager.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//
 
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
 
#import "NSRTCMessageSender.h"
#import "NSRTCMessageReceiver.h"
 
@class NSRTCMessage;
@class NSRTCChatUser;
@class NSRTCChatManager;
@class NSRTCChatViewModel;
@class NSRTCChatListViewModel;

@protocol NSRTCChatMessageIOProtocol <NSObject>
@optional
- (void)chatManager:(NSRTCChatManager *)manager receivedMessage:(NSRTCMessage*)message;
@end


@interface NSRTCChatManager : NSObject

/*
 当前用户
 */
@property (strong, nonatomic) NSRTCChatUser *user;


/**
 正在聊天的会话控制器
 */
@property (nonatomic, weak) NSRTCChatViewModel *currChatPageViewModel;


/**
 消息会话列表
 */
@property (nonatomic, weak) NSRTCChatListViewModel *chatListPageViewModel;


@property (nonatomic, strong ,readonly) NSMutableArray *delegateItems;



+ (instancetype)shareManager;

- (void)setUserAuthToken:(NSString*)token currUserID:(NSString*)userId;
/**
 添加代理
 
 @param delegate 代理
 */
- (void)addDelegate:(id<NSRTCChatMessageIOProtocol>)delegate;

/**
 移除代理
 
 @param delegate 代理
 */
- (void)removeDelegate:(id)delegate;
//Desc:
@property (strong, nonatomic) NSString *deviceToken;

@end



