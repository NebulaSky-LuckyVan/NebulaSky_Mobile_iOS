//
//  NSRTCChatManager.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCChatManager.h"
#import "NSRTCClient.h"
#import "NSRTCMessage.h"
#import "NSRTCChatUser.h"
#import "NSRTCChatViewModel.h"
#import "NSRTCChatListViewModel.h"
#import "NSString+Common.h"
#import "NSObject+Common.h"
#import "NSDate+Common.h"
#import "NSData+Common.h"
#import "NSRTCChatMessageDBOperation.h"
#import "NSRTCMessageNotifyer.h"
@implementation NSRTCChatMessageIOBridge

+ (instancetype)bridgeWithReceiveMessageDelegate:(id<NSRTCChatMessageIOProtocol>)delegate {
    NSRTCChatMessageIOBridge *bridge = [[NSRTCChatMessageIOBridge alloc]init];
    bridge.delegate = delegate;
    return bridge;
}



@end
/*Desc:其他及时通讯*/
@interface NSRTCChatManager ()
@property (strong, nonatomic) NSRTCClient *client;
@property (nonatomic, strong) NSMutableArray *delegateItems;
@property (nonatomic, strong) NSMutableArray *delegateBridgeItems;
@end


@implementation NSRTCChatManager
//===============SingleTon====================//
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        [_instance setup];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopy{
    return _instance;
}
- (id)copy{
    return _instance;
}
+ (instancetype)shareManager{
    return [[self alloc]init];
}
- (void)setUserAuthToken:(NSString *)token currUserID:(NSString *)userId{
    self.user.auth_token = token;
    self.user.currentUserID = userId;
}
//===================================//


- (NSRTCClient *)client{
    return [NSRTCClient shareClient];
}

- (void)setup{
    
    [self beginMessageMonitor];
}

- (NSRTCChatUser *)user{
    if (!_user) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginUser"];
        _user = [NSRTCChatUser yy_modelWithDictionary:userInfo];
    }
    return _user;
}

- (NSMutableArray *)delegateItems{
    if (!_delegateItems) {
        _delegateItems = [NSMutableArray array];
    }
    return _delegateItems;
}
-(NSMutableArray *)delegateBridgeItems{
    if (!_delegateBridgeItems) {
        _delegateBridgeItems = [NSMutableArray array];
    }
    return _delegateBridgeItems;
}
#pragma mark - Public
- (NSRTCChatMessageIOBridge*)addDelegate:(id<NSRTCChatMessageIOProtocol>)delegate {
    NSRTCChatMessageIOBridge *bridge = nil;
    if (![self.delegateItems containsObject:delegate]) {
        [self.delegateItems addObject:delegate];
        bridge = [NSRTCChatMessageIOBridge bridgeWithReceiveMessageDelegate:delegate];
        [self.delegateBridgeItems addObject:bridge];
    }
    return bridge;
}

- (void)removeDelegate:(id<NSRTCChatMessageIOProtocol>)delegate {
    if ([self.delegateItems containsObject:delegate]) {
        [self.delegateItems removeObject:delegate];
        
        for (NSRTCChatMessageIOBridge *bridge in self.delegateBridgeItems) {
            if (bridge.delegate==delegate) {
                [self.delegateBridgeItems removeObject:bridge];
                break;
            }
        }
        
    }
}

- (void)beginMessageMonitor{
    __weak typeof(self) weakSelf = self;
    self.client.onReceivedSingleChatMessage(^(NSDictionary*msg){
        [weakSelf receivedRichTextMessage:msg];
    }).onReceivedVideoChatInvitation(^(NSDictionary*msg){
        [weakSelf receivedP2PVideoCallMessage:msg];
    }).onReceivedAudioChatInvitation(^(NSDictionary*msg){
        [weakSelf receivedP2PAudioCallMessage:msg];
    }).onReceivedVideoChatInvitationRejected(^(NSString*user){
        [weakSelf receivedP2PVideoCallRejected:user];
    });
}
#pragma Private





