//
//  NSRTCClient.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCClient.h"
#import "NSBaseSocketIOOperation.h"


@interface NSRTCClient ()

@property (copy, nonatomic) NSRTCClientCallBackHandler callOnConnectedSuccessHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnConnectedResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnConnectedErrorResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnConnectedTimeOutResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnReconnectedAttemptResponseHandler;



@property (copy, nonatomic) NSRTCClientMessageHandler  callOnReceivedMessageHandler;
@property (copy, nonatomic) NSRTCClientVideoChatMessageHandler  callOnReceivedVideoChatInvitationHandler;
@property (copy, nonatomic) NSRTCClientAudioChatMessageHandler  callOnReceivedAudioChatInvitationHandler;
@property (copy, nonatomic) NSRTCClientUserRejectedNotifyHandler  callOnReceivedVideoChatInvitationRejectedHandler;

@property (copy, nonatomic) NSRTCClientUserOnLineNotifyHandler callOnUserOnLineNotifyHandler;
@property (copy, nonatomic) NSRTCClientUserOffLineNotifyHandler callOnUserOffLineNotifyHandler;

@property (copy, nonatomic) NSRTCClientStatusChangeNotifyHandler callOnClientStatusChangedNotifyHandler;



@property (copy, nonatomic) NSRTCClientResponseHandler callOnJoinedResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnLeavedResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnOtherJoinedResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnFulledResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnByedResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnOfferedResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnAnwseredResponseHandler;
@property (copy, nonatomic) NSRTCClientResponseHandler callOnCandidatedResponseHandler;

@end

@implementation NSRTCClient
static id _instance;
+ (instancetype)shareClient {
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance  = [super init];
    });
    return _instance;
}
- (id)copy{
    return _instance;
}
- (id)mutableCopy {
    return _instance;
}
- (void)connectClient{
    [[NSBaseSocketIOOperation shareSocket] connect];
}

- (void)closeClient{
    [[NSBaseSocketIOOperation shareSocket] disconnect];
}

- (NSRTCClient *)registerMonitor{
    [self registerCallBack];
    return self;
}

- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onConnected{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnConnectedResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onConnectedError{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnConnectedErrorResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onConnectedTimeOut{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnConnectedTimeOutResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onReconnectedAttempt{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnReconnectedAttemptResponseHandler = [handler copy];
        return self;
    };
}

- (NSRTCClient*(^)(NSRTCClientMessageHandler))onReceivedSingleChatMessage{
    return ^(NSRTCClientMessageHandler handler){
        self.callOnReceivedMessageHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient *  (^)(NSRTCClientVideoChatMessageHandler ))onReceivedVideoChatInvitation{
    return ^(NSRTCClientVideoChatMessageHandler handler){
        self.callOnReceivedVideoChatInvitationHandler = [handler copy];
        return self;
    };
}

- (NSRTCClient *  (^)(NSRTCClientAudioChatMessageHandler ))onReceivedAudioChatInvitation{
    return ^(NSRTCClientAudioChatMessageHandler handler){
        self.callOnReceivedAudioChatInvitationHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient *  (^)(NSRTCClientUserRejectedNotifyHandler ))onReceivedVideoChatInvitationRejected{
    return ^(NSRTCClientUserRejectedNotifyHandler handler){
        self.callOnReceivedVideoChatInvitationRejectedHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientUserOnLineNotifyHandler))onUserOnline;{
    return ^(NSRTCClientUserOnLineNotifyHandler handler){
        self.callOnUserOnLineNotifyHandler= [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientUserOffLineNotifyHandler))onUserOffline{
    return ^(NSRTCClientUserOffLineNotifyHandler handler){
        self.callOnUserOffLineNotifyHandler= [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientStatusChangeNotifyHandler))onClientStatusChanged{
    return ^(NSRTCClientStatusChangeNotifyHandler handler){
        self.callOnClientStatusChangedNotifyHandler= [handler copy];
        return self;
    };
}




-(NSRTCClient* (^)(NSRTCClientResponseHandler))onJoined{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnJoinedResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onLeaved{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnLeavedResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onOtherJoined{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnOtherJoinedResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onFulled{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnFulledResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onByed{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnByedResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onOffered{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnOfferedResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onAnwsered{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnAnwseredResponseHandler = [handler copy];
        return self;
    };
}
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onCandidated{
    return ^(NSRTCClientResponseHandler handler){
        self.callOnCandidatedResponseHandler = [handler copy];
        return self;
    };
}
  
- (NSRTCClient*(^)(NSString*,NSString*,NSRTCClientCallBackHandler ,NSRTCClientCallBackHandler ))connectServer{
    return ^(NSString*urlPath,NSString*token,NSRTCClientCallBackHandler successCallBack,NSRTCClientCallBackHandler failCallBack){
        __weak typeof(self) weakSelf = self;
        /*
         log 是否打印日志
         forcePolling  是否强制使用轮询
         reconnectAttempts 重连次数，-1表示一直重连
         reconnectWait 重连间隔时间
         forceWebsockets 是否强制使用websocket
         */
        if (!token) {
            !failCallBack?:failCallBack();
        }else{
            [weakSelf closeClient];
            NSDictionary *launchConfig = @{@"log": @NO,
                                           @"forceNew" : @YES,
                                           @"forcePolling": @NO,
                                           @"reconnectAttempts":@(-1),
                                           @"reconnectWait" : @(4),
                                           @"connectParams": @{@"auth_token" : token},
                                           @"forceWebsockets" : @NO};
            [NSBaseSocketIOOperation shareSocket].launchWithSocketServerIPAddr(urlPath,launchConfig);
            [weakSelf registerMonitor];
            weakSelf.callOnConnectedSuccessHandler = [successCallBack copy];
            [NSBaseSocketIOOperation shareSocket].connectSocketServer(^{
                !failCallBack?:failCallBack();
                //timeOut
                !weakSelf.callOnConnectedTimeOutResponseHandler?:weakSelf.callOnConnectedTimeOutResponseHandler(@"",@"",@{});;
            });
        }
        return self;
    };
}

- (NSRTCClient*(^)(NSString*,NSDictionary*))connectWithServerPathAndLaunchConfig{
    return ^(NSString*serverURLPath,NSDictionary*launchConfig){
        __weak typeof(self) weakSelf = self;
        /*
         log 是否打印日志
         forcePolling  是否强制使用轮询
         reconnectAttempts 重连次数，-1表示一直重连
         reconnectWait 重连间隔时间
         forceWebsockets 是否强制使用websocket
         */
    
        [weakSelf closeClient];
//        NSDictionary *launchConfig = @{@"log": @NO,
//                                       @"forceNew" : @YES,
//                                       @"forcePolling": @NO,
//                                       @"reconnectAttempts":@(-1),
//                                       @"reconnectWait" : @(4),
//                                       @"connectParams": @{@"auth_token" : token},
//                                       @"forceWebsockets" : @NO};
        [NSBaseSocketIOOperation shareSocket].launchWithSocketServerIPAddr(serverURLPath,launchConfig);
        return self;
    };
}
 
+ (ClientStatus)status{
    NSUInteger statusValue = [[NSBaseSocketIOOperation shareSocket]checkStatus];
    ClientStatus status = statusValue;
    return status;
}


- (void)registerCallBack{
    //注册状态监听,并启动socket链接服务
    [self socketConnectStatusMonitor];
    [self userStatusMonitor];;
    [self imMessageMonitor];
    
}

//-----------------------------------------------------------------------//
//---------------------CS_machine-Connection_State-----------------------//
//-----------------------------------------------------------------------//
#pragma mark-1.CS state machine Connect Status
- (void)socketConnectStatusMonitor{
    __weak typeof(self) weakSelf = self;
    [NSBaseSocketIOOperation shareSocket].serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        !weakSelf.callOnConnectedSuccessHandler?:weakSelf.callOnConnectedSuccessHandler();
        !weakSelf.callOnConnectedResponseHandler?:weakSelf.callOnConnectedResponseHandler(@"",@"",@{});
    },@"connect").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        NSLog(@"socket connect_error:data",data);
        !weakSelf.callOnConnectedErrorResponseHandler?:weakSelf.callOnConnectedErrorResponseHandler(@"",@"",@{});
    },@"error").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        NSLog(@"socket reconnectAttempt:data",data);
        !weakSelf.callOnReconnectedAttemptResponseHandler?:weakSelf.callOnReconnectedAttemptResponseHandler(@"",@"",@{});
    },@"reconnectAttempt").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        //        double cur = [[data objectAtIndex:0] floatValue];
        //        [[socket emitWithAck:@"canUpdate" with:@[@(cur)]] timingOutAfter:0 callback:^(NSArray* data) {
        //            [socket emit:@"update" with:@[@{@"amount": @(cur + 2.50)}]];
        //        }];
        
        [ack with:@[@"Got your currentAmount, ", @"dude"]];
    },@"currentAmount");
}
//-----------------------------------------------------------------------//
//---------------------Users-Status-Monitor------------------------------//
//-----------------------------------------------------------------------//
#pragma mark-2.User Online Status Based On CS state machine connecting Status
- (void)userStatusMonitor{
    __weak typeof(self) weakSelf = self;
    //
    [NSBaseSocketIOOperation shareSocket].serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        !weakSelf.callOnUserOnLineNotifyHandler?:weakSelf.callOnUserOnLineNotifyHandler([data.firstObject valueForKey:@"user"]);
        // 用户上线
    },@"onLine").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        !weakSelf.callOnUserOffLineNotifyHandler?:weakSelf.callOnUserOffLineNotifyHandler([data.firstObject valueForKey:@"user"]);
        // 用户下线
    },@"offLine").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
       
        NSUInteger statusValue = [[NSBaseSocketIOOperation shareSocket]checkStatus];
        ClientStatus status = statusValue; !weakSelf.callOnClientStatusChangedNotifyHandler?:weakSelf.callOnClientStatusChangedNotifyHandler(status);
        // 连接状态改变
    },@"statusChange");
}
//-----------------------------------------------------------------------//
//---------------------IM-Message-Monitor--------------------------------//
//-----------------------------------------------------------------------//
#pragma mark-3.IM message send&receive Based on User online Statu

