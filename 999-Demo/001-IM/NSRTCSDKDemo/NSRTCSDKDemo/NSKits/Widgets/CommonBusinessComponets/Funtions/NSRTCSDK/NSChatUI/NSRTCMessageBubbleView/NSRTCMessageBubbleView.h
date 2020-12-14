//
//  NSRTCMessageBubbleView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/1.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSRTCMessage;
@interface NSRTCMessageBubbleView : UIView

@property (nonatomic, strong) NSRTCMessage *message;
@property (nonatomic, strong) UIFont *textFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets textSendInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets textRecInsets UI_APPEARANCE_SELECTOR;
- (instancetype)initWithIsSender:(BOOL)isSender;
@property (nonatomic, assign) CGFloat horizontalOffset;
@end

