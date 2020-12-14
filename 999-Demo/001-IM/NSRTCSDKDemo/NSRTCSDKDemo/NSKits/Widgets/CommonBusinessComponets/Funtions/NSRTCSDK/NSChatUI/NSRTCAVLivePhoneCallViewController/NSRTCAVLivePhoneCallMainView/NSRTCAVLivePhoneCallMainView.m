//
//  NSRTCAVLivePhoneCallMainView.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/19.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCAVLivePhoneCallMainView.h"

@interface NSRTCAVLivePhoneCallMainView () <RTCVideoViewDelegate>

@end
@implementation NSRTCAVLivePhoneCallMainView
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
//===================================//
+ (instancetype)mainViewWithSuperView:(UIView*)superView{
    NSRTCAVLivePhoneCallMainView *mainView = [[NSRTCAVLivePhoneCallMainView alloc]init];
    [superView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(superView);
    }];
    [mainView setup];
    return mainView;
}
- (void)setup{
    [self removeAllSubviews];
     self.audioChatTi = 0;
    [self setBackgroundColor: [UIColor blackColor]];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"receivedAVChatConnectingRejectedOrHangout" object:nil]subscribeNext:^(NSNotification *notice) {
        if (self.superview != self.superPageCtrl.view||!self.superPageCtrl) {
            [self disconnect];
        }
    }];
}
- (void)updateFrame:(CGRect)newFrame withSuperView:(UIView*)superView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (superView !=self.superview) {
            if (self.superPageCtrl) {
                [self.superPageCtrl dismissViewControllerAnimated:YES completion:NULL];
            }
            [self removeFromSuperview];
            [superView addSubview:self];
            CGRect rect = newFrame;
            
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            CGFloat hwRadius = screenSize.height*1.0/screenSize.width;
            rect = CGRectMake(superView.width-rect.size.width, rect.origin.y, rect.size.width, rect.size.width*hwRadius);
            [self.callBanner updateFrameTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)];
           
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(rect.origin.x));
                make.top.equalTo(@(rect.origin.y));
                make.width.equalTo(@(rect.size.width));
                make.height.equalTo(@(rect.size.height));
            }];
        }else{
            CGRect rect = newFrame;
           
          
            
            
          
            
            [self.callBanner setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)];
           
            if (rect.size.width == kKeyWindow.width) {
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@(rect.origin.x));
                    make.top.equalTo(@(rect.origin.y));
                    make.width.equalTo(@(rect.size.width));
                    make.height.equalTo(@(rect.size.height));
                }];
                for (UIView *sbView in self.callBanner.subviews) {
                    [sbView setHidden:NO];
                }
            }else{
                CGSize screenSize = [UIScreen mainScreen].bounds.size;
                CGFloat hwRadius = screenSize.height*1.0/screenSize.width;
                rect = CGRectMake(superView.width-rect.size.width, rect.origin.y, rect.size.width, rect.size.width*hwRadius);
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@(rect.origin.x));
                    make.top.equalTo(@(rect.origin.y));
                    make.width.equalTo(@(rect.size.width));
                    make.height.equalTo(@(rect.size.height));
                }];
                
                
                for (UIView *sbView in self.callBanner.subviews) {
                    [sbView setHidden:YES];
                    [self.callBanner addSubview:self.callBanner.bigScreenBtn];
                    [self.callBanner.bigScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.width.height.equalTo(self.callBanner);
                    }];
                }
            }
          
        }
        
    });
}