#pragma mark-AudioVideoChat Message Monitor
- (void)imMessageMonitor{
    [self singleChatMonitoring];
    [self groupChatMonitoring];
    [self singleAudioVideoWEBRTCServiceChatRoomConnectStatusMonitor];
}
- (void)singleChatMonitoring{
    __weak typeof(self) weakSelf = self;
    //富文本单聊
    [NSBaseSocketIOOperation shareSocket].serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
       
        !weakSelf.callOnReceivedMessageHandler?:weakSelf.callOnReceivedMessageHandler(data.firstObject);
        
        [ack with:@[@[@"我已收到普通消息了消息"]]];
        // 收到消息
    },@"chat");
}
/*
     newGroup 发起一个群聊
     joinGroup 用户x加入群聊
     leaveGroup 用户x离开群聊 _服务端暂时没有
     rejectGroup 用户x拒绝接受群聊邀请 _服务端暂时没有
     messageGroup 用户x在群聊房间发出了富文本信息
     messageInGroup 用户x在群聊房间收到了富文本信息
 */
- (void)groupChatMonitoring{
    __weak typeof(self) weakSelf = self;
    //群聊监听1
#pragma mark- 音视频群聊监听 待后台定义好后再完善
    [NSBaseSocketIOOperation shareSocket].serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        [ack with:@[@"我已收到NewGroup消息"]];
    },@"newGroup").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        [ack with:@[@"我已收到JoinGroup消息"]];
    },@"joinGroup").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        [ack with:@[@"我已收到LeaveGroup消息"]];
    },@"leaveGroup").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        [ack with:@[@"我已收到RejectGroup消息"]];
    },@"rejectGroup").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        [ack with:@[@"我已收到MessageGroup消息"]];
    },@"messageInGroup");
    
}
#pragma mark-AudioVideoChat ChatRoom State Monitor
/*
 Chat Room Channel Message
    握手:
    主动发起者——offer
    接收者-anwser
    p2p通讯信道 candidate
 Chat Room status Message
    加入
    离开
    房间满了
    其他人加入
    其他人挂断
 */
