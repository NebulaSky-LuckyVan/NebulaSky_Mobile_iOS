//
//  NSRTCAVLivePhoneCallSingleChatView.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCAVLivePhoneCallSingleChatView.h"
#import "NSRTCAVLiveChatView.h"


static CGFloat const  smallPageViewPadding = 15;
@interface NSRTCAVLivePhoneCallSingleChatView ()

@property (strong, nonatomic) NSRTCAVLiveChatView *localChatView;
@property (strong, nonatomic) NSRTCAVLiveChatView *remoteChatView;

@property (strong, nonatomic) UIImage  *backgroundImg;
@property (strong, nonatomic) NSString *callerPhoto;
@property (strong, nonatomic) NSString *calleePhoto;
@end
@implementation NSRTCAVLivePhoneCallSingleChatView

+ (instancetype)callViewWithBackground:(UIImage*)bgImg callerHeadPhoto:(NSString*)callerPhoto calleeHeadPhoto:(NSString*)calleePhoto callViewFrame:(CGRect)rect{
    NSRTCAVLivePhoneCallSingleChatView*callView = [[NSRTCAVLivePhoneCallSingleChatView alloc]init];
    callView.backgroundImg = bgImg;
    callView.calleePhoto = calleePhoto;
    callView.callerPhoto = callerPhoto;
    callView.frame = rect;
    return callView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{
    self.localChatView = [NSRTCAVLiveChatView chatViewWithFrame:[self smallChatViewRect]];
    self.remoteChatView = [NSRTCAVLiveChatView chatViewWithFrame:[self bigChatViewRect]];
    [self addSubview:self.remoteChatView];
    [self addSubview:self.localChatView];
}
- (void)updateSubviewRect{
    [self.remoteChatView setFrame:[self bigChatViewRect]];
    [self.localChatView setFrame:[self smallChatViewRect]];
    
    [self bringSubviewToFront:self.localChatView];
    
}
//
- (UIPanGestureRecognizer*)chatViewMoveWhenPanGesture{
    UIPanGestureRecognizer *panGestureR = [[UIPanGestureRecognizer alloc]init];
    return panGestureR;
}

- (BOOL)isSmallPage:(NSRTCAVLiveChatView*)chatView{
    return !CGRectEqualToRect(chatView.frame, [UIApplication sharedApplication].keyWindow.bounds);
}
- (CGRect)bigChatViewRect{
    CGRect bigRect = [UIApplication sharedApplication].keyWindow.bounds;
    return bigRect;
}

- (CGRect)smallChatViewRect{
    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    // Aspect fit local video view into a square box.
    CGRect smallRect =
    CGRectMake(0, 0, CGRectGetWidth(rect)/2.123, CGRectGetHeight(rect)/4.123);
    // Place the view in the bottom right.
    smallRect.origin.x = CGRectGetMaxX(rect)
    - smallRect.size.width -  smallPageViewPadding/3;
    smallRect.origin.y = CGRectGetMaxY(rect)
    - smallRect.size.height -  smallPageViewPadding;
    return smallRect;
}

@end
