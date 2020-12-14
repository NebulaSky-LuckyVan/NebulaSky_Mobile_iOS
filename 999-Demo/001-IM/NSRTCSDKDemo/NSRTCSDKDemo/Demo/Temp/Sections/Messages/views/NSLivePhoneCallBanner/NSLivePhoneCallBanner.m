//
//  NSLivePhoneCalllBanner.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/13.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSLivePhoneCallBanner.h"
#import "NSVerticalButton.h"
#import "NSRTCAVLivePhoneCallMainView.h"

//Common
@interface NSLivePhoneCallBanner ()

@property (assign, nonatomic) NSLivePhoneCallUser user;
@property (assign, nonatomic) NSLivePhoneCallChatRoom room;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userDesc;

@property (strong, nonatomic) UIImageView *connectionBgImgView;
@property (strong, nonatomic) UIButton *smallScreenBtn;
@property (strong, nonatomic) UIButton *titleViewBtn;
@property (strong, nonatomic) UIButton *calleeOrCallerAvatorBtn;
@property (strong, nonatomic) UILabel *calleeOrCallerNameLb;
@property (strong, nonatomic) UILabel *calleeOrCallerDescLb;
@property (strong, nonatomic) UILabel *callingStatusLb;

@property (strong, nonatomic) NSVerticalButton *hangoutBtn;


@property (strong, nonatomic) UIView *headMenuBanner;
@property (strong, nonatomic) UIView *userInfoBanner;
@property (strong, nonatomic) UIButton *videoChatViewBanner;
@property (strong, nonatomic) UIView *actionMenuBanner;
@property (strong, nonatomic) UIButton *handlerBanner;
@property (strong, nonatomic) UIButton *bigScreenBtn;
@end

//Callee
@interface NSLivePhoneCallBanner ()
@property (strong, nonatomic) NSVerticalButton *anwserBtn;

@end

//Caller
@interface NSLivePhoneCallBanner ()
@property (strong, nonatomic) NSVerticalButton *voiceCloseOrOpenBtn;
@property (strong, nonatomic) NSVerticalButton *cameraBtn;
@property (strong, nonatomic) NSVerticalButton *handsFreeBtn;

@end

@implementation NSLivePhoneCallBanner

+ (instancetype)bannerWithUserType:(NSLivePhoneCallUser)user chatRoom:(NSLivePhoneCallChatRoom)room userName:(NSString*)name userDesc:(NSString*)desc{
    NSLivePhoneCallBanner *banner = [[NSLivePhoneCallBanner alloc]init];
    banner.room = room;
    banner.user = user;
    banner.userName = name;
    banner.userDesc = desc;
    [banner setup];
    return banner;
}

