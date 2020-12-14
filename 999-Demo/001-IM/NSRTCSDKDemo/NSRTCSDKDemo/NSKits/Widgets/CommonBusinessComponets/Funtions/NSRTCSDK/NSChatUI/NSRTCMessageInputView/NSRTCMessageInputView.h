//
//  NSRTCMessageInputView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, NSRTCMessageInputViewState) {
    NSRTCMessageInputViewStateSystem,
    NSRTCMessageInputViewStateEmotion,
    NSRTCMessageInputViewStateAdd,
    NSRTCMessageInputViewStateVoice
};

@protocol NSRTCMessageInputViewDelegate;
@interface NSRTCMessageInputView : UIView<UITextViewDelegate>

@property (nonatomic, weak) id<NSRTCMessageInputViewDelegate> delegate;

- (void)prepareToShow;
- (void)prepareToDissmiss;
- (BOOL)isAndResignFirstResponder;

@end

@protocol NSRTCMessageInputViewDelegate <NSObject>


/**
 底部高度变化
 
 @param inputView 输入视图
 @param heightToBottom 变化后的高度
 */
- (void)messageInputView:(NSRTCMessageInputView *)inputView heightToBottomChange:(CGFloat)heightToBottom;

/**
 发送文本
 
 @param inputView 输入试图
 @param text 文本内容
 */
- (void)messageInputView:(NSRTCMessageInputView *)inputView sendText:(NSString *)text;

/**
 发送大Emotion
 
 @param inputView 输入视图
 @param emotionName Emotion的名字
 */
- (void)messageInputView:(NSRTCMessageInputView *)inputView sendBigEmotion:(NSString *)emotionName;

/**
 发送语音
 
 @param inputView 输入视图
 @param saveFile 语音保存的本地路径
 @param duration 语音时长
 */
- (void)messageInputView:(NSRTCMessageInputView *)inputView sendVoice:(NSString *)saveFile duration:(CGFloat)duration;
/**
 更多发送选项点击
 
 @param inputView 输入视图
 @param index 点击选项index
 */
- (void)messageInputView:(NSRTCMessageInputView *)inputView addIndexClicked:(NSInteger)index;
@end



