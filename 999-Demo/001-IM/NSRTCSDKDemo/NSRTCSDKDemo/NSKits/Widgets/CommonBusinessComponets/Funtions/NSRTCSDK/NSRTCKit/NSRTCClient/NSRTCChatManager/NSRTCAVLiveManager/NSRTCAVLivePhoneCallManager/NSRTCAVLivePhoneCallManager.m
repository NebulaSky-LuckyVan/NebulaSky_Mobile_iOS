//
//  NSRTCAVLivePhoneCallManager.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCAVLivePhoneCallManager.h"

#import <WebRTC/WebRTC.h>
  
#import "NSRTCClient.h"
#import "NSRTCChatManager.h"
#import "NSRTCChatUser.h"

#import "NSRTCAVLiveChatUser.h"

#import "NSRTCAVLiveManager.h"
#import "NSRTCAVLiveConnectionManager.h"

#import "NSObject+Common.h"
 
 
typedef NS_ENUM(NSUInteger,NSRTCAVLivePhoneCallState) {
    NSRTCAVLivePhoneCallState_Room_Local_Initlization  ,
    NSRTCAVLivePhoneCallState_Room_Local_Joined  ,
    NSRTCAVLivePhoneCallState_Room_Joined_UNBind,
    NSRTCAVLivePhoneCallState_Room_Local_Connecting,
    NSRTCAVLivePhoneCallState_Room_Local_Connected,
    NSRTCAVLivePhoneCallState_Room_Local_Leaved,
};


@interface NSRTCAVLivePhoneCallManager ()<NSRTCAVLiveConnectionProtocol>{
    NSString *_serverAddress;
    NSString *_roomAddress;
}
/*LivePhoneCallState*/
@property (assign, nonatomic) NSRTCAVLivePhoneCallState phoneCallState;

@property (strong, nonatomic) NSRTCAVLiveManager *avLiveManager;

@property (assign, nonatomic) NSRTCAVLiveMediaPhoneCallType callType;

@property (strong, nonatomic) AVCaptureSession *localCameraCaputeSession;
@property (assign, nonatomic) AVCaptureDevicePosition currCameraDevicePosition;
@property (assign, nonatomic) BOOL remoteAudioEnable;
@property (assign, nonatomic) BOOL localAudioEnable;

@end

@implementation NSRTCAVLivePhoneCallManager

static id _instance;

