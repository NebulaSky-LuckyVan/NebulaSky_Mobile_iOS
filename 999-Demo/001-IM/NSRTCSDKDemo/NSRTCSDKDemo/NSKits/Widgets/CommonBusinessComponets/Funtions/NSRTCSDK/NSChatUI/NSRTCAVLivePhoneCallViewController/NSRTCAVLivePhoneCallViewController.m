//
//  NSRTCAVLivePhoneCallViewController.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCAVLivePhoneCallViewController.h"

//#import <NSRTC/NSRTCAVLivePhoneCallManager.h>
// 
//#import <NSRTC/NSRTCAVLiveChatUser.h>

#import "NSRTCAVLivePhoneCallManager.h"
#import "NSRTCAVLiveChatUser.h"

#import "NSRTCAVLivePhoneCallSingleChatView.h"

#import "NSRTCAVLiveChatView.h"

#import <WebRTC/RTCCameraPreviewView.h>
#import <WebRTC/RTCEAGLVideoView.h>
#import <WebRTC/RTCVideoTrack.h>
#import <WebRTC/RTCAudioTrack.h>


//#import <NSRTC/NSCategoties.h>

#import "NSCategories.h"

#import "NSRTCEAGLVideoView.h"
#import "NSRTCCameraPreviewView.h"
#import "NSVerticalButton.h"

#import "NSLivePhoneCallBanner.h"

//#import "NSRTCAVChatViewModel.h"


@interface NSRTCAVLivePhoneCallViewController ()
//Desc:
@property (strong, nonatomic) NSRTCAVLivePhoneCallMainView *mainView;

@end


@implementation NSRTCAVLivePhoneCallViewController



+ (instancetype)takePhoneCall:(NSRTCAVLivePhoneCallCallType)callType toUser:(NSString *)callee{
    NSRTCAVLivePhoneCallViewController *livePoneCallPage = [[NSRTCAVLivePhoneCallViewController alloc]init];
    livePoneCallPage.mainView.callUserType = NSRTCAVLivePhoneCallCaller;
    livePoneCallPage.mainView.callType = callType;
    livePoneCallPage.mainView.chatRoomType = NSRTCAVLivePhoneCallCall_SingleChatRoom;
    livePoneCallPage.mainView.callee = callee;
    
    return livePoneCallPage;
}
+ (instancetype)takeGroupPhoneCall:(NSRTCAVLivePhoneCallCallType)callType toUsers:(NSArray *)callees{
    NSRTCAVLivePhoneCallViewController *livePoneCallPage = [[NSRTCAVLivePhoneCallViewController alloc]init];
    livePoneCallPage.mainView.callUserType = NSRTCAVLivePhoneCallCaller;
    livePoneCallPage.mainView.callType = callType;
    livePoneCallPage.mainView.chatRoomType = NSRTCAVLivePhoneCallCall_GroupChatRoom;
    livePoneCallPage.mainView.callees = callees;
    return livePoneCallPage;
}

+ (instancetype)receivePhoneCall:(NSRTCAVLivePhoneCallCallType)callType phoneCallInfo:(NSDictionary *)phoneCallInfo{
    NSRTCAVLivePhoneCallViewController *livePoneCallPage = [[NSRTCAVLivePhoneCallViewController alloc]init];
    livePoneCallPage.mainView.callUserType = NSRTCAVLivePhoneCallCallee;
    livePoneCallPage.mainView.callType = callType;
    livePoneCallPage.mainView.chatRoomType = [phoneCallInfo[@"chat_type"] integerValue];
    livePoneCallPage.mainView.caller =  phoneCallInfo[@"from_user"] ;
    livePoneCallPage.mainView.room = phoneCallInfo[@"room"];
    
    return livePoneCallPage;
}

- (NSRTCAVLivePhoneCallMainView *)mainView{
    if (!_mainView) {
        _mainView = [NSRTCAVLivePhoneCallMainView mainViewWithSuperView:self.view] ;
        _mainView.superPageCtrl = self;
    }
    return _mainView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)bindViewModel{
    [self.mainView bindViewModel];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainView viewWillAppear];
}
- (void)dealloc{
    self.mainView = nil;
}
@end