- (void)setup{
    if (self.room == NSLivePhoneCallVideoChatRoom) {
        [self videoChatRoom];
    }else if (self.room == NSLivePhoneCallAudioChatRoom){
        [self audioChatRoom];
    }
}
- (void)audioChatRoom{
    void (^CallAddCommonInfoUIHandler)(UIView *) = ^(UIView *banner){
        self.connectionBgImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.connectionBgImgView setImage:[UIImage imageNamed:@"AVPhoneCallBg"]];
        [banner addSubview:self.connectionBgImgView];
        [self.connectionBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.height.equalTo(banner);
        }];
        
        self.userInfoBanner = [[UIView alloc]init];
        [banner addSubview:self.userInfoBanner];
        [self.userInfoBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(banner);
            make.top.equalTo(@(100));
            make.bottom.equalTo(banner).offset(95);
        }];
        
        
        
        self.videoChatViewBanner = [[UIButton alloc]init];
        [self.videoChatViewBanner setBackgroundColor:[UIColor clearColor]];
        [banner addSubview:self.videoChatViewBanner];
        [self.videoChatViewBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.height.equalTo(banner);
        }];
        
        
        
        self.handlerBanner = [[UIButton alloc]init];
        [self.handlerBanner setBackgroundColor:[UIColor clearColor]];
        [banner addSubview:self.handlerBanner];
        [self.handlerBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.height.equalTo(banner);
        }];
        
        
        self.headMenuBanner = [[UIView alloc]init];
        [self.handlerBanner addSubview:self.headMenuBanner];
        [self.headMenuBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(banner);
            make.height.equalTo(@(100));
        }];
        
        
        
        self.actionMenuBanner = [[UIView alloc]init];
        [self.actionMenuBanner setBackgroundColor:[UIColor clearColor]];
        [self.handlerBanner addSubview:self.actionMenuBanner];
        [self.actionMenuBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.handlerBanner);
            make.height.equalTo(@(100));
        }];
        
        
        
        self.smallScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.smallScreenBtn setBackgroundImage:[UIImage imageNamed:@"sq"] forState:UIControlStateNormal];
        [self.smallScreenBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_SmallScreen)];
        }];
        [self.headMenuBanner addSubview:self.smallScreenBtn];
        [self.smallScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(25));
            make.width.equalTo(@(25));
            make.left.equalTo(@(15));
            make.top.equalTo(@(35));
        }];
        
        self.titleViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleViewBtn setImage:[UIImage imageNamed:@"aq"] forState:UIControlStateNormal];
        [self.titleViewBtn setTitle:@"加密语音通话" forState:UIControlStateNormal];
        self.titleViewBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.headMenuBanner addSubview:self.titleViewBtn];
        [self.titleViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(25));
            make.width.equalTo(@(200));
            make.centerX.equalTo(banner);
            make.centerY.equalTo(self.smallScreenBtn);
        }];
        
        
        self.calleeOrCallerAvatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.calleeOrCallerAvatorBtn setBackgroundImage:[UIImage imageNamed:@"tx"] forState:UIControlStateNormal];
        [self.userInfoBanner addSubview:self.calleeOrCallerAvatorBtn];
        
        [self.calleeOrCallerAvatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(100));
            make.centerX.equalTo(self.userInfoBanner);
            make.top.equalTo(@(20));
        }];
        
        self.calleeOrCallerNameLb  = [[UILabel alloc]initWithFrame:CGRectZero];
        self.calleeOrCallerNameLb.text = @"胡歌";
        self.calleeOrCallerNameLb.font = [UIFont boldSystemFontOfSize:20];
        self.calleeOrCallerNameLb.textColor = [UIColor whiteColor];
        self.calleeOrCallerNameLb.textAlignment = NSTextAlignmentCenter;
        self.calleeOrCallerNameLb.adjustsFontSizeToFitWidth = YES;
        [self.userInfoBanner addSubview:self.calleeOrCallerNameLb];
        [self.calleeOrCallerNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.calleeOrCallerAvatorBtn);
            make.top.equalTo(self.calleeOrCallerAvatorBtn.mas_bottom).offset(15);
            make.width.equalTo(@(200));
            make.height.equalTo(@(25));
        }];
        
        self.calleeOrCallerDescLb = [[UILabel alloc]initWithFrame:CGRectZero];
        self.calleeOrCallerDescLb.text = self.userDesc ;
        self.calleeOrCallerDescLb.font = [UIFont systemFontOfSize:15];
        self.calleeOrCallerDescLb.textColor = [UIColor whiteColor];
        self.calleeOrCallerDescLb.textAlignment = NSTextAlignmentCenter;
        self.calleeOrCallerDescLb.adjustsFontSizeToFitWidth = YES;
        [self.userInfoBanner addSubview:self.calleeOrCallerDescLb];
        [self.calleeOrCallerDescLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.calleeOrCallerAvatorBtn);
            make.top.equalTo(self.calleeOrCallerNameLb.mas_bottom).offset(5);
            make.width.equalTo(@(250));
            make.height.equalTo(@(20));
        }];
        
        self.callingStatusLb = [[UILabel alloc]initWithFrame:CGRectZero];
        self.callingStatusLb.text = self.user == NSLivePhoneCallCaller?@"正在呼叫...":@"邀请你语音通话…";
        self.callingStatusLb.font = [UIFont systemFontOfSize:15];
        self.callingStatusLb.textColor = [UIColor whiteColor];
        self.callingStatusLb.textAlignment = NSTextAlignmentCenter;
        [self.userInfoBanner addSubview:self.callingStatusLb];
        [self.callingStatusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(banner);
            make.width.equalTo(@(100));
            make.height.equalTo(@(25));
        }];
        
        
        
        
        
    };
    if (self.user == NSLivePhoneCallCaller) {
        
        CallAddCommonInfoUIHandler(self);
        self.calleeOrCallerNameLb.text = self.userName;
        
        
        
        self.voiceCloseOrOpenBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.voiceCloseOrOpenBtn setImage:[UIImage imageNamed:@"jy"] forState:UIControlStateNormal];
        [self.voiceCloseOrOpenBtn setTitle:@"静音" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.voiceCloseOrOpenBtn];
        [self.voiceCloseOrOpenBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Voice)];
            
        }];
        [self.voiceCloseOrOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(65));
            make.height.equalTo(@(95));
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(0.5);
            make.bottom.equalTo(self.actionMenuBanner).offset(-20);
        }];
        
        self.hangoutBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.hangoutBtn setImage:[UIImage imageNamed:@"gf"] forState:UIControlStateNormal];
        [self.hangoutBtn setTitle:@"挂断" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.hangoutBtn];
        [self.hangoutBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Hangout)];
        }];
        [self.hangoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.actionMenuBanner);
            make.width.height.bottom.equalTo(self.voiceCloseOrOpenBtn);
        }];
        self.handsFreeBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.handsFreeBtn setImage:[UIImage imageNamed:@"mt"] forState:UIControlStateNormal];
        [self.handsFreeBtn setTitle:@"免提" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.handsFreeBtn];
        [self.handsFreeBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_HandsFree)];
        }];
        [self.handsFreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(1.5);
            make.width.height.bottom.equalTo(self.voiceCloseOrOpenBtn);
        }];
        
    }else if (self.user == NSLivePhoneCallCallee){
        //2.
        
        
        
        
        CallAddCommonInfoUIHandler(self);
        self.calleeOrCallerNameLb.text = self.userName;
        
        
        
        self.hangoutBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.hangoutBtn setImage:[UIImage imageNamed:@"gf"] forState:UIControlStateNormal];
        [self.hangoutBtn setTitle:@"挂断" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.hangoutBtn];
        [self.hangoutBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Hangout)];
        }];
        
        [self.hangoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(65));
            make.height.equalTo(@(95));
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(0.5);
            make.bottom.equalTo(self.actionMenuBanner).offset(-20);
        }];
        self.anwserBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.anwserBtn setImage:[UIImage imageNamed:@"anwser"] forState:UIControlStateNormal];
        [self.anwserBtn setTitle:@"接听" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.anwserBtn];
        [self.anwserBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Anwser)];
        }];
        [self.anwserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(1.5);
            make.width.height.bottom.equalTo(self.hangoutBtn);
        }];;
    }
}
- (void)videoChatRoom{
    void (^CallAddCommonInfoUIHandler)(UIView *) = ^(UIView *banner){
        self.connectionBgImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.connectionBgImgView setImage:[UIImage imageNamed:@"AVPhoneCallBg"]];
        [banner addSubview:self.connectionBgImgView];
        [self.connectionBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.height.equalTo(banner);
        }];
        
        self.userInfoBanner = [[UIView alloc]init];
        [banner addSubview:self.userInfoBanner];
        [self.userInfoBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(banner);
            make.top.equalTo(@(100));
            make.bottom.equalTo(banner).offset(95);
        }];
        
        
        
        self.videoChatViewBanner = [[UIButton alloc]init];
        [self.videoChatViewBanner setBackgroundColor:[UIColor clearColor]];
        [banner addSubview:self.videoChatViewBanner];
        [self.videoChatViewBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.height.equalTo(banner);
        }];
        
        
        
        self.handlerBanner = [[UIButton alloc]init];
        [self.handlerBanner setBackgroundColor:[UIColor clearColor]];
        [banner addSubview:self.handlerBanner];
        [self.handlerBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.height.equalTo(banner);
        }];
        
        
        self.headMenuBanner = [[UIView alloc]init];
        [self.handlerBanner addSubview:self.headMenuBanner];
        [self.headMenuBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(banner);
            make.height.equalTo(@(100));
        }];
        
     
        
        self.actionMenuBanner = [[UIView alloc]init];
        [self.actionMenuBanner setBackgroundColor:[UIColor clearColor]];
        [self.handlerBanner addSubview:self.actionMenuBanner];
        [self.actionMenuBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.handlerBanner);
            make.height.equalTo(@(100));
        }];
        
        
        
        self.smallScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.smallScreenBtn setBackgroundImage:[UIImage imageNamed:@"sq"] forState:UIControlStateNormal];
        [self.smallScreenBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_SmallScreen)];
        }];
        [self.headMenuBanner addSubview:self.smallScreenBtn];
        [self.smallScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(25));
            make.width.equalTo(@(25));
            make.left.equalTo(@(15));
            make.top.equalTo(@(35));
        }];
        
        self.titleViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleViewBtn setImage:[UIImage imageNamed:@"aq"] forState:UIControlStateNormal];
        [self.titleViewBtn setTitle:@"加密视频通话" forState:UIControlStateNormal];
        self.titleViewBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.headMenuBanner addSubview:self.titleViewBtn];
        [self.titleViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(25));
            make.width.equalTo(@(200));
            make.centerX.equalTo(banner);
            make.centerY.equalTo(self.smallScreenBtn);
        }];
        
       
        self.calleeOrCallerAvatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.calleeOrCallerAvatorBtn setBackgroundImage:[UIImage imageNamed:@"tx"] forState:UIControlStateNormal];
        [self.userInfoBanner addSubview:self.calleeOrCallerAvatorBtn];
        
        [self.calleeOrCallerAvatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(100));
            make.centerX.equalTo(self.userInfoBanner);
            make.top.equalTo(@(20));
        }];
        
        self.calleeOrCallerNameLb  = [[UILabel alloc]initWithFrame:CGRectZero];
        self.calleeOrCallerNameLb.text = @"胡歌";
        self.calleeOrCallerNameLb.font = [UIFont boldSystemFontOfSize:20];
        self.calleeOrCallerNameLb.textColor = [UIColor whiteColor];
        self.calleeOrCallerNameLb.textAlignment = NSTextAlignmentCenter;
        self.calleeOrCallerNameLb.adjustsFontSizeToFitWidth = YES;
        [self.userInfoBanner addSubview:self.calleeOrCallerNameLb];
        [self.calleeOrCallerNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.calleeOrCallerAvatorBtn);
            make.top.equalTo(self.calleeOrCallerAvatorBtn.mas_bottom).offset(15);
            make.width.equalTo(@(200));
            make.height.equalTo(@(25));
        }];
        
        self.calleeOrCallerDescLb = [[UILabel alloc]initWithFrame:CGRectZero];
        self.calleeOrCallerDescLb.text = self.userDesc ;
        self.calleeOrCallerDescLb.font = [UIFont systemFontOfSize:15];
        self.calleeOrCallerDescLb.textColor = [UIColor whiteColor];
        self.calleeOrCallerDescLb.textAlignment = NSTextAlignmentCenter;
        self.calleeOrCallerDescLb.adjustsFontSizeToFitWidth = YES;
        [self.userInfoBanner addSubview:self.calleeOrCallerDescLb];
        [self.calleeOrCallerDescLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.calleeOrCallerAvatorBtn);
            make.top.equalTo(self.calleeOrCallerNameLb.mas_bottom).offset(5);
            make.width.equalTo(@(250));
            make.height.equalTo(@(20));
        }];
        
        self.callingStatusLb = [[UILabel alloc]initWithFrame:CGRectZero];
        self.callingStatusLb.text = self.user == NSLivePhoneCallCaller?@"正在呼叫...":@"邀请你视频通话…";
        self.callingStatusLb.font = [UIFont systemFontOfSize:15];
        self.callingStatusLb.textColor = [UIColor whiteColor];
        self.callingStatusLb.textAlignment = NSTextAlignmentCenter;
        [self.userInfoBanner addSubview:self.callingStatusLb];
        [self.callingStatusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(banner);
            make.width.equalTo(@(100));
            make.height.equalTo(@(25));
        }];
     
    };
    if (self.user == NSLivePhoneCallCaller) {
        
        CallAddCommonInfoUIHandler(self);
        self.calleeOrCallerNameLb.text = self.userName;
        
        
        
        self.voiceCloseOrOpenBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.voiceCloseOrOpenBtn setImage:[UIImage imageNamed:@"jy"] forState:UIControlStateNormal];
        [self.voiceCloseOrOpenBtn setTitle:@"静音" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.voiceCloseOrOpenBtn];
        [self.voiceCloseOrOpenBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Voice)];

        }];
        [self.voiceCloseOrOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(65));
            make.height.equalTo(@(95));
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(0.5);
            make.bottom.equalTo(self.actionMenuBanner).offset(-20);
        }];
        
        self.hangoutBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.hangoutBtn setImage:[UIImage imageNamed:@"gf"] forState:UIControlStateNormal];
        [self.hangoutBtn setTitle:@"挂断" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.hangoutBtn];
        [self.hangoutBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Hangout)];
        }];
        [self.hangoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.actionMenuBanner);
            make.width.height.bottom.equalTo(self.voiceCloseOrOpenBtn);
        }];
        self.cameraBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.cameraBtn setImage:[UIImage imageNamed:@"sxt"] forState:UIControlStateNormal];
        [self.cameraBtn setTitle:@"摄像头" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.cameraBtn];
        [self.cameraBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Camera)];
        }];
        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(1.5);
            make.width.height.bottom.equalTo(self.voiceCloseOrOpenBtn);
        }];
        
    }else if (self.user == NSLivePhoneCallCallee){
        //2.
       
        
        
        
        CallAddCommonInfoUIHandler(self);
        self.calleeOrCallerNameLb.text = self.userName;
        
        
        
        self.hangoutBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.hangoutBtn setImage:[UIImage imageNamed:@"gf"] forState:UIControlStateNormal];
        [self.hangoutBtn setTitle:@"挂断" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.hangoutBtn];
        [self.hangoutBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Hangout)];
        }];
        
        [self.hangoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(65));
            make.height.equalTo(@(95));
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(0.5);
            make.bottom.equalTo(self.actionMenuBanner).offset(-20);
        }];
        self.anwserBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.anwserBtn setImage:[UIImage imageNamed:@"anwser"] forState:UIControlStateNormal];
        [self.anwserBtn setTitle:@"接听" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.anwserBtn];
        [self.anwserBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Anwser)];
        }];
        [self.anwserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(1.5);
            make.width.height.bottom.equalTo(self.hangoutBtn);
        }];;
    }
    
}

