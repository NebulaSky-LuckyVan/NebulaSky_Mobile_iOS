//
//  NSRTCChatTabBarItemView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/10/31.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
 

@class NSRTCChatTabBarBadgeLabel;
typedef NS_ENUM(NSInteger, NSRTCChatTabBarItemType) {
    NSRTCChatTabBarMessage,
    NSRTCChatTabBarContacts,
    NSRTCChatTabBarDynamic
};

typedef NS_ENUM(NSInteger, NSRTCChatTabBarSelectedOrientation) {
    NSRTCChatTabBarLeft,
    NSRTCChatTabBarSelected,
    NSRTCChatTabBarRight
};
static CGFloat image_max_offset_x = 5;
static CGFloat image_max_offset_y = 3;
@interface NSRTCChatTabBarItemView : UIView


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, assign) NSRTCChatTabBarItemType type;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIView *imageContentView;
@property (nonatomic, strong) NSRTCChatTabBarBadgeLabel *badgeLabel;
@property (nonatomic, strong) CAShapeLayer *contentLayer;
@property (nonatomic, assign) NSRTCChatTabBarSelectedOrientation orientation;
@property (nonatomic, copy) NSString *badgeString;

- (instancetype)initWithOrientation:(NSRTCChatTabBarSelectedOrientation)orientation title:(NSString *)title type:(NSRTCChatTabBarItemType)type;
- (void)setupContentLayer;
- (void)commonInit;
- (void)panGesture:(UIPanGestureRecognizer *)panGes;
@end