- (void)bindViewModel{
    self.viewModel  = [NSRTCAVChatViewModel modelWithViewCtrl:self.superPageCtrl];
    self.viewModel.userJoinedChatroom(^(NSRTCAVLiveChatUser*user){
        self.viewModel.isConnected = YES;
        if (self.callType==NSRTCAVLivePhoneCallAudioCall) {
            if (self.chatRoomType == NSRTCAVLivePhoneCallCall_SingleChatRoom) {//单聊
                NSLog(@"%s",__func__);
            }else{//群聊
                
            }
            if (self.callUserType == NSRTCAVLivePhoneCallCallee) {
                [self.callBanner updateCalleeHandlerBtnFrame];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.callBanner.headMenuBanner setAlpha:0];
                [self.callBanner.actionMenuBanner setAlpha:0];
            });
            
            
            self.audioConnectingTimer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(audioCounting:) userInfo:nil repeats:YES];
            
            
            
        }else if (self.callType==NSRTCAVLivePhoneCallVideoCall) {
            if (self.chatRoomType == NSRTCAVLivePhoneCallCall_SingleChatRoom) {//单聊
                if (!self.singleCallView) {
                    [self setupSingleChatUI];
                }
                [self.singleCallView setHidden:NO];
                
                RTCCameraPreviewView *localVideoView = user.localVideoView;
                [localVideoView setFrame:self.singleCallView.localChatView.bounds];
                [self.singleCallView.localChatView addSubview:localVideoView];
                [self bringSubviewToFront:self.singleCallView];
                NSRTCEAGLVideoView *remoteVideoView = [[NSRTCEAGLVideoView alloc]initWithFrame:self.singleCallView.remoteChatView.bounds];
                [user.remoteVideoTrack addRenderer:remoteVideoView];
                remoteVideoView.delegate =  self;
                [self.singleCallView.remoteChatView removeAllSubviews];
                [self.singleCallView.remoteChatView addSubview:remoteVideoView];
                self.remoteVideoView = remoteVideoView;
                if (self.callBanner != (NSLivePhoneCallBanner*)self.singleCallView.superview.superview ) {
                    [self.callBanner removeFromSuperview];
                    self.callBanner = (NSLivePhoneCallBanner*)self.singleCallView.superview.superview;
                }
                if (!self.callBanner.superview) {
                    [self addSubview:self.callBanner];
                    [self.callBanner mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.width.height.equalTo(self);
                    }];
                }
                [remoteVideoView tapCallBackHandler:^{
                    if (!self.viewModel.isConnected) {return ;}
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }];
                
            }else{//群聊
                
            }
            if (self.callUserType == NSRTCAVLivePhoneCallCallee) {
                [self.callBanner updateCalleeHandlerBtnFrame];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.callBanner.headMenuBanner setAlpha:0];
                [self.callBanner.actionMenuBanner setAlpha:0];
            });
        }
        
        
    }).userByeChatroom(^(NSRTCAVLiveChatUser*user){
        if (self.chatRoomType == NSRTCAVLivePhoneCallCall_SingleChatRoom) {
           [self disconnect];
        }
    }).userRejectedChatroomInivitation(^(NSRTCAVLiveChatUser*user){
        if (self.chatRoomType == NSRTCAVLivePhoneCallCall_SingleChatRoom) {
           [self disconnect];
        }
       
    }).chatroomFullAndJoinedFailed(^(NSRTCAVLiveChatUser*user){
        
        
    }).chatroomUserAllLeaved(^(NSRTCAVLiveChatUser*user){
        
        if (self.chatRoomType == NSRTCAVLivePhoneCallCall_SingleChatRoom) {
            [self.singleCallView removeFromSuperview];
        }
        
        [self disconnect];
    });
    
}
- (void)setupUIWithCallUserType:(NSRTCAVLivePhoneCallCallUserType)callUserType chatRoomType:(NSRTCAVLivePhoneCallCallChatRoomType)chatRoom callType:(NSRTCAVLivePhoneCallCallType)callType{
    
    if (callUserType == NSRTCAVLivePhoneCallCaller) {
        
        self.callBanner = [NSLivePhoneCallBanner bannerWithUserType:NSLivePhoneCallCaller chatRoom:(self.callType == NSRTCAVLivePhoneCallAudioCall)?NSLivePhoneCallAudioChatRoom:NSLivePhoneCallVideoChatRoom userName:self.callee userDesc:@"北京易诚互动网络技术有限公司"];
        [self addSubview:self.callBanner];
    }else if (callUserType == NSRTCAVLivePhoneCallCallee){
        self.callBanner = [NSLivePhoneCallBanner bannerWithUserType:NSLivePhoneCallCallee chatRoom:(self.callType == NSRTCAVLivePhoneCallAudioCall)?NSLivePhoneCallAudioChatRoom:NSLivePhoneCallVideoChatRoom userName:self.caller userDesc:@"北京易诚互动网络技术有限公司"];
        [self addSubview:self.callBanner];
    }
    [self.callBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self);
    }];
    
    [self.callBanner.phoneCallMenuHandlerSbj subscribeNext:^(NSNumber *menuActionBtn) {
        NSLivePhoneCallMenuBtn btn = [menuActionBtn integerValue];
        switch (btn) {
            case NSLivePhoneCallMenuBtn_Hangout:{
                [self disconnect];
            } break;
                
            case NSLivePhoneCallMenuBtn_Anwser:{
                [self.viewModel connect];
            } break;
                
            case NSLivePhoneCallMenuBtn_Voice:{
                [self.viewModel changeLocalVoiceEnable];
            } break;
                
            case NSLivePhoneCallMenuBtn_Camera:{
                
                [self.viewModel changeCamera];
            } break;
                
            case NSLivePhoneCallMenuBtn_UserAvator:{
                NSLog(@"%s",__func__);
            } break;
                
                
            case NSLivePhoneCallMenuBtn_SmallScreen:{
                [self updateFrame:CGRectMake(kKeyWindow.width-80, 150, 80, 120) withSuperView:kKeyWindow];
                [self.superPageCtrl dismissViewControllerAnimated:YES completion:NULL];
                self.superPageCtrl = nil;
            } break;
            case NSLivePhoneCallMenuBtn_HandsFree:{//免提
                NSError *error = nil;
                if ([AVAudioSession sharedInstance].categoryOptions == AVAudioSessionCategoryOptionDefaultToSpeaker) {
                    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
                    if (!error) {
                        NSLog(@"免提默认模式成功");
                    }else{
                        NSLog(@"免提默认模式失败:%@",error);
                    }

                }else{
                    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
                    if (!error) {
                        NSLog(@"免提切换成功");
                    }else{
                        NSLog(@"免提切换失败:%@",error);
                    }

                }
                
            }break;
            default:
                break;
        }
    }];
    [self.callBanner.handlerBanner setSelected:YES];
    [self.callBanner.handlerBanner action:^(UIButton *sendor) {
        sendor.selected = !sendor.selected;
        if (!sendor.selected) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.callBanner.headMenuBanner setAlpha:1];
                [self.callBanner.actionMenuBanner setAlpha:1];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.callBanner.headMenuBanner setAlpha:0];
                [self.callBanner.actionMenuBanner setAlpha:0];
            });
        }
        
    }];
}
- (void)viewWillAppear{
    [self setupUIWithCallUserType:self.callUserType chatRoomType:self.chatRoomType callType:self.callType];
    self.viewModel.callee = self.callee;
    self.viewModel.callees = self.callees;
    self.viewModel.caller = self.caller;
    self.viewModel.room = self.room;
    if (self.callUserType == NSRTCAVLivePhoneCallCaller) { // 主动发起通话
        if (self.chatRoomType == NSRTCAVLivePhoneCallCall_SingleChatRoom) {
            if (self.callType == NSRTCAVLivePhoneCallAudioCall) {
                //            manager =  [NSRTCAVLivePhoneCallManager managerWithCallType:NSRTCAVLiveSingleAudioPhoneCall];
                self.viewModel.manager  = [NSRTCAVLivePhoneCallManager managerWithCallType:NSRTCAVLiveSingleAudioPhoneCall];
            }else if (self.callType == NSRTCAVLivePhoneCallVideoCall){
                //            manager =  [NSRTCAVLivePhoneCallManager managerWithCallType:NSRTCAVLiveSingleVideoPhoneCall];
                self.viewModel.manager  = [NSRTCAVLivePhoneCallManager managerWithCallType:NSRTCAVLiveSingleVideoPhoneCall];
            }
            [self.viewModel callerSetupSingleChatRoomCallWithCallee];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setupSingleChatUI];
            });
        }else{
            
            
            
        }
        
    }  else { // 被发起通话
        if (self.chatRoomType == NSRTCAVLivePhoneCallCall_SingleChatRoom) {
            if (self.callType == NSRTCAVLivePhoneCallAudioCall) {
                self.viewModel.manager = [NSRTCAVLivePhoneCallManager managerWithCallType:NSRTCAVLiveSingleAudioPhoneCall];
            }else if (self.callType == NSRTCAVLivePhoneCallVideoCall){
                self.viewModel.manager = [NSRTCAVLivePhoneCallManager managerWithCallType:NSRTCAVLiveSingleVideoPhoneCall];
            }
            
            [self.viewModel calleeSetupSingleChatRoomCallWithCaller];
        }else{
            
            
            
        }
        
    }
}
- (void)setupSingleChatUI{
    self.singleCallView = [NSRTCAVLivePhoneCallSingleChatView callViewWithBackground:nil callerHeadPhoto:nil calleeHeadPhoto:nil callViewFrame:self.frame];
    [self.callBanner.videoChatViewBanner addSubview:self.singleCallView];
    [self.singleCallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self.callBanner);
    }];
    [self.singleCallView setHidden:YES];
}


