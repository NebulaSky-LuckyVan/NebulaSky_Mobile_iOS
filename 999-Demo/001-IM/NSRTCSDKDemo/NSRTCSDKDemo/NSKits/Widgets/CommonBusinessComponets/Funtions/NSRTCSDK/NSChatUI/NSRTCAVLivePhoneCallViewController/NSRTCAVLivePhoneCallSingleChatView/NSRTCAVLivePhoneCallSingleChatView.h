//
//  NSRTCAVLivePhoneCallSingleChatView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSRTCAVLiveChatView;
@interface NSRTCAVLivePhoneCallSingleChatView : UIView

@property (strong, nonatomic ,readonly) NSRTCAVLiveChatView *localChatView;
@property (strong, nonatomic ,readonly) NSRTCAVLiveChatView *remoteChatView;

- (void)updateSubviewRect;
- (BOOL)isSmallPage:(NSRTCAVLiveChatView*)chatView;
+ (instancetype)callViewWithBackground:(UIImage*)bgImg callerHeadPhoto:(NSString*)callerPhoto calleeHeadPhoto:(NSString*)calleePhoto callViewFrame:(CGRect)rect;
@end
