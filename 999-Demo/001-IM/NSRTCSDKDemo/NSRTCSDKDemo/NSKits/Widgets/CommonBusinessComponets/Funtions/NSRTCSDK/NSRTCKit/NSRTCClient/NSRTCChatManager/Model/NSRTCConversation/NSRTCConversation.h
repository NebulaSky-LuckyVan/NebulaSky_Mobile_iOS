//
//  NSRTCConversation.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSBaseModel.h"
 

@class NSRTCMessage;
@interface NSRTCConversation : NSBaseModel
@property (nonatomic, copy) NSString *userName;
//@property (nonatomic, strong) FLMessageModel *latestMessage;
@property (nonatomic, assign) long long latestMsgTimeStamp;
@property (nonatomic, copy) NSString *imageStr;
@property (nonatomic, copy) NSString *latestMsgStr;
@property (nonatomic, assign) NSInteger unReadCount;

- (instancetype)initWithMessageModel:(NSRTCMessage *)message conversationId:(NSString *)conversationId;

- (void)setLatestMessage:(NSRTCMessage *)latestMessage;

+ (NSString *)getMessageTypeDescStrWithMessage:(NSRTCMessage *)message;

@end
 
