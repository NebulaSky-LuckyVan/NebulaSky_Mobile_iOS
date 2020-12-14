//
//  NSRTCMessageCellContentView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSRTCDemoMessage;
typedef NS_ENUM(NSInteger, NSRTCMessageCellType) {
    NSRTCTextMessageCell,
    NSRTCImgMessageCell,
    NSRTCLocMessageCell,
    NSRTCAudioMessageCell,
    NSRTCVideoMessageCell,
    NSRTCOtherMessageCell
};




@interface NSRTCMessageCellContentView : UIButton

@property (nonatomic, assign) BOOL isSender;
@property (nonatomic, strong) NSRTCDemoMessage *message;
@property (nonatomic, strong) UIFont *textFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat horizontalOffset;
@property (nonatomic, assign) CGFloat verticalOffset;

@property (nonatomic, copy) void(^contentViewTapBlock)(void);

/**
 工厂类创建入口
 
 @param cellType 消息类型
 @param isSender 是否是发送者
 @return 返回类簇
 */
- (instancetype)initWithCellType:(NSRTCMessageCellType)cellType isSender:(BOOL)isSender;


/**
 子类的创建入口
 
 @param isSender 是否是发送者
 @return 自己
 */
- (instancetype)initWithIsSender:(BOOL)isSender;


/**
 子类实现各自的UI布局
 */
- (void)creatUI;

/**
 根据消息内容更新尺寸
 */
- (void)updateFrame;

/**
 点击事件
 */
- (void)tapViewAction;

- (void)touchesBegan;

- (void)touchesEnded;


@end



@interface NSRTCTextMessageContentView : NSRTCMessageCellContentView

@end

@interface NSRTCImageMessageContentView : NSRTCMessageCellContentView



@end

@interface NSRTCLocMessageContentView : NSRTCMessageCellContentView

- (void)resetLocImage;

@end


typedef NS_ENUM(NSInteger, NSRTCAudioPlayViewState) {
    NSRTCAudioPlayViewStateNormal,
    NSRTCAudioPlayViewStateDownloading,
    NSRTCAudioPlayViewStatePlaying
};
@interface NSRTCAudioMessageContentView : NSRTCMessageCellContentView

@property (nonatomic, assign) NSRTCAudioPlayViewState playState;

@end