+ (instancetype)shareInstance {
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

+ (instancetype)managerWithCallType:(NSRTCAVLiveMediaPhoneCallType)callType{
    NSRTCAVLivePhoneCallManager *manager = [NSRTCAVLivePhoneCallManager shareInstance];
    manager.callType = callType;
    switch (callType) {
        case NSRTCAVLiveSingleAudioPhoneCall:
        case NSRTCAVLiveSingleVideoPhoneCall:
            [manager setupSingleChatRoomStatusMonitor];
            break;
        case NSRTCAVLiveGroupAudioPhoneCall:
        case NSRTCAVLiveGroupVideoPhoneCall:
            [manager setupGroupChatRoomStatusMonitor];
            break;
        default:
            break;
    }return manager;
}

- (void)setMediaChatRoom:(NSString *)mediaChatRoom{
    _mediaChatRoom = mediaChatRoom;
    _roomAddress = mediaChatRoom;
}
//初始化socket并且连接
- (void)connectServer:(NSString *)server port:(NSString *)port room:(NSString *)room userToken:(NSString*)token{
    _serverAddress = server;
    self.mediaChatRoom = room;
    NSString *serverURLPath = [NSString stringWithFormat:@"%@:%@",server,port];
    NSMutableDictionary *launchConfig = [NSMutableDictionary dictionaryWithDictionary:@{@"log": @NO,
                                                                                        @"forceNew" : @YES,
                                                                                        @"forcePolling": @NO,
                                                                                        @"reconnectAttempts":@(-1),
                                                                                        @"reconnectWait" : @(4),
                                                                                        @"forceWebsockets" : @NO}];
    if (token.length>0) {
        [launchConfig setValue:@{@"auth_token" : token} forKey:@"connectParams"];
    }
    [NSRTCClient shareClient].connectWithServerPathAndLaunchConfig(serverURLPath,launchConfig);
    
}
- (void)requestSingleChatRoomWithTargetUser:(NSString*)toUser success:(void(^)(NSString*roomId))successHandler fail:(void(^)(void))failHandler{
    if (self.callType == NSRTCAVLiveSingleAudioPhoneCall) {
        [NSRTCClient beginAudioChatFromUser:[NSRTCChatManager shareManager].user.currentUserID toUser:toUser success:successHandler fail:failHandler];
    }else{
        [NSRTCClient beginVideoChatFromUser:[NSRTCChatManager shareManager].user.currentUserID toUser:toUser success:successHandler fail:failHandler];
    }
    

}
/**
 *  加入房间
 *
 *  @param room 房间号
 */
- (void)joinAVChatRoom:(NSString *)room
{
    self.mediaChatRoom = room;
    
    [NSRTCClient shareClient].joinAVChatRoom(room);
}
/**
 *  拒接电话
 */
- (void)rejectSinglePhoneCall:(NSDictionary*)user{
    if (self.phoneCallState != NSRTCAVLivePhoneCallState_Room_Local_Leaved)  {
        NSString *roomId = [self->_roomAddress copy];
        if (user&&roomId) {
            [NSRTCClient shareClient].rejectAVPhoneCall(user,roomId);
        }
        [self.avLiveManager stopCaputre];
        [self.avLiveManager emptyPeerConnection];
        [self.avLiveManager emptyPeerConnectionFactory];
    }
}
/**
 *  退出房间
 */
- (void)exitRoom
{
    [NSRTCClient shareClient].leaveAVChatRoom(self.mediaChatRoom);
}
/**
 *  退出房间
 */
- (void)endPhoneCall{
    [self.avLiveManager stopCaputre];
    [self.avLiveManager emptyPeerConnection];
    [self.avLiveManager emptyPeerConnectionFactory];
}

/**
 *  加入群聊
 */
- (void)user:(NSString*)userId joinGroupChatWithRoomId:(NSString*)room{
//    [NSRTCClient shareClient].joinGroupChatRoom(room,userId);
}

/**
 *  离开群聊
 */
- (void)user:(NSString*)userId leaveGroupChatWithRoomId:(NSString*)room{
    [NSRTCClient shareClient].leaveGroupChatRoom(room,userId);
}
- (void)changeCamera{
    self.currCameraDevicePosition = (self.currCameraDevicePosition==AVCaptureDevicePositionBack)?AVCaptureDevicePositionFront:AVCaptureDevicePositionBack;
    [self.avLiveManager changeCameraPosition:self.currCameraDevicePosition];
}
- (void)changeRemoteVoiceEnable{
    //默认认为本地拨出
    NSString *from = @"";
    NSString *to = @"";
    if (self.singleCallFromUser) {
        from = self.singleCallFromUser;
    }
    
    if (self.singleCallToUser) {
        to = self.singleCallToUser;
    }
    self.remoteAudioEnable = !self.remoteAudioEnable;
    [self.avLiveManager changeRemoteMicrophoneEnabled:self.remoteAudioEnable withConnectinId:[NSRTCChatManager shareManager].user.currentUserID from:from to:to];
    
}
-(void)changeLocalVoiceEnable{
    self.localAudioEnable = !self.localAudioEnable;
    //默认认为本地拨出
     
    NSString *from = @"";
    NSString *to = @"";
    if (self.singleCallFromUser) {
        from = self.singleCallFromUser;
    }
    
    if (self.singleCallToUser) {
        to = self.singleCallToUser;
    }
    [self.avLiveManager changeLocalMicrophoneEnabled:self.localAudioEnable withConnectinId:[NSRTCChatManager shareManager].user.currentUserID from:from to:to];
}
//========
 //单聊
- (void)setupSingleChatRoomStatusMonitor{
    __weak typeof(self)weakSelf = self;
    __block BOOL isOtherJoined = NO;
    
    
    
    self.remoteAudioEnable = YES;
    self.localAudioEnable = YES;
//    NSRTCAVLiveSingleAudioPhoneCall  = 0,//音频电话单聊
//    NSRTCAVLiveSingleVideoPhoneCall,//视频电话单聊
//    NSRTCAVLiveGroupAudioPhoneCall,//音频电话群聊
//    NSRTCAVLiveGroupVideoPhoneCall,//视频电话群聊
    
    
    NSRTCAVLiveMediaServicesType servicesType = NSRTCAVLiveMediaServices_Audio_Video;
    switch (self.callType) {
        case NSRTCAVLiveSingleAudioPhoneCall:
        case NSRTCAVLiveGroupAudioPhoneCall:
            servicesType = NSRTCAVLiveMediaServices_Audio;
            break;
            

        case NSRTCAVLiveSingleVideoPhoneCall:
        case NSRTCAVLiveGroupVideoPhoneCall:
            servicesType = NSRTCAVLiveMediaServices_Audio_Video;
            
            break;
        default:
            break;
    }
    self.avLiveManager = [NSRTCAVLiveManager toolWithPeerConnectionDelegate:self mediaServicesType:servicesType];
    [NSRTCClient shareClient].onJoined(^(NSString*room,NSString*user,NSDictionary *responseData){
        //Start PeerConnection Initliazation && Begin set Local camera caputre
        self.currCameraDevicePosition = AVCaptureDevicePositionFront;
        weakSelf.phoneCallState = NSRTCAVLivePhoneCallState_Room_Local_Joined;
        if (weakSelf.callType ==NSRTCAVLiveSingleVideoPhoneCall) {
            weakSelf.localCameraCaputeSession = [self.avLiveManager startCaptureWithCameraPosition:AVCaptureDevicePositionFront mediaChatRoom:self->_roomAddress CompletionHandler:^(NSError *err) {
                if (!err) {
                    NSLog(@"Launch local camera Success");
                }else{
                    NSLog(@"Launch local camera Fail");
                }
            }];
        }else  if (weakSelf.callType ==NSRTCAVLiveSingleAudioPhoneCall) {
            [weakSelf.avLiveManager startAudioChatWithMediaChatRoom:self->_roomAddress CompletionHandler:^(NSError *err) {
                if (!err) {
                    NSLog(@"Launch local camera Success");
                }else{
                    NSLog(@"Launch local camera Fail");
                }
            }];
        }
      
        
    }).onOtherJoined(^(NSString*room,NSString*user,NSDictionary *responseData){
        isOtherJoined = YES;
        if (weakSelf.phoneCallState == NSRTCAVLivePhoneCallState_Room_Joined_UNBind) {
            [[NSRTCAVLiveManager shareInstance] checkPeerConnectionWithConnectionId:[NSRTCChatManager shareManager].user.currentUserID];
        }
        weakSelf.phoneCallState = NSRTCAVLivePhoneCallState_Room_Local_Connecting;
        //Try to build the connection  with remote user by the server,Set local Descpiton and send local offer to remote user by the server (server will repost it to remote user who will join the chat room next then begin the media negotiate)
        [weakSelf.avLiveManager startPeerConnectionWithConnectionId:[NSRTCChatManager shareManager].user.currentUserID setLocalSdpComplection:^(RTCSessionDescription *sessionDescp) {
            [[NSRTCAVLiveManager shareInstance]sendLocalSdpOffer:sessionDescp withRoomId:weakSelf.mediaChatRoom];
        }];
    }).onLeaved(^(NSString*room,NSString*user,NSDictionary *responseData){
        weakSelf.phoneCallState = NSRTCAVLivePhoneCallState_Room_Local_Leaved;
    }).onByed(^(NSString*room,NSString*user,NSDictionary *responseData){
        weakSelf.phoneCallState = NSRTCAVLivePhoneCallState_Room_Joined_UNBind;
        NSString *userId = responseData[@"userId"];
        if (!userId||userId.length==0 ) {
            userId = user;
        }
        if (!userId || userId.length == 0) {
            userId = self.singleCallFromUser;
        }
        [weakSelf.avLiveManager stopCaputre];
        [weakSelf.avLiveManager closePeerConnectionWithConnectionId:userId];
        [weakSelf perform:^(id weakSelf) {
            if ([[NSRTCAVLiveManager shareInstance]getCurrConnectionIds].count==0) {// 全部退出会议
                //        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
                if ([self.delegate respondsToSelector:@selector(callManager:leaveAllWithRoomId:)]) {
                    [self.delegate callManager:self leaveAllWithRoomId:self->_roomAddress];
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(callManager:byeWithConnectionId:)]) {
                    [self.delegate callManager:self byeWithConnectionId:userId];
                }
            }
        } after:0.5];
    }).onFulled(^(NSString*room,NSString*user,NSDictionary *responseData){
//        [weakSelf showStatus:@"Room is full"];
        weakSelf.phoneCallState = NSRTCAVLivePhoneCallState_Room_Local_Leaved;
        [weakSelf.avLiveManager stopCaputre];
        [weakSelf.avLiveManager emptyPeerConnection];
        [weakSelf.avLiveManager emptyPeerConnectionFactory];
        if ([weakSelf.delegate respondsToSelector:@selector(callManager:fullWithRoomId:)]) {
            [weakSelf.delegate callManager:weakSelf fullWithRoomId:self->_roomAddress];
        }
    }).onOffered(^(NSString*room,NSString*user,NSDictionary *responseData){
        NSString *caller = user;
        if (!caller || caller.length == 0) {
            caller = responseData[@"userId"];
        }
        
        if (!caller || caller.length == 0) {
            caller = self.singleCallFromUser;
        }
        if (caller) {
            [[NSRTCAVLiveManager shareInstance]setLocalSdpAnwserFromRemoteSdpOffer:responseData connectionId:caller complection:^(RTCSessionDescription *sdp) {
                [[NSRTCAVLiveManager shareInstance]sendLocalSdpAnwser:sdp withRoomId:weakSelf.mediaChatRoom];
            }];
        }
    }).onAnwsered(^(NSString*room,NSString*user,NSDictionary *responseData){
        NSMutableDictionary *remoteAnwserData = [NSMutableDictionary dictionaryWithDictionary:responseData];
        NSString *userId = remoteAnwserData[@"userId"];
        userId = [NSRTCChatManager shareManager].user.currentUserID;
        remoteAnwserData[@"userId"] = userId;
        [weakSelf.avLiveManager setRemoteSdpFromRemoteAnwser:remoteAnwserData];
    }).onCandidated(^(NSString*room,NSString*user,NSDictionary *responseData){
        NSMutableDictionary *responseCandidated = [NSMutableDictionary dictionaryWithDictionary:responseData];
        NSString *userId = responseCandidated[@"userId"];
        if (!userId||userId.length==0) {
            userId = user;
        }
        if (!userId||userId.length==0) {
            userId = [NSRTCChatManager shareManager].user.currentUserID;
        }
        if (!userId||userId.length==0) {
            userId = self.singleCallToUser;
        }
        if (!isOtherJoined) {
            userId = self.singleCallFromUser;
        }
        responseCandidated[@"userId"]  = userId;
        [weakSelf.avLiveManager addRemoteIceCandidate:responseCandidated];
    }).onReceivedVideoChatInvitationRejected(^(NSString*room){
        [weakSelf exitRoom];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"receivedAVChatConnectingRejectedOrHangout" object:nil];
      
        NSString *user = nil;
        if (weakSelf.singleCallFromUser) {
            user = weakSelf.singleCallFromUser;
        }
        if (!user||user.length ==0) {
            user = weakSelf.singleCallToUser;
        }
        if ([weakSelf.delegate respondsToSelector:@selector(callManager:rejectedWithConnectionId:)]) {
            [weakSelf.delegate callManager:weakSelf rejectedWithConnectionId:user];
        }
    });
}
//群聊