#pragma mark - Public
- (NSRTCMessage *)sendTextMessage:(NSString *)text toUser:(NSString *)toUser sendStatus:(void (^)(NSRTCMessage *message))sendStatus{
    
    
    NSRTCMessageBody *messageBody = [[NSRTCMessageBody alloc] init];
    messageBody.type = @"txt";
    messageBody.msg = text;
    
    NSRTCMessage *message = [[NSRTCMessage alloc] initWithToUser:toUser
                                                            fromUser:[NSRTCChatManager shareManager].user.currentUserID
                                                            chatType:@"chat"];
    message.bodies = messageBody;
    [self sendMessage:message fileData:nil isResend:NO statusChange:^{
        
        sendStatus(message);
    }];
    return message;
}
- (NSRTCMessage *)sendLocationMessage:(CLLocationCoordinate2D)location locationName:(NSString *)locationName detailLocationName:(NSString *)detailLocationName toUser:(NSString *)toUser sendStatus:(void (^)(NSRTCMessage *))sendStatus {
    
    NSRTCMessage *message = [[NSRTCMessage alloc] initWithToUser:toUser fromUser:[NSRTCChatManager shareManager].user.currentUserID chatType:@"chat"];
    NSRTCMessageBody *messageBody = [[NSRTCMessageBody alloc] init];
    messageBody.type = @"loc";
    messageBody.latitude = location.latitude;
    messageBody.longitude = location.longitude;
    messageBody.locationName = locationName;
    messageBody.detailLocationName = detailLocationName;
    message.bodies = messageBody;
    [self sendMessage:message fileData:nil isResend:NO statusChange:^{
        
        sendStatus(message);
    }];
    return message;
}
- (NSRTCMessage *)sendImgMessage:(NSData *)imgData sImageData:(NSData *)sImageData toUser:(NSString *)toUser sendStatus:(void (^)(NSRTCMessage *message))sendStatus {
    
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [NSString creatUUIDString]];
    
    NSRTCMessage *message = [[NSRTCMessage alloc] initWithToUser:toUser fromUser:[NSRTCChatManager shareManager].user.currentUserID chatType:@"chat"];
    NSRTCMessageBody *messageBody = [[NSRTCMessageBody alloc] init];
    messageBody.type = @"img";
    messageBody.fileName = imageName;
    
    UIImage *image = [UIImage imageWithData:imgData];
    CGSize size = image.size;
    messageBody.size = @{@"width" : @(size.width), @"height" : @(size.height)};
    // 保存图片到本地沙河
    NSString *savePath = [[NSString getFielSavePath] stringByAppendingPathComponent:imageName];
    NSString *sSavePath = [[NSString getFielSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"s_%@", imageName]];
    [self saveFile:imgData toPath:savePath];
    [self saveFile:sImageData toPath:sSavePath];
    message.bodies = messageBody;
    
    [self sendMessage:message fileData:imgData isResend:NO statusChange:^{
        
        sendStatus(message);
    }];
    
    
    return message;
}

- (NSRTCMessage *)sendAudioMessage:(NSString *)audioDataPath duration:(CGFloat)duration toUser:(NSString *)toUser sendStatus:(void (^)(NSRTCMessage *))sendStatus {
    
    NSString *audioName = [audioDataPath lastPathComponent];
    NSRTCMessage *message = [[NSRTCMessage alloc] initWithToUser:toUser fromUser:[NSRTCChatManager shareManager].user.currentUserID chatType:@"chat"];
    NSRTCMessageBody *messageBody = [[NSRTCMessageBody alloc] init];
    
    messageBody.type = @"audio";
    messageBody.fileName = audioName;
    messageBody.duration = duration * 2;
    NSData *audioData = [NSData dataWithContentsOfFile:audioDataPath];
    message.bodies = messageBody;
    
    [self sendMessage:message fileData:audioData isResend:NO statusChange:^{
        
        sendStatus(message);
    }];
    
    
    
    
    return message;
    
}

