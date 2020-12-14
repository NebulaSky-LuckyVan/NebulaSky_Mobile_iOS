//
//  NSChatUI.h
//  ChatDemo
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#ifndef NSChatUI_h
#define NSChatUI_h
/** DEBUG LOG **/
#ifdef DEBUG

#define NSLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLNSLogog( s, ... )

#endif
/** DEBUG LOG **/
#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif

#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)



#define RGBAColor(r, g, b, a) [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kPadding 10.0f
#define kMargin 15.0f
#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define kDidLogin @"didLogin"

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)


#define ColorFromHexA(hexValue, a)     [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:a]

#define ColorFromHex(hexValue)        ColorFromHexA(hexValue, 1.0f)
/*---------App属性设置-------------*/
#define AppBackgroundColor     ColorFromHex(0xF5F3F2)//页面背景颜色
/*------导航栏------*/
#define NavBarBackgroundColor  ColorFromHexA(0xFFFFFF,1)//[UIColor colorWithRGBHexString:@"b40000"]//导航栏背景色
#define NavBarTextColor ColorFromHex(0x333333) //导航栏文字颜色

//#import "NSRTCConstancts.h"
#import "NSRTCStatusTitleView.h"

#import "NSRTCChatListCell.h"
#import "NSRTCChatBadgeLabel.h"

//#import <NSRTC/NSRTCVideoPlayer.h>
#import "NSVideoPlayer.h"
#import "NSRTCVideoProgressView.h"
#import "NSRTCVideoViewController.h"

#import "NSRTCMessageBubbleView.h"


#import "NSRTCChatImageBrowserController.h"
#import "NSRTCChatImageBrowserCell.h"
#import "NSRTCChatViewController.h"

#import "NSRTCMessageCell.h"
#import "NSRTCMessageCellContentView.h"

#import "NSRTCPlaceholderTextView.h"



#import "NSRTCStatusTitleView.h"

#import "NSRTCChatListCell.h"
#import "NSRTCChatListViewController.h"

#import "NSRTCMessageInputView.h"

#import "AGEmojiKeyBoardView.h" 


#import "NSRTCMessageInputView_Voice.h"
#import "NSRTCMessageInputView_Add.h"



#import "NSRTCVideoViewController.h"
#import "NSRTCChatImageBrowserController.h"
#import "NSRTCChatLocationDetailController.h"


#import "NSRTCChatTabBar.h"
#import "NSRTCChatTabBarView.h"

#import "NSRTCChatTabBarMessageItemView.h"
#import "NSRTCChatTabBarContactsItemView.h"
#import "NSRTCChatTabBarDynamicItemView.h"

#import "NSRTCChatTabBarBadgeLabel.h"



#import "NSRTCChatViewController.h"
#import "NSRTCChatListViewController.h"
#import "NSRTCChatLocationController.h"
#import "NSRTCChatLocationDetailController.h"


#import "NSRTCChatLocationController.h"
#import "NSRTCChatLocationDetailController.h"
#import "NSRTCAVLivePhoneCallViewController.h"
#endif /* NSChatUI_h */
