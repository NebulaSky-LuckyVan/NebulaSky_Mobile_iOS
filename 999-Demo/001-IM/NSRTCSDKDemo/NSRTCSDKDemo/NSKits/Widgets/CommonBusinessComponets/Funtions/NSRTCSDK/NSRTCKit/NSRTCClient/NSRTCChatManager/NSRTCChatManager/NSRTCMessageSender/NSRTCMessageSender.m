//
//  NSRTCMessageSender.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/15.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCMessageSender.h"

@implementation NSRTCMessageSender
+ (void)sendMessage:(NSRTCMessage*)message success:(void(^)(void))successBlock fail:(void(^)(void))failBlock{
    [NSRTCMessageSender sendMessage:message fileData:message.bodies.fileData isResend:NO statusChange:^{
        if (message.sendStatus==NSRTCMessageSendSuccess) {
            !successBlock?:successBlock();
        }else if (message.sendStatus==NSRTCMessageSendFail) {
            !failBlock?:failBlock();
        }else{
            NSLog(@"%s",__func__);
        }
    }];
}
+ (void)reSendMessage:(NSRTCMessage*)message success:(void(^)(void))successBlock fail:(void(^)(void))failBlock{
    void (^CallResendMessageHandler)(void) = ^(void){
        [NSRTCMessageSender sendMessage:message fileData:message.bodies.fileData isResend:YES statusChange:^{
            if (message.sendStatus==NSRTCMessageSendSuccess) {
                !successBlock?:successBlock();
            }else if (message.sendStatus==NSRTCMessageSendFail) {
                !failBlock?:failBlock();
            }else{
                NSLog(@"%s",__func__);
            }
        }];
    };
    switch (message.type) {
        case NSRTCMessageText:{
            CallResendMessageHandler();
        }break;
        case NSRTCMessageImage:{
            NSData *imageData;
            NSString *locImgPath = [[NSString getFielSavePath] stringByAppendingPathComponent:message.bodies.fileName];
            if (locImgPath.length) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                imageData = [fileManager contentsAtPath:locImgPath];
            }
            if (!imageData) {
                [NSRTCMessageSender showWithTitle:@"图片重发失败！" message:@"本地图片已不存在" cancelButtonTitle:@"确定" otherButtonTitles:nil andAction:nil andParentView:nil];
                return;
            }
            CallResendMessageHandler();
        }break;
        case NSRTCMessageLoc: {
            CallResendMessageHandler();
        }break;
        case NSRTCMessageAudio: {
            NSData *audioData;
            NSString *locPath = [[NSString getAudioSavePath] stringByAppendingPathComponent:message.bodies.fileName];
            if (locPath.length) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                audioData = [fileManager contentsAtPath:locPath];
            }
            if (!audioData) {
                [NSRTCMessageSender showWithTitle:@"语音重发失败！" message:@"语音文件已不存在" cancelButtonTitle:@"确定" otherButtonTitles:nil andAction:nil andParentView:nil];
                return;
            }
            CallResendMessageHandler();
        }break;
        case NSRTCMessageOther:{
            NSLog(@"%s",__func__);
        }break;
        default:
            break;
    }
     
   
}

/**
 发送消息
 
 @param message 消息模型
 @param fileData 文件数据
 @param statusChange 发送状态回调
 */
+ (void)sendMessage:(NSRTCMessage *)message fileData:(NSData *)fileData isResend:(BOOL)isResend statusChange:(void (^)(void))statusChange{
    
    if (!isResend) { // 重发的消息不要保存
        // 保存消息和会话到数据库
        [self saveMessageAndConversationToDBWithMessage:message];
    }
    
    NSMutableDictionary *parameters;
    if (fileData && fileData.length) {
        NSDictionary *tempPara = [message yy_modelToJSONObject];
        NSDictionary *tempBody = tempPara[@"bodies"];
        parameters = [tempPara mutableCopy];
        NSMutableDictionary *body = [tempBody mutableCopy];
        body[@"fileData"] = fileData;
        parameters[@"bodies"] = body;
    }
    else {
        parameters = [message yy_modelToJSONObject];
    }
    
    CGFloat timeOut = 10;
    if (message.type == NSRTCMessageImage) {
        timeOut = 20;
    }
    void (^CallUPDATEMessageHandler)(void) = ^(){
        // 更新消息
        [[NSRTCChatMessageDBOperation shareInstance] updateMessage:message];
        // 数据库添加或者刷新会话
        [[NSRTCChatMessageDBOperation shareInstance] addOrUpdateConversationWithMessage:message isChatting:YES];
        
    };
    [NSRTCClient sendChatMessage:parameters success:^(NSDictionary *respnse) {
        message.sendStatus = NSRTCMessageSendSuccess ;
        // 发送成功
        message.timestamp = [respnse[@"timestamp"] longLongValue];
        message.msg_id = respnse[@"msg_id"];
        if (fileData) {
            NSDictionary *bodies = respnse[@"bodies"];
            message.bodies.fileRemotePath = bodies[@"fileRemotePath"];
            message.bodies.thumbnailRemotePath = bodies[@"thumbnailRemotePath"];
        }
        if (message.type == NSRTCMessageLoc) {
            NSDictionary *bodiesDic = respnse[@"bodies"];
            message.bodies.fileRemotePath = bodiesDic[@"fileRemotePath"];
        }
        statusChange();
        CallUPDATEMessageHandler();
    } fail:^{
        message.sendStatus = NSRTCMessageSendFail;
        // 发送失败
        statusChange();
        CallUPDATEMessageHandler();
    }];
}
/**
 保存消息和会话
 
 @param message 消息模型
 */
+ (void)saveMessageAndConversationToDBWithMessage:(NSRTCMessage *)message {
    message.sendtime = [[NSDate date] timeStamp];
    message.timestamp = [[NSDate date] timeStamp];
    if (![message.from isEqualToString:message.to]) {    // 发送给自己的消息不插入数据库，等到接收到自己的消息后再插入数据库
        // 消息插入数据库
        
        [[NSRTCChatMessageDBOperation shareInstance] addMessage:message];
    }
    // 数据库添加或者刷新会话
    [[NSRTCChatMessageDBOperation shareInstance] addOrUpdateConversationWithMessage:message isChatting:YES];
}
@end