- (void)singleAudioVideoWEBRTCServiceChatRoomConnectStatusMonitor{
    __weak typeof(self) weakSelf = self;
    //音视频电话的邀请、拒接
    [NSBaseSocketIOOperation shareSocket].serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        !weakSelf.callOnReceivedVideoChatInvitationHandler?:weakSelf.callOnReceivedVideoChatInvitationHandler(data.firstObject);
      
        [ack with:@[@[@"我已收到VideoChat消息"]]];
        // 视频通话请求
    },@"videoChat").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        !weakSelf.callOnReceivedAudioChatInvitationHandler?:weakSelf.callOnReceivedAudioChatInvitationHandler(data.firstObject);
        
        [ack with:@[@"我已收到AudioChat消息"]];
        // 视频通话请求
    },@"audioChat").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        //1.发起电话端被拒绝接听
        //2.发起电话端主动挂断
        !weakSelf.callOnReceivedVideoChatInvitationRejectedHandler?:weakSelf.callOnReceivedVideoChatInvitationRejectedHandler(data.firstObject);
      
    },@"rejected");

    
    //音视频电话的聊天室
    [NSBaseSocketIOOperation shareSocket].serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        NSString* room = [data objectAtIndex:0];
        NSString* userId = [data objectAtIndex:1];
        //            NSLog(@"joined room(%@) user(%@)", room,userId);
        !weakSelf.callOnJoinedResponseHandler?:weakSelf.callOnJoinedResponseHandler(room,userId,@{});
    },@"joined").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        NSString* room = [data objectAtIndex:0];
        //            NSLog(@"leaved room(%@)", room);
        NSString* userId = [data objectAtIndex:1];
        //            NSLog(@"leaved user(%@)", userId);
        !weakSelf.callOnLeavedResponseHandler?:weakSelf.callOnLeavedResponseHandler(room,userId,@{});
    },@"leaved").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        NSString* room = [data objectAtIndex:0];
        //            NSLog(@"room(%@) is full", room);
        !weakSelf.callOnFulledResponseHandler?:weakSelf.callOnFulledResponseHandler(room,@"",@{});
    },@"full").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        NSString* room = [data objectAtIndex:0];
        NSString* uid = [data objectAtIndex:1];
        //        NSLog(@"other user(%@) has been joined into room(%@)", room, uid);
        !weakSelf.callOnOtherJoinedResponseHandler?:weakSelf.callOnOtherJoinedResponseHandler(room,uid,@{});
    },@"otherJoin").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        NSString* room = [data objectAtIndex:0];
        NSString* uid = [data objectAtIndex:1];
        //        NSLog(@"other user(%@) has been joined into room(%@)", uid, room);
        !weakSelf.callOnByedResponseHandler?:weakSelf.callOnByedResponseHandler(room,uid,@{});
    },@"bye").serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        NSString* room = [data objectAtIndex:0];
        NSDictionary* msg = [data objectAtIndex:1];
        //        NSLog(@"onMessage, room(%@), data(%@)", room, msg);
        NSString* type = msg[@"type"];
        if( [type isEqualToString:@"offer"]){
            !weakSelf.callOnOfferedResponseHandler?:weakSelf.callOnOfferedResponseHandler(room,@"",msg);
        }else if( [type isEqualToString:@"answer"]){
            !weakSelf.callOnAnwseredResponseHandler?:weakSelf.callOnAnwseredResponseHandler(room,@"",msg);
        }else if( [type isEqualToString:@"candidate"]){
            !weakSelf.callOnCandidatedResponseHandler?:weakSelf.callOnCandidatedResponseHandler(room,@"",msg);
        }else {
            NSLog(@"the msg is invalid!");
        }
        /*
         log 是否打印日志
         forcePolling  是否强制使用轮询
         reconnectAttempts 重连次数，-1表示一直重连
         reconnectWait 重连间隔时间
         forceWebsockets 是否强制使用websocket
         */
    },@"message");
    
    //音视频群聊监听
    

}
#pragma warning mark-音视频群聊监听 待后台定义好后再完善
- (void)groupAudioVideoWEBRTCServiceChatRoomConnectStatusMonitor{
    [NSBaseSocketIOOperation shareSocket].serverEventMonitorRegisterWithEventToken(^(NSArray * data, SocketAckEmitter * ack){
        
    },@"");
}


