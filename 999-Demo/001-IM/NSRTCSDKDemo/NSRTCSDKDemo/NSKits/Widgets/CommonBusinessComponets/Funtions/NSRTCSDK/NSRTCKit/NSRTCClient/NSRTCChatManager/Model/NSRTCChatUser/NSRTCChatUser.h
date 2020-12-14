//
//  NSRTCChatUser.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSBaseModel.h"
 

@interface NSRTCChatUser : NSBaseModel

/**
 token
 */
@property (nonatomic, copy) NSString *auth_token;

/**
 当前用户ID
 */
@property (nonatomic, copy) NSString *currentUserID;

/**
 全部未读消息数量
 */
@property (nonatomic, assign) NSInteger *unreadMessageCount;
@end
 
