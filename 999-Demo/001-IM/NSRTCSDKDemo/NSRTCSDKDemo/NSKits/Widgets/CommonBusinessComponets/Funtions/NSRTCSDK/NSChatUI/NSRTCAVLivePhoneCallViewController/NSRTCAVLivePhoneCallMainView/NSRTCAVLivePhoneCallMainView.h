//
//  NSRTCAVLivePhoneCallMainView.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/19.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <NSRTC/NSRTCAVLivePhoneCallManager.h>
//#import <NSRTC/NSRTCAVLiveChatUser.h>
//#import <NSRTC/NSRTCAVChatViewModel.h>
#import "NSRTCAVLivePhoneCallManager.h"
#import "NSRTCAVLiveChatUser.h"
#import "NSRTCAVChatViewModel.h"

#import "NSRTCAVLivePhoneCallSingleChatView.h"

#import "NSRTCAVLiveChatView.h"

#import <WebRTC/RTCCameraPreviewView.h>
#import <WebRTC/RTCEAGLVideoView.h>
#import <WebRTC/RTCVideoTrack.h>
#import <WebRTC/RTCAudioTrack.h>


//#import "NSCategoties.h"

#import "NSRTCEAGLVideoView.h"
#import "NSRTCCameraPreviewView.h"
#import "NSVerticalButton.h"

#import "NSLivePhoneCallBanner.h"

//#import "NSRTCAVChatViewModel.h"

typedef NS_ENUM(NSUInteger,NSRTCAVLivePhoneCallCallType) {
    NSRTCAVLivePhoneCallAudioCall  = 0,
    NSRTCAVLivePhoneCallVideoCall,
};

typedef NS_ENUM(NSUInteger,NSRTCAVLivePhoneCallCallUserType) {
    NSRTCAVLivePhoneCallCaller  = 0,
    NSRTCAVLivePhoneCallCallee
};

typedef NS_ENUM(NSUInteger,NSRTCAVLivePhoneCallCallChatRoomType) {
    NSRTCAVLivePhoneCallCall_SingleChatRoom  = 0,
    NSRTCAVLivePhoneCallCall_GroupChatRoom
};


@interface NSRTCAVLivePhoneCallMainView : UIView


+ (instancetype)mainViewWithSuperView:(UIView*)superView;


@property (strong, nonatomic) NSRTCAVLivePhoneCallSingleChatView *singleCallView ;

@property (strong, nonatomic) NSRTCEAGLVideoView *remoteVideoView;
@property (strong, nonatomic) NSLivePhoneCallBanner *callBanner;



@property (assign, nonatomic) BOOL isConnected;
@property (strong, nonatomic) NSString *callee ;
@property (strong, nonatomic) NSString *caller ;
@property (strong, nonatomic) NSArray *callees ;

@property (strong, nonatomic) NSString *room;

@property (strong, nonatomic) NSTimer *audioConnectingTimer;
@property (assign, nonatomic) NSTimeInterval audioChatTi;
//Desc:
@property (strong, nonatomic) NSRTCAVChatViewModel *viewModel;

@property (assign, nonatomic) NSRTCAVLivePhoneCallCallType callType;
@property (assign, nonatomic) NSRTCAVLivePhoneCallCallUserType callUserType;
@property (assign, nonatomic) NSRTCAVLivePhoneCallCallChatRoomType chatRoomType;

//Desc:
@property (strong, nonatomic) NSRTCBaseViewController* superPageCtrl;

- (void)viewWillAppear;

- (void)bindViewModel;

- (void)setupUIWithCallUserType:(NSRTCAVLivePhoneCallCallUserType)callUserType chatRoomType:(NSRTCAVLivePhoneCallCallChatRoomType)chatRoom callType:(NSRTCAVLivePhoneCallCallType)callType;


- (void)audioCounting:(NSTimer*)timer;

- (void)updateFrame:(CGRect)newFrame withSuperView:(UIView*)superView;


@end
