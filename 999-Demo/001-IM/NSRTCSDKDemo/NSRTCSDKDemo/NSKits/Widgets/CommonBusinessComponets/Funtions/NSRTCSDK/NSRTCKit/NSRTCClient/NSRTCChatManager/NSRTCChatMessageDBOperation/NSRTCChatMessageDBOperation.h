//
//  NSRTCChatMessageDBOperation.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@class NSRTCMessage;
@class NSRTCConversation;
@interface NSRTCChatMessageDBOperation : NSObject

+ (instancetype)shareInstance;

/**
 向数据库添加消息
 
 @param message 消息模型
 */
- (void)addMessage:(NSRTCMessage *)message;



/**
 更新消息
 
 @param message 消息模型
 */
- (void)updateMessage:(NSRTCMessage *)message;



/**
 查询与某个用户的所有聊天信息
 
 @param userName 对方用户的名字
 @return 查询到的聊天记录
 */
- (NSArray <NSRTCMessage *>*)queryMessagesWithUser:(NSString *)userName;


/**
 分页查询与某个用户的聊天信息
 
 @param userName 对方的用户名称
 @param limit 每页显示个数
 @param page 查询的页数
 @return 查询到的聊天记录
 */
- (NSArray <NSRTCMessage *>*)queryMessagesWithUser:(NSString *)userName limit:(NSInteger)limit page:(NSInteger)page;





/**
 向数据库添加会话
 
 @param conversation 会话模型
 */
//- (void)addConversation:(XHConversationModel *)conversation;


/**
 查询所有的会话
 
 @return 查询到的会话数组
 */
- (NSArray<NSRTCConversation *> *)queryAllConversations;

/**
 更新会话的最近消息数据
 
 @param conversation 会话模型
 @param message 最新消息
 */
//- (void)updateLatestMessageOfConversation:(XHConversationModel *)conversation  andMessage:(XHIMMessageModel *)message;


/**
 插入或更新会话
 
 @param message 消息模型
 @param isChatting 会话是否已经开启
 */
- (void)addOrUpdateConversationWithMessage:(NSRTCMessage *)message isChatting:(BOOL)isChatting;


/**
 更新会话未读消息数量
 
 @param conversationName 会话ID
 @param unreadCount 未读消息数量
 */
- (void)updateUnreadCountOfConversation:(NSString *)conversationName unreadCount:(NSInteger)unreadCount;


@end
 
