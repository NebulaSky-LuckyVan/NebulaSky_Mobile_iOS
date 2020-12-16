//
//  NSRTCChatManager+MessageReceiver.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/15.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCMessageReceiver.h"

@implementation NSRTCMessageReceiver

#pragma mark - message Output

/**
 收到富文本消息:文字、表情、图片、短音频、短视频
 
 @param msg 消息模型
 */
+ (void)receivedRichTextMessage:(NSDictionary *)msg{ 
    NSRTCMessage *message = [NSRTCMessage yy_modelWithJSON:msg];
    NSData *fileData = message.bodies.fileData;
    if (fileData && fileData != NULL && fileData.length) {
        NSString *fileName = message.bodies.fileName;
        NSString *savePath = nil;
        switch (message.type) {
            case NSRTCMessageImage:{
                NSTimeInterval tiStampValue = [NSDate nowTimeStamp];
                savePath = [[NSString getFielSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%f_%@",tiStampValue, fileName]];
            }break;
            case NSRTCMessageAudio:{
                savePath = [[NSString getAudioSavePath] stringByAppendingPathComponent:fileName];
            }break;
            default:{
                savePath = [[NSString getFielSavePath] stringByAppendingPathComponent:fileName];
            }break;
        }
        message.bodies.fileData = nil;
        [fileData saveToLocalPath:savePath];
    }
    
    
    id bodyStr = msg[@"bodies"];
    if ([bodyStr isKindOfClass:[NSString class]]) {
        NSRTCMessageBody *body = [NSRTCMessageBody yy_modelWithJSON:[bodyStr stringToJsonDictionary]];
        message.bodies = body;
    }else if ([bodyStr isKindOfClass:[NSDictionary class]]){
        NSRTCMessageBody *body = [NSRTCMessageBody yy_modelWithJSON:bodyStr];
        message.bodies = body;
    }
    // 消息插入数据库
    [[NSRTCChatMessageDBOperation shareInstance] addMessage:message];
    
    // 会话插入数据库或者更新会话
    BOOL isChatting = [message.from isEqualToString:[NSRTCChatManager shareManager].currChatPageViewModel.toUser];
    [[NSRTCChatMessageDBOperation shareInstance] addOrUpdateConversationWithMessage:message isChatting:isChatting];
    
    // 本地推送，收到消息添加红点，声音及震动提示
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kDidLogin]) {
        [NSRTCMessageNotifyer pushLocalNotificationWithMessage:message]; 
    }  // 代理处理
    for (id <NSRTCChatMessageIOProtocol>delegate in [NSRTCChatManager shareManager].delegateItems) {
        if ([delegate respondsToSelector:@selector(chatManager:receivedMessage:)]) {
            if (message) {
                [delegate chatManager:[NSRTCChatManager shareManager] receivedMessage:message];
            }
        }
    }
   
}

/**
 收到P2P视频电话消息 单聊
 
 @param message 消息模型
 */
+ (void)receivedP2PVideoCallMessage:(NSDictionary *)message{
    //收到音视频聊天 邀请
    NSString *noticeName = @"P2PVideoCallMessage";
    [[NSNotificationCenter defaultCenter]postNotificationName:noticeName object:message];
}
/**
 收到P2P音频电话消息 单聊
 
 @param message 消息模型
 */
+ (void)receivedP2PAudioCallMessage:(NSDictionary *)message{
    //收到音视频聊天 邀请
    NSString *noticeName = @"P2PAudioCallMessage";
    [[NSNotificationCenter defaultCenter]postNotificationName:noticeName object:message];
}





/**
 收到P2P视频电话消息的拒接 单聊
 
 @param user 消息
 */
+ (void)receivedP2PVideoCallRejected:(NSString *)user{
    //收到音视频聊天 拒接
    NSLog(@"received P2PVideoCall Rejected from user:%@",user);
}
@end