- (void)resendMessage:(NSRTCMessage *)message sendStatus:(void (^)(NSRTCMessage *))sendStatus {
    switch (message.type) {
        case NSRTCMessageText:{
            [self resendTextMessage:message sendStatus:sendStatus];
            break;
        }
            
        case NSRTCMessageImage:{
            [self resendImgMessage:message sendStatus:sendStatus];
            break;
        }
            
        case NSRTCMessageLoc: {
            [self resendLocMessage:message sendStatus:sendStatus];
            break;
        }
            
        case NSRTCMessageAudio: {
            [self resendAudioMessage:message sendStatus:sendStatus];
            break;
        }
        case NSRTCMessageOther:{
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private

/**
 重发文本消息
 
 @param messsage 消息模型
 @param sendStatus 发送状态回调
 */
- (void)resendTextMessage:(NSRTCMessage *)messsage sendStatus:(void (^)(NSRTCMessage *))sendStatus {
    
    [self sendMessage:messsage fileData:nil isResend:YES statusChange:^{
        sendStatus(messsage);
    }];
}

/**
 重发图片消息
 
 @param message 消息模型
 @param sendStatus 发送状态回调
 */
- (void)resendImgMessage:(NSRTCMessage *)message sendStatus:(void (^)(NSRTCMessage *))sendStatus {
    
    
    NSData *imageData;
    NSString *locImgPath = [[NSString getFielSavePath] stringByAppendingPathComponent:message.bodies.fileName];
    if (locImgPath.length) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        imageData = [fileManager contentsAtPath:locImgPath];
    }
    if (!imageData) {
        
        [NSRTCChatManager showWithTitle:@"图片重发失败！" message:@"本地图片已不存在" cancelButtonTitle:@"确定" otherButtonTitles:nil andAction:nil andParentView:nil];
        return;
    }
    [self sendMessage:message fileData:imageData isResend:YES statusChange:^{
        
        sendStatus(message);
    }];
    
}
/**
 重发定位消息
 
 @param message 消息模型
 @param sendStatus 发送状态回调
 */
- (void)resendLocMessage:(NSRTCMessage *)message sendStatus:(void (^)(NSRTCMessage *))sendStatus {
    
    [self sendMessage:message fileData:nil isResend:YES statusChange:^{
        sendStatus(message);
    }];
}


/**
 重发语音消息
 
 @param message 消息模型
 @param sendStatus 发送状态回调
 */
- (void)resendAudioMessage:(NSRTCMessage *)message sendStatus:(void (^)(NSRTCMessage *))sendStatus {
    
    NSData *audioData;
    NSString *locPath = [[NSString getAudioSavePath] stringByAppendingPathComponent:message.bodies.fileName];
    if (locPath.length) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        audioData = [fileManager contentsAtPath:locPath];
    }
    if (!audioData) {
        [NSRTCChatManager showWithTitle:@"图片重发失败！" message:@"语音文件已不存在" cancelButtonTitle:@"确定" otherButtonTitles:nil andAction:nil andParentView:nil];
        return;
    }
    [self sendMessage:message fileData:audioData isResend:YES statusChange:^{
        
        sendStatus(message);
    }];
}



- (BOOL)saveFile:(NSData *)fileData toPath:(NSString *)savePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL saveSuccess = [fileManager createFileAtPath:savePath contents:fileData attributes:nil];
    if (saveSuccess) {
        NSLog(@"文件保存成功");
    }
    return saveSuccess;
}



/**
 保存消息和会话
 
 @param message 消息模型
 */
- (void)saveMessageAndConversationToDBWithMessage:(NSRTCMessage *)message {
    
    message.sendtime = [[NSDate date] timeStamp];
    message.timestamp = [[NSDate date] timeStamp];
    if (![message.from isEqualToString:message.to]) {    // 发送给自己的消息不插入数据库，等到接收到自己的消息后再插入数据库
        // 消息插入数据库
        
        [[NSRTCChatMessageDBOperation shareInstance] addMessage:message];
    }
    
    
    // 数据库添加或者刷新会话
    [[NSRTCChatMessageDBOperation shareInstance] addOrUpdateConversationWithMessage:message isChatting:YES];
}


