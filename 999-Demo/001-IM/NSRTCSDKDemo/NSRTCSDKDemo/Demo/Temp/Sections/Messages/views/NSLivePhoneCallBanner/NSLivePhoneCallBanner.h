//
//  NSLivePhoneCalllBanner.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/13.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/RACSubject.h>
typedef NS_ENUM(NSUInteger,NSLivePhoneCallMenuBtn) {
    NSLivePhoneCallMenuBtn_Hangout = 0,
    NSLivePhoneCallMenuBtn_Anwser,
    NSLivePhoneCallMenuBtn_Voice,
    NSLivePhoneCallMenuBtn_Camera,
    NSLivePhoneCallMenuBtn_HandsFree,//免提
    NSLivePhoneCallMenuBtn_UserAvator,
    NSLivePhoneCallMenuBtn_SmallScreen,
};
typedef NS_ENUM(NSUInteger,NSLivePhoneCallUser) {
    NSLivePhoneCallCaller =0,
    NSLivePhoneCallCallee,
};

typedef NS_ENUM(NSUInteger,NSLivePhoneCallChatRoom) {
    NSLivePhoneCallVideoChatRoom =0,
    NSLivePhoneCallAudioChatRoom,
};
@interface NSLivePhoneCallBanner : UIView
+ (instancetype)bannerWithUserType:(NSLivePhoneCallUser)user chatRoom:(NSLivePhoneCallChatRoom)room userName:(NSString*)name userDesc:(NSString*)desc;
//Desc:
@property (strong, nonatomic ,readonly) UIButton *videoChatViewBanner;
@property (strong, nonatomic ,readonly) UIButton *handlerBanner;
@property (strong, nonatomic ,readonly) UIView *headMenuBanner;
@property (strong, nonatomic ,readonly) UIView *actionMenuBanner;
@property (strong, nonatomic ,readonly) UILabel *callingStatusLb;
@property (strong, nonatomic ,readonly) UIButton *bigScreenBtn;

//Desc:
@property (strong, nonatomic) RACSubject *phoneCallMenuHandlerSbj;

- (void)updateCalleeHandlerBtnFrame;

- (void)updateFrameTransform:(CGAffineTransform)transform;

@end

