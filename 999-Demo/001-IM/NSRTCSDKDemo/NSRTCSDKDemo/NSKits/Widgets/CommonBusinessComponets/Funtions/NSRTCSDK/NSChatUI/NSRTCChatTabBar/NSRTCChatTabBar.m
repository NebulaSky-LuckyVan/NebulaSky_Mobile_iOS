//
//  NSRTCChatTabBar.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/10/31.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCChatTabBar.h"

@implementation NSRTCChatTabBar

- (void)setFrame:(CGRect)frame {
    if (self.superview && CGRectGetMaxY(self.superview.bounds) != CGRectGetMaxY(frame)) {
        frame.origin.y = CGRectGetMaxY(self.superview.bounds) - CGRectGetHeight(frame);
    }
    [super setFrame:frame];
}

- (void)addSubview:(UIView *)view {
     
    if ([view isKindOfClass:[UIControl class]]) {
        return;
    }
    [super addSubview:view];
}

@end
