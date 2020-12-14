//
//  NSRTCMessageCell.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSRTCMessageCellContentView.h"
#import "NSRTCDemoMessage.h"


@protocol NSRTCMessageCellDelegate ;

@interface NSRTCMessageCell : UITableViewCell

/**
 文字字体
 */
@property (nonatomic, strong) UIFont *textFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSRTCMessageCellContentView *contentBackView;  // 消息内容部分背景
@property (nonatomic, assign) NSRTCMessageCellType cellType;
@property (nonatomic, strong) NSRTCDemoMessage *message;
@property (nonatomic,  weak ) id<NSRTCMessageCellDelegate>delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier messageModel:(NSRTCDemoMessage *)model;

+ (NSString *)cellReuseIndetifierWithMessageModel:(NSRTCDemoMessage *)Model;

- (void)updateSendStatus:(NSRTCMessageSendStatus)status;

@end

@protocol NSRTCMessageCellDelegate <NSObject>


/**
 重新发送消息
 @param cell cell
 @param message 消息模型
 */
- (void)messageCell:(NSRTCMessageCell *)cell resendMessage:(NSRTCDemoMessage *)message;


/**
 cell上内容部分被点击
 
 @param cell cell
 */
- (void)didTapContentOfMessageCell:(NSRTCMessageCell *)cell meesage:(NSRTCDemoMessage *)message;


@end


