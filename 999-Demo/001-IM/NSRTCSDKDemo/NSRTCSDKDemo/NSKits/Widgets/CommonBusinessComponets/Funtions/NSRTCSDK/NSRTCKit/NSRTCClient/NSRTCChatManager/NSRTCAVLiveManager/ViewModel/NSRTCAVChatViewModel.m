//
//  NSRTCAVChatViewModel.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCAVChatViewModel.h"

#import "NSRTCAVLivePhoneCallManager.h"
#import "NSRTCAVLiveChatUser.h"
#import <WebRTC/RTCCameraPreviewView.h>
#import <WebRTC/RTCEAGLVideoView.h>
#import <WebRTC/RTCVideoTrack.h>
#import <WebRTC/RTCAudioTrack.h>
//#import "NSRTCEAGLVideoView.h"
@interface NSRTCAVChatViewModel ()<NSRTCAVLivePhoneCallProtocol>

@end

@interface NSRTCAVChatViewModel ()
@property (copy, nonatomic) NSRTCAVChatHandler callUserJoinedChatroomHandler;
@property (copy, nonatomic) NSRTCAVChatHandler callUserByeChatroomHandler;
@property (copy, nonatomic) NSRTCAVChatHandler callUserRejectedChatroomInivitationHandler;
@property (copy, nonatomic) NSRTCAVChatHandler callChatroomFullAndJoinedFailedHandler;
@property (copy, nonatomic) NSRTCAVChatHandler callChatroomUserAllLeavedHandler;



@property (copy, nonatomic) NSRTCAVChatResponseHandler callUserJoinedChatroomResponseHandler;
@property (copy, nonatomic) NSRTCAVChatResponseHandler callUserByeChatroomResponseHandler;
@property (copy, nonatomic) NSRTCAVChatResponseHandler callUserRejectedChatroomInivitationResponseHandler;
@property (copy, nonatomic) NSRTCAVChatResponseHandler callChatroomFullAndJoinedFailedResponseHandler;
@property (copy, nonatomic) NSRTCAVChatResponseHandler callChatroomUserAllLeavedResponseHandler;

@end



@implementation NSRTCAVChatViewModel

+ (instancetype)modelWithViewCtrl:(NSViewController *)viewCtrl{
    NSRTCAVChatViewModel *viewModel = [super modelWithViewCtrl:viewCtrl];
    [viewModel setup];
    return viewModel;
}

- (void)setup{
    self.isConnected = NO;
}



- (void)callerSetupSingleChatRoomCallWithCallee{
    self.manager.singleCallToUser = self.callee;
    self.manager.mediaChatRoom = self.room;
    self.manager.delegate = self; 
    [self.manager requestSingleChatRoomWithTargetUser:self.callee success:^(NSString *roomId) {
        NSLog(@"房间创建成功");
        NSString *room = roomId;
        self.room = room;
        [[NSRTCAVLivePhoneCallManager shareInstance] joinAVChatRoom:room];
    } fail:^{
        // 服务器没有应答
        NSLog(@"房间创建失败");
    }];
}

- (void)calleeSetupSingleChatRoomCallWithCaller{
    self.isConnected = NO;
    self.manager.singleCallFromUser = self.caller;
    self.manager.mediaChatRoom = self.room;
    self.manager.delegate = self;
}



- (void)connect{
    self.isConnected = YES;
    [[NSRTCAVLivePhoneCallManager shareInstance] joinAVChatRoom:self.room];
}
- (void)disconnect{
    
}

- (void)rejecteAVPhoneCallInvitation{
    // 发送拒绝接听消息
    [NSRTCAVLivePhoneCallManager shareInstance].mediaChatRoom = self.room;
    NSDictionary *dict = @{@"user":self.caller};
    [[NSRTCAVLivePhoneCallManager shareInstance]rejectSinglePhoneCall:dict];
    [[NSRTCAVLivePhoneCallManager shareInstance]endPhoneCall];
}

- (void)hangoutAVPhoneCallConnectiong{
    [[NSRTCAVLivePhoneCallManager shareInstance]exitRoom];
    [[NSRTCAVLivePhoneCallManager shareInstance]endPhoneCall];
}
- (void)cancelAVPhoneCallRequest{
    
    NSDictionary *dict = @{@"user":self.callee};
    [[NSRTCAVLivePhoneCallManager shareInstance]rejectSinglePhoneCall:dict];
    [[NSRTCAVLivePhoneCallManager shareInstance]endPhoneCall];
   
}