//---------------------------------------------------------//
//---------------------------------------------------------//

#pragma Send Chat Message


#pragma mark-Send Chat Message Only
#pragma SingleAVChat
//发送消息 offer anwser candidate
- (NSRTCClient *(^)(NSString *,NSDictionary*))sendAVChatRoomMessage{
    return ^(NSString*roomId,NSDictionary*message){
        [NSBaseSocketIOOperation shareSocket].excuteEvent(@"message",@[roomId, message]);
        return self;
    };
}
//加入房间
- (NSRTCClient *(^)(NSString *))joinAVChatRoom{
    return ^(NSString*roomId){
        [NSBaseSocketIOOperation shareSocket].excuteEvent(@"join",@[roomId]);
        return self;
    };
}
//离开房间
- (NSRTCClient *(^)(NSString *))leaveAVChatRoom{
    return ^(NSString*roomId){
        [NSBaseSocketIOOperation shareSocket].excuteEvent(@"leave",@[roomId]);
        return self;
    };
}
//拒接
- (NSRTCClient *(^)(NSDictionary *,NSString *))rejectAVPhoneCall{
    return ^(NSDictionary*user,NSString*roomId){
        [NSBaseSocketIOOperation shareSocket].excuteEvent(@"reject",@[roomId,user]);
        return self;
    };
}


#pragma GroupChat
- (NSRTCClient *(^)(NSArray *,NSString*,NSString*))setupGroupMessage{
    return ^(NSArray *groupUsers,NSString*roomMessageOrigin,NSString*roomId){
        [NSBaseSocketIOOperation shareSocket].excuteEvent(@"newGroup",@[roomId,roomMessageOrigin,groupUsers]);
        return self;
    };
}
/*
 1.加入群聊聊天室
 */
- (NSRTCClient*(^)(NSArray *groupUsers,NSString *,NSString*))joinGroupChatRoom{
    return ^(NSArray *groupUsers,NSString*roomMessageOrigin,NSString*roomId){
        [NSBaseSocketIOOperation shareSocket].excuteEvent(@"joinGroup",@[roomId,roomMessageOrigin,groupUsers]);
        return self;
    };
}
/*
 2.离开群聊聊天室
 */
- (NSRTCClient*(^)(NSString *,NSString*))leaveGroupChatRoom{
    return ^(NSString *user,NSString*roomId){
        [NSBaseSocketIOOperation shareSocket].excuteEvent(@"leaveGroup",@[roomId,user]);
        return self;
    };
}

/*
 3.拒绝加入群聊聊天室、或者是发起未接听时挂断
 */
- (NSRTCClient*(^)(NSDictionary *,NSString*))rejectGroupChatCallInvitation{
    return ^(NSDictionary *user,NSString*roomId){
        [NSBaseSocketIOOperation shareSocket].excuteEvent(@"rejectGroup",@[roomId,user]);
        return self;
    };
}
//---------------------------------------------------------//

