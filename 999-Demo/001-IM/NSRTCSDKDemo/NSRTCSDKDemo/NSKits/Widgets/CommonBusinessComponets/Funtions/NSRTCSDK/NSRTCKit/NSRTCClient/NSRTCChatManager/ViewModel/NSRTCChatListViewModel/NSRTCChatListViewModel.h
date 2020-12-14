//
//  NSRTCChatListViewModel.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCViewModel.h"
 
#import "NSRTCChatManager.h"


#import "NSRTCChatMessageDBOperation.h"


#import "NSRTCClient.h"

#import "NSRTCConversation.h"



@class NSRTCMessage;
@class NSRTCConversation;
typedef void(^CallChatListConversationUpdateHandler)(NSMutableArray *conversations);

typedef void(^CallConversationReadStatusUpdateHandler)(NSIndexPath *indexPath);

@interface NSRTCChatListViewModel : NSRTCViewModel


@property (nonatomic, strong,readonly) NSMutableArray *conversations;

@property (copy, nonatomic) CallChatListConversationUpdateHandler updateChatListHandlerBlock;
@property (copy, nonatomic) CallConversationReadStatusUpdateHandler updateConversationReadStatusHandlerBlock;



/**
 与某个联系人的开启会话
 
 @param user 会话的目标联系人
 */
- (void)chatWithUser:(NSString*)user;
/**
 与某个联系人的会话是否存在，存在的话返回该会话
 
 @param toUser 会话的目标联系人
 @return 与某个联系人的会话
 */
- (NSRTCConversation *)isExistConversationWithToUser:(NSString *)toUser;
  

/**
 会话存在，则更新会话最新消息，不存在则添加该会话
 
 @param conversationName 会话ID
 @param message 最新一条消息
 */
- (void)addOrUpdateConversation:(NSString *)conversationName latestMessage:(NSRTCMessage *)message isRead:(BOOL)isRead;

/**
 添加会话
 
 @param message 会话的最新一条消息
 @param read 消息是否已读
 */
//- (void)addConversationWithMessage:(FLMessageModel *)message isReaded:(BOOL)read;



/**
 更新会话的最新消息，包括模型数据和UI
 
 @param message 会话的最新一条消息
 */
//- (void)updateLatestMsgForConversation:(FLConversationModel *)conversation latestMessage:(FLMessageModel *)message;

/**
 更新未读消息红点
 
 @param conversationName 会话ID
 */
- (void)updateRedPointForUnreadWithConveration:(NSString *)conversationName;

#pragma mark - Data
- (void)queryDataFromDB;
@end
 