- (RACSubject *)phoneCallMenuHandlerSbj{
    if (!_phoneCallMenuHandlerSbj) {
        _phoneCallMenuHandlerSbj = [RACSubject subject];
    }
    return _phoneCallMenuHandlerSbj;
}

- (void)updateCalleeHandlerBtnFrame{
    if (self.room == NSLivePhoneCallVideoChatRoom) {
        [self.anwserBtn setHidden:YES];
        [self.hangoutBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
        }];
        [self.hangoutBtn layoutIfNeeded];
        
        if (!self.voiceCloseOrOpenBtn) {
            self.voiceCloseOrOpenBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
            [self.voiceCloseOrOpenBtn setImage:[UIImage imageNamed:@"jy"] forState:UIControlStateNormal];
            [self.voiceCloseOrOpenBtn setTitle:@"静音" forState:UIControlStateNormal];
            [self.actionMenuBanner addSubview:self.voiceCloseOrOpenBtn];
            [self.voiceCloseOrOpenBtn action:^(UIButton *sendor) {
                [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Voice)];
                
            }];
        }
       
        [self.voiceCloseOrOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(65));
            make.height.equalTo(@(95));
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(0.5);
            make.bottom.equalTo(self.actionMenuBanner).offset(-20);
        }];
        
        if (!self.hangoutBtn) {
            self.hangoutBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
            [self.hangoutBtn setImage:[UIImage imageNamed:@"gf"] forState:UIControlStateNormal];
            [self.hangoutBtn setTitle:@"挂断" forState:UIControlStateNormal];
            [self.actionMenuBanner addSubview:self.hangoutBtn];
            [self.hangoutBtn action:^(UIButton *sendor) {
                [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Hangout)];
            }];
        }
      
        [self.hangoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.actionMenuBanner);
            make.width.height.bottom.equalTo(self.voiceCloseOrOpenBtn);
        }];
        
        if (!self.cameraBtn) {
            
            self.cameraBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
            [self.cameraBtn setImage:[UIImage imageNamed:@"sxt"] forState:UIControlStateNormal];
            [self.cameraBtn setTitle:@"摄像头" forState:UIControlStateNormal];
            [self.actionMenuBanner addSubview:self.cameraBtn];
            [self.cameraBtn action:^(UIButton *sendor) {
                [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Camera)];
            }];
        }
        
        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(1.5);
            make.width.height.bottom.equalTo(self.voiceCloseOrOpenBtn);
        }];
        
        
    }else if (self.room == NSLivePhoneCallAudioChatRoom){
        
        [self.anwserBtn setHidden:YES];
        [self.hangoutBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
        }];
        [self.hangoutBtn layoutIfNeeded];
        
        self.voiceCloseOrOpenBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.voiceCloseOrOpenBtn setImage:[UIImage imageNamed:@"jy"] forState:UIControlStateNormal];
        [self.voiceCloseOrOpenBtn setTitle:@"静音" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.voiceCloseOrOpenBtn];
        [self.voiceCloseOrOpenBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_Voice)];
            
        }];
        [self.voiceCloseOrOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(65));
            make.height.equalTo(@(95));
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(0.5);
            make.bottom.equalTo(self.actionMenuBanner).offset(-20);
        }];
        self.handsFreeBtn = [NSVerticalButton buttonWithType:UIButtonTypeCustom];
        [self.handsFreeBtn setImage:[UIImage imageNamed:@"mt"] forState:UIControlStateNormal];
        [self.handsFreeBtn setTitle:@"免提" forState:UIControlStateNormal];
        [self.actionMenuBanner addSubview:self.handsFreeBtn];
        [self.handsFreeBtn action:^(UIButton *sendor) {
            [self.phoneCallMenuHandlerSbj sendNext:@(NSLivePhoneCallMenuBtn_HandsFree)];
        }];
        [self.handsFreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.actionMenuBanner).multipliedBy(1.5);
            make.width.height.bottom.equalTo(self.voiceCloseOrOpenBtn);
        }];
    }
}
- (void)updateFrameTransform:(CGAffineTransform )transform{
    
  
    
    UIImage *image =   [self screenshot];
    for (UIView *sbView in self.subviews) {
        [sbView setHidden:YES];
    }
    UIButton *bigScreenBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bigScreenBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self addSubview:bigScreenBtn];
    [bigScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(self);
    }];
    @weakify(self);
    [bigScreenBtn action:^(UIButton *sendor) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *sbView in self_weak_.subviews) {
                if (sbView != sendor) {
                    [sbView setHidden:NO];
                }
            }
            [sendor removeFromSuperview];
            
            [(NSRTCAVLivePhoneCallMainView*)self_weak_.superview  updateFrame:kKeyWindow.bounds withSuperView:kKeyWindow];
        });
    }];
    self.bigScreenBtn = bigScreenBtn;
    //button长按事件
    UIPanGestureRecognizer *longPress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(btnPan:)];
    [self.bigScreenBtn addGestureRecognizer:longPress];
    self.transform = transform;
}
- (void)btnPan:(UIPanGestureRecognizer*)gesRecognizer{
    NSRTCAVLivePhoneCallMainView *mainView = (NSRTCAVLivePhoneCallMainView*) self.superview;
    CGPoint tp = [gesRecognizer translationInView:mainView];
    CGPoint center =  mainView.center;
    center = CGPointMake(center.x+tp.x, center.y+tp.y);
    if ((center.x-self.width*1.0/2)>0
        &&(center.x+self.width*1.0/2)<kKeyWindow.width
        &&(center.y-self.height*1.0/2)>0
        &&(center.y+self.height*1.0/2)<kKeyWindow.height)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
             [mainView setCenter:center];
        });
        //复位
        [gesRecognizer setTranslation:CGPointZero inView:mainView];
    }
}
- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}
@end