- (void)changeRemoteVoiceEnable{
    [[NSRTCAVLivePhoneCallManager shareInstance]changeRemoteVoiceEnable];
}

- (void)changeLocalVoiceEnable{
    [[NSRTCAVLivePhoneCallManager shareInstance]changeLocalVoiceEnable];
}
- (void)changeCamera{
    [[NSRTCAVLivePhoneCallManager shareInstance]changeCamera];
}



- (NSRTCAVChatHandler)userJoinedChatroom{
    
    __weak typeof(self) weakSelf = self;
    self.callUserJoinedChatroomHandler  = ^NSRTCAVChatViewModel *(NSRTCAVChatResponseHandler responseHandler) {
        weakSelf.callUserJoinedChatroomResponseHandler = [responseHandler copy];
        return weakSelf;
    };
    return self.callUserJoinedChatroomHandler;
    
    
}
- (NSRTCAVChatHandler)userByeChatroom{
    __weak typeof(self) weakSelf = self;
    self.callUserByeChatroomHandler  = ^NSRTCAVChatViewModel *(NSRTCAVChatResponseHandler responseHandler) {
        weakSelf.callUserByeChatroomResponseHandler = [responseHandler copy];
        return weakSelf;
    };
    return self.callUserByeChatroomHandler;
}
- (NSRTCAVChatHandler)userRejectedChatroomInivitation{
    __weak typeof(self) weakSelf = self;
    self.callUserRejectedChatroomInivitationHandler  = ^NSRTCAVChatViewModel *(NSRTCAVChatResponseHandler responseHandler) {
        weakSelf.callUserRejectedChatroomInivitationResponseHandler = [responseHandler copy];
        return weakSelf;
    };
    return self.callUserRejectedChatroomInivitationHandler;
}
- (NSRTCAVChatHandler)chatroomFullAndJoinedFailed{
    __weak typeof(self) weakSelf = self;
    self.callChatroomFullAndJoinedFailedHandler  = ^NSRTCAVChatViewModel *(NSRTCAVChatResponseHandler responseHandler) {
        weakSelf.callChatroomFullAndJoinedFailedResponseHandler = [responseHandler copy];
        return weakSelf;
    };
    return self.callChatroomFullAndJoinedFailedHandler;
}
- (NSRTCAVChatHandler)chatroomUserAllLeaved{
    __weak typeof(self) weakSelf = self;
    self.callChatroomUserAllLeavedHandler  = ^NSRTCAVChatViewModel *(NSRTCAVChatResponseHandler responseHandler) {
        weakSelf.callChatroomUserAllLeavedResponseHandler = [responseHandler copy];
        return weakSelf;
    };
    return self.callChatroomUserAllLeavedHandler;
}


#pragma -NSRTCAVLivePhoneCallCallProtocol
- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager joinedWithUser:(NSRTCAVLiveChatUser*)user{
    
    !self.callUserJoinedChatroomResponseHandler?:self.callUserJoinedChatroomResponseHandler(user);
}
- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager byeWithConnectionId:(NSString*)connectionId{
    NSRTCAVLiveChatUser*user = [[NSRTCAVLiveChatUser alloc]init];
    user.connectionId = connectionId;
    !self.callUserByeChatroomResponseHandler?:self.callUserByeChatroomResponseHandler(user);
}
- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager rejectedWithConnectionId:(NSString*)connectionId{
    NSRTCAVLiveChatUser*user = [[NSRTCAVLiveChatUser alloc]init];
    user.connectionId = connectionId;
    !self.callUserRejectedChatroomInivitationResponseHandler?:self.callUserRejectedChatroomInivitationResponseHandler(user);
    
}
- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager fullWithRoomId:(NSString*)roomId{
    NSRTCAVLiveChatUser*user = [[NSRTCAVLiveChatUser alloc]init];
    user.roomId = roomId;
    !self.callChatroomFullAndJoinedFailedHandler?:self.callChatroomFullAndJoinedFailedResponseHandler(user);
}
- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager leaveAllWithRoomId:(NSString*)roomId{
    NSRTCAVLiveChatUser*user = [[NSRTCAVLiveChatUser alloc]init];
    user.roomId = roomId;
    !self.callChatroomUserAllLeavedResponseHandler?:self.callChatroomUserAllLeavedResponseHandler(user);
}


@end
