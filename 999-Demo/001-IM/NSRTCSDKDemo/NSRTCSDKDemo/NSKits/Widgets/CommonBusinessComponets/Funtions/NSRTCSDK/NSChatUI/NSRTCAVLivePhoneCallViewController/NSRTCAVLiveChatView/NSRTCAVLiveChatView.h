//
//  NSRTCAVLiveChatView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSRTCAVLiveChatView : UIButton

+ (instancetype)chatViewWithFrame:(CGRect)rect;
- (void)setHeadPhoto:(UIImage*)head;
- (void)beginHeaderRotationAnimation;
- (void)stopHeaderRotationAnimation;

@end