#pragma mark-Send Chat Message And Wait for response(Current Device User is Agent receiver)
#pragma Send Chat Message And Wait for response(Current Device User is Agent sender)


#pragma Single P2P Chat
#pragma mark-P2P Audio Chat
+ (void)beginAudioChatFromUser:(NSString *)from toUser:(NSString *)to success:(void(^)(NSString*roomId))successHandler fail:(void(^)(void))failHandler{
    [NSBaseSocketIOOperation shareSocket].sendAckEvent(@"audioChat",@[@{@"from_user":from, @"to_user":to, @"chat_type":@"chat"}],^(NSArray*data){
        if ([data.firstObject isKindOfClass:[NSString class]] && [data.firstObject isEqualToString:@"NO ACK"]) {  // 服务器没有应答
            NSLog(@"房间创建失败");
            !failHandler?:failHandler();
        } else {  // 服务器应答
            NSLog(@"房间创建成功");
            NSString *room = data.firstObject;
            !successHandler?:successHandler(room);
        }
    });
}
#pragma mark-P2P Video Chat
+ (void)beginVideoChatFromUser:(NSString *)from toUser:(NSString *)to success:(void(^)(NSString*roomId))successHandler fail:(void(^)(void))failHandler{
    [NSBaseSocketIOOperation shareSocket].sendAckEvent(@"videoChat",@[@{@"from_user":from, @"to_user":to, @"chat_type":@"chat"}],^(NSArray*data){
         if ([data.firstObject isKindOfClass:[NSString class]] && [data.firstObject isEqualToString:@"NO ACK"]) {  // 服务器没有应答
               NSLog(@"房间创建失败");
               !failHandler?:failHandler();
           } else {  // 服务器应答
               NSLog(@"房间创建成功");
               NSString *room = data.firstObject;
               !successHandler?:successHandler(room);
           }
    });
}
#pragma mark-P2P Normal RichText Message Chat
+ (void)sendChatMessage:(NSDictionary *)message success:(void(^)(NSDictionary*respnse))successHandler fail:(void(^)(void))failHandler {
    [NSBaseSocketIOOperation shareSocket].sendAckEvent(@"chat",@[message],^(NSArray*data){
        if ([data.firstObject isKindOfClass:[NSString class]] && [data.firstObject isEqualToString:@"NO ACK"]) {  // 服务器没有应答
            !failHandler?:failHandler();
        }else {  // 服务器应答
            NSDictionary *ackDic = data.firstObject;
            !successHandler?:successHandler(ackDic);
        }
    });
}

#pragma GroupChat
#pragma mark-GroupChat start Group Chat
// 发起群聊
+ (void)beginGroupChatMessage:(NSDictionary *)message success:(void (^)(NSDictionary *))successHandler fail:(void (^)(void))failHandler {
    [NSBaseSocketIOOperation shareSocket].sendAckEvent(@"newGroup",@[message],^(NSArray*data){
        if ([data.firstObject isKindOfClass:[NSString class]] && [data.firstObject isEqualToString:@"NO ACK"]) {  // 服务器没有应答
            !failHandler?:failHandler();
        }else {  // 服务器应答
            NSDictionary *ackDic = data.firstObject;
            !successHandler?:successHandler(ackDic);
        }
    });
}
#pragma mark-GroupChat With Normal RichText Message
// 发送群聊消息
+ (void)sendGroupChatMessage:(NSDictionary *)message success:(void (^)(NSDictionary *))successHandler fail:(void (^)(void))failHandler {
    [NSBaseSocketIOOperation shareSocket].sendAckEvent(@"messageGroup",@[message],^(NSArray*data){
        if ([data.firstObject isKindOfClass:[NSString class]] && [data.firstObject isEqualToString:@"NO ACK"]) {  // 服务器没有应答
            !failHandler?:failHandler();
        }else {  // 服务器应答
            NSDictionary *ackDic = data.firstObject;
            !successHandler?:successHandler(ackDic);
        }
    });
}
@end
