//
//  NSRTCChatTabBarView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/10/31.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NSRTCChatTabBarViewDelegate;
@interface NSRTCChatTabBarView : UIView

@property (nonatomic, weak) id<NSRTCChatTabBarViewDelegate>delegate;


@end


@protocol NSRTCChatTabBarViewDelegate <NSObject>

- (BOOL)tabBarView:(NSRTCChatTabBarView *)tabBarView shoulSelectItemAtIndex:(NSInteger)index;
- (void)tabBarView:(NSRTCChatTabBarView *)tabBarView didSelectItemAtIndex:(NSInteger)index;
@optional
- (void)tabBarView:(NSRTCChatTabBarView *)tabBarView shoulClearUnreadCountAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