- (void)disconnect{
    [self.audioConnectingTimer invalidate];
    self.audioConnectingTimer = nil;
    void (^CallDisconnectHandler)(void) = ^(void){
        
        if (self.chatRoomType == NSRTCAVLivePhoneCallCall_SingleChatRoom) {
            if (self.viewModel.isConnected == NO && self.callUserType == NSRTCAVLivePhoneCallCallee) { // 被请求通话,未接听通话
                // 发送拒绝接听消息
                [self.viewModel userRejectedChatroomInivitation];
            } else {
                if (self.viewModel.isConnected) {//接通后挂断电话
                    [self.viewModel hangoutAVPhoneCallConnectiong];
                }else{//未接通,发起者 中断
                    [self.viewModel cancelAVPhoneCallRequest];
                }
            }
        }else{
            
        }

        
    };
    if (self.superPageCtrl) {
        [self.superPageCtrl dismissViewControllerAnimated:YES completion:^{
            CallDisconnectHandler();
        }];
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.center = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                CallDisconnectHandler();
            }];
        });
    }

}



- (void)audioCounting:(NSTimer*)timer{
    if (timer != self.audioConnectingTimer||!self.audioConnectingTimer) {
        [timer invalidate];
        timer = nil;
    }
    self.audioChatTi += 1;
    NSUInteger min = self.audioChatTi/60;
    NSUInteger sec = self.audioChatTi  - min*60;
    NSString *time = [NSString stringWithFormat:@"%.2zd:%.2zd",min,sec];
    self.callBanner.callingStatusLb.text = time;
}


- (void)videoView:(id<RTCVideoRenderer>)videoView didChangeVideoSize:(CGSize)size{
    if (videoView== self.remoteVideoView && self.chatRoomType == NSRTCAVLivePhoneCallCall_SingleChatRoom) {
        CGRect bounds = self.bounds;
        if (size.width > 0 && size.height > 0) {
            // Aspect fill remote video into bounds.
            CGRect remoteVideoFrame =
            AVMakeRectWithAspectRatioInsideRect(size, bounds);
            CGFloat scale = 1;
            if (remoteVideoFrame.size.width > remoteVideoFrame.size.height) {
                // Scale by height.
                scale = bounds.size.height / remoteVideoFrame.size.height;
            } else {
                // Scale by width.
                scale = bounds.size.width / remoteVideoFrame.size.width;
            }
            remoteVideoFrame.size.height *= scale;
            remoteVideoFrame.size.width *= scale;
            self.remoteVideoView.frame = remoteVideoFrame;
            self.remoteVideoView.center =
            CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        } else {
            self.remoteVideoView.frame = bounds;
        }
    }
}
- (void)dealloc{
    [self.viewModel disconnect];
    [self.audioConnectingTimer invalidate];
    self.audioConnectingTimer  = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
