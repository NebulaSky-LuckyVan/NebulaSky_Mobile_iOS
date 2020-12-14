//
//  NSRTCAVChatViewModel.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCViewModel.h"
 

#import "NSRTCAVLivePhoneCallManager.h"

@class NSRTCAVChatViewModel;
@class NSRTCAVLiveChatUser;

typedef void (^NSRTCAVChatResponseHandler)(NSRTCAVLiveChatUser*liveChatUser);
typedef NSRTCAVChatViewModel*(^NSRTCAVChatHandler)(NSRTCAVChatResponseHandler responseHandler);

@interface NSRTCAVChatViewModel : NSRTCViewModel
//Desc:
@property (strong, nonatomic) NSRTCAVLivePhoneCallManager *manager;

@property (assign, nonatomic) BOOL isConnected;
@property (strong, nonatomic) NSString *callee ;
@property (strong, nonatomic) NSString *caller ;
@property (strong, nonatomic) NSArray *callees ;

@property (strong, nonatomic) NSString *room;


//Desc:
@property (strong, nonatomic) NSTimer *handleBannerTimer;
@property (assign, nonatomic) NSTimeInterval cutDownTi;


@property (strong, nonatomic) NSTimer *audioConnectingTimer;
@property (assign, nonatomic) NSTimeInterval audioChatTi;

- (void)callerSetupSingleChatRoomCallWithCallee;

- (void)calleeSetupSingleChatRoomCallWithCaller;


- (void)connect;
- (void)disconnect;

- (void)rejecteAVPhoneCallInvitation;

- (void)hangoutAVPhoneCallConnectiong;
- (void)cancelAVPhoneCallRequest;

- (void)changeRemoteVoiceEnable;
- (void)changeLocalVoiceEnable;
- (void)changeCamera;



- (NSRTCAVChatHandler)userJoinedChatroom;
- (NSRTCAVChatHandler)userByeChatroom;
- (NSRTCAVChatHandler)userRejectedChatroomInivitation;
- (NSRTCAVChatHandler)chatroomFullAndJoinedFailed;
- (NSRTCAVChatHandler)chatroomUserAllLeaved;



@end
 
