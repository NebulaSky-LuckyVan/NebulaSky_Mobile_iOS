//
//  NSRTCChatTabBarBadgeLabel.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/10/31.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSRTCChatTabBarBadgeLabel : UILabel
@property (nonatomic, copy) NSRTCBaseBlockHandler clearBadgeCompletion;

@end

NS_ASSUME_NONNULL_END