#pragma mark- 音视频群聊监听 待后台定义好后再完善
- (void)setupGroupChatRoomStatusMonitor{
    __weak typeof(self)weakSelf = self;
    self.avLiveManager = [NSRTCAVLiveManager toolWithPeerConnectionDelegate:self];
  
    
}

- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager closeConnectionWithId:(NSString*)Id{
    if ([self.delegate respondsToSelector:@selector(callManager:byeWithConnectionId:)]) {
        [self.delegate callManager:self byeWithConnectionId:Id];
    }
}


- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager didGenerateIceCandidate:(RTCIceCandidate*)candidate{
        NSString* weakMyRoom = self->_roomAddress;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"candidate"]= candidate.sdp;
            dict[@"id"]= candidate.sdpMid;
            dict[@"label"]= [NSNumber numberWithInteger:candidate.sdpMLineIndex];
            dict[@"type"]= @"candidate";
            [NSRTCClient shareClient].sendAVChatRoomMessage(weakMyRoom,dict);
        });
}

- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager addRemoteVideoTrackWithConnectionId:(NSString*)Id{
    RTCVideoTrack *track =  manager.remoteVideoTracksDict[Id];//单聊和群聊可以通用这个对象
    NSRTCAVLiveChatUser *user = [NSRTCAVLiveChatUser userWithConnectionId:Id];
    user.roomId = self->_roomAddress;
    user.remoteVideoTrack = track;
    user.localVideoTrack = manager.localVideoTrack;
    user.localCaputreSession = self.localCameraCaputeSession;
    if ([self.delegate respondsToSelector:@selector(callManager:joinedWithUser:)]) {
        [self.delegate callManager:self joinedWithUser:user];
    }
}
- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager addRemoteAudioTrackWithConnectionId:(NSString*)Id{
    
    RTCAudioTrack *track =  manager.remoteAudioTracksDict[Id];//单聊和群聊可以通用这个对象
    NSRTCAVLiveChatUser *user = [NSRTCAVLiveChatUser userWithConnectionId:Id];
    user.roomId = self->_roomAddress;
    user.remoteAudioTrack = track;
    user.localAudioTrack = manager.localAudioTrack;
    user.localCaputreSession = self.localCameraCaputeSession;
    user.localVideoView = self.avLiveManager.localVideoView;
    if ([self.delegate respondsToSelector:@selector(callManager:joinedWithUser:)]) {
        [self.delegate callManager:self joinedWithUser:user];
    }
}
- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager removeRemoteVideoTrackWithConnectionId:(NSString*)Id{
    
    
}
- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager removeRemoteAudioTrackWithConnectionId:(NSString*)Id{
    
    
}
@end
