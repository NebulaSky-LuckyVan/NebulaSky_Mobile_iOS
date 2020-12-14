//
//  NSRTCClient.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRTCConstant.h"


typedef void(^NSRTCClientResponseHandler)(NSString*room,NSString*user,NSDictionary *responseData);

typedef void(^NSRTCClientMessageHandler)(NSDictionary*);
typedef void(^NSRTCClientVideoChatMessageHandler)(NSDictionary*);
typedef void(^NSRTCClientAudioChatMessageHandler)(NSDictionary*);

typedef void(^NSRTCClientUserOnLineNotifyHandler)(NSString*);
typedef void(^NSRTCClientUserOffLineNotifyHandler)(NSString*);
typedef void(^NSRTCClientUserRejectedNotifyHandler)(NSString*);

typedef void(^NSRTCClientStatusChangeNotifyHandler)(ClientStatus);
typedef void(^NSRTCClientCallBackHandler)(void);

@interface NSRTCClient : NSObject
 
+ (instancetype)shareClient;

+ (ClientStatus)status;

#pragma Connect With Server

- (NSRTCClient*(^)(NSString*urlPath,NSString*token,NSRTCClientCallBackHandler successCallBack,NSRTCClientCallBackHandler))connectServer;


- (NSRTCClient*(^)(NSString*serverURLPath,NSDictionary*launchConfig))connectWithServerPathAndLaunchConfig;



#pragma SingleAVChat
/*
 1.join to chat Room
 */
- (NSRTCClient*(^)(NSString*roomId))joinAVChatRoom;
/*
 2.leave chat Room
 */
- (NSRTCClient*(^)(NSString*roomId))leaveAVChatRoom;
/*
 3.reject for  invitation of join chat room  or  hang up before callee anwser
 */
- (NSRTCClient*(^)(NSDictionary *user,NSString*roomId))rejectAVPhoneCall;
/*
 4.发消息
 */
- (NSRTCClient* (^)(NSString* room ,NSDictionary*msg))sendAVChatRoomMessage;



#pragma GroupChat



/*
 4.Set up a Message Group for to send invitation
 */
- (NSRTCClient*(^)(NSArray *groupUsers,NSString*roomMessageOrigin,NSString*roomId))setupGroupMessage;




/*
 1.加入群聊聊天室
 */
- (NSRTCClient*(^)(NSArray *groupUsers,NSString*roomMessageOrigin,NSString*roomId))joinGroupChatRoom;
/*
 2.离开群聊聊天室
 */
- (NSRTCClient*(^)(NSString *user,NSString*roomId))leaveGroupChatRoom;

/*
 3.拒绝加入群聊聊天室、或者是发起未接听时挂断
 */
- (NSRTCClient*(^)(NSDictionary *user,NSString*roomId))rejectGroupChatCallInvitation;
 






#pragma SingleAVChat






/*
 5.1 重新开始聊天室通讯
 5.2 结束聊天室通讯
 */

- (void) connectClient;
- (void) closeClient;



#pragma StateMachine Status Monitor
/*
 6.注册Socket  监听
 */
- (NSRTCClient*)registerMonitor;


#pragma C_S Connection Status  Monitor
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onConnected;
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onConnectedError;
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onConnectedTimeOut;
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onReconnectedAttempt;

 

#pragma SingleChat

- (NSRTCClient*(^)(NSRTCClientMessageHandler))onReceivedSingleChatMessage;




#pragma Users’ Online Status Monitor
- (NSRTCClient*(^)(NSRTCClientUserOnLineNotifyHandler))onUserOnline;
- (NSRTCClient*(^)(NSRTCClientUserOffLineNotifyHandler))onUserOffline;
- (NSRTCClient*(^)(NSRTCClientStatusChangeNotifyHandler))onClientStatusChanged;



#pragma SingleAVChatRoom Status Monitor P2P sdp 信令传递
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onJoined;
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onLeaved;
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onOtherJoined;
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onFulled;
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onByed;
//WEBRTC
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onOffered;
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onAnwsered;
- (NSRTCClient*(^)(NSRTCClientResponseHandler response))onCandidated;

#pragma SingleAVChatRoom AVPhone Services(Invitation/Rejected)
- (NSRTCClient*(^)(NSRTCClientVideoChatMessageHandler))onReceivedVideoChatInvitation;
- (NSRTCClient*(^)(NSRTCClientAudioChatMessageHandler))onReceivedAudioChatInvitation;
- (NSRTCClient*(^)(NSRTCClientUserRejectedNotifyHandler))onReceivedVideoChatInvitationRejected;
// 发送即时通讯消息
+ (void)sendChatMessage:(NSDictionary *)message success:(void(^)(NSDictionary*response))successHandler fail:(void(^)(void))failHandler;


// 发送群聊消息
+ (void)sendGroupChatMessage:(NSDictionary *)message success:(void(^)(NSDictionary*response))successHandler fail:(void(^)(void))failHandler;

// 发起群聊
+ (void)beginGroupChatMessage:(NSDictionary *)message success:(void (^)(NSDictionary *))successHandler fail:(void (^)(void))failHandler;

+ (void)beginVideoChatFromUser:(NSString *)from toUser:(NSString *)to success:(void(^)(NSString*roomId))successHandler fail:(void(^)(void))failHandler;

+ (void)beginAudioChatFromUser:(NSString *)from toUser:(NSString *)to success:(void(^)(NSString*roomId))successHandler fail:(void(^)(void))failHandler;

@end
 
