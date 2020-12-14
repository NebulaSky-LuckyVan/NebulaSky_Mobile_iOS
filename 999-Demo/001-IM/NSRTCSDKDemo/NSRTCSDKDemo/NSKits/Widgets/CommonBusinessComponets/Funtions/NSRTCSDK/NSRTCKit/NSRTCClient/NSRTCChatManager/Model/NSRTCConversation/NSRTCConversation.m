//
//  NSRTCConversation.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCConversation.h"
#import "NSRTCMessage.h"

@implementation NSRTCConversation

- (void)setLatestMessage:(NSRTCMessage *)latestMessage {
    
    self.latestMsgTimeStamp = latestMessage.timestamp;
    self.latestMsgStr = [NSRTCConversation getMessageTypeDescStrWithMessage:latestMessage];
    
}

- (instancetype)initWithMessageModel:(NSRTCMessage *)message conversationId:(NSString *)conversationId{
    if (self = [super init]) {
        self.latestMessage = message;
        self.userName = conversationId;
    }
    return self;
}


+ (NSString *)getMessageTypeDescStrWithMessage:(NSRTCMessage *)message {
    NSString *latestMsgStr;
    switch (message.type) {
        case NSRTCMessageText:
            latestMsgStr = message.bodies.msg;
            break;
            
        case NSRTCMessageImage:
            latestMsgStr = @"[图片]";
            break;
            
        case NSRTCMessageLoc:
            latestMsgStr = @"[定位]";
            break;
            
        case NSRTCMessageAudio:
            latestMsgStr = @"[语音]";
            break;
            
        case NSRTCMessageVideo:
            latestMsgStr = @"[视频]";
            break;
            
        case NSRTCMessageOther:
            latestMsgStr = @"[其他]";
            break;
            
        default:
            latestMsgStr = @"错误";
            break;
    }
    return latestMsgStr;
}
@end