/**
 发送消息
 
 @param message 消息模型
 @param fileData 文件数据
 @param statusChange 发送状态回调
 */
- (void)sendMessage:(NSRTCMessage *)message fileData:(NSData *)fileData isResend:(BOOL)isResend statusChange:(void (^)(void))statusChange{
    
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


#pragma mark - message Output



/**
 收到富文本消息:文字、表情、图片、短音频、短视频
 
 @param msg 消息模型
 */
- (void)receivedRichTextMessage:(NSDictionary *)msg{
    __weak typeof(self) weakSelf = self;
    NSRTCMessage *message = [NSRTCMessage yy_modelWithJSON:msg];
    NSData *fileData = message.bodies.fileData;
    if (fileData && fileData != NULL && fileData.length) {
        
        NSString *fileName = message.bodies.fileName;
        NSString *savePath = nil;
        switch (message.type) {
            case NSRTCMessageImage:
                savePath = [[NSString getFielSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"s_%@", fileName]];
                break;
            case NSRTCMessageAudio:
                savePath = [[NSString getAudioSavePath] stringByAppendingPathComponent:fileName];
                break;
            default:
                savePath = [[NSString getFielSavePath] stringByAppendingPathComponent:fileName];
                break;
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
    [NSRTCMessageNotifyer pushLocalNotificationWithMessage:message];
    
    
    // 代理处理
    for (id <NSRTCChatMessageIOProtocol>delegate in self.delegateItems) {
        if ([delegate respondsToSelector:@selector(chatManager:receivedMessage:)]) {
            if (message) {
                [delegate chatManager:weakSelf receivedMessage:message];
            }
        }
    }
}
/**
 收到P2P音频电话消息 单聊
 
 @param message 消息模型
 */
- (void)receivedP2PAudioCallMessage:(NSRTCMessage *)message{
    //收到音视频聊天 邀请
    NSString *noticeName = @"P2PAudioCallMessage";
    [[NSNotificationCenter defaultCenter]postNotificationName:noticeName object:message];

}



/**
 收到P2P视频电话消息 单聊
 
 @param message 消息模型
 */
- (void)receivedP2PVideoCallMessage:(NSDictionary *)message{
    //收到音视频聊天 邀请
    NSString *noticeName = @"P2PVideoCallMessage";
    [[NSNotificationCenter defaultCenter]postNotificationName:noticeName object:message];
}

/**
 收到P2P视频电话消息的拒接 单聊
 
 @param user 消息
 */
- (void)receivedP2PVideoCallRejected:(NSString *)user{
    //收到音视频聊天 拒接
    NSLog(@"received P2PVideoCall Rejected from user:%@",user);
}




/**
 收到Group音频电话消息 群聊
 
 @param message 消息模型
 */
- (void)receivedGroupAudioCallMessage:(NSRTCMessage *)message{
    
}



/**
 收到Group视频电话消息 群聊
 
 @param message 消息模型
 */
- (void)receivedGroupVideoCallMessage:(NSRTCMessage *)message{
    
}



/**
 发起P2P音频电话消息 单聊
 
 @param message 消息
 */
- (void)beginP2PAudioCallMessage:(NSDictionary *)message{
    
}



/**
 发起P2P视频电话消息 单聊
 
 @param message 消息
 */
- (void)beginP2PVideoCallMessage:(NSDictionary *)message{
    
}




/**
 发起Group音频电话消息 群聊
 
 @param message 消息
 */
- (void)beginGroupAudioCallMessage:(NSDictionary *)message{
    
}



/**
 发起Group视频电话消息 群聊
 
 @param message 消息
 */
- (void)beginGroupVideoCallMessage:(NSDictionary *)message{
    
}


@end
