//
//  NSRTCAudioMessageRecordView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, NSRTCAudioMessageRecordViewTouchState) {
    NSRTCAudioMessageRecordViewTouchStateInside,
    NSRTCAudioMessageRecordViewTouchStateOutside
};
@protocol NSRTCAudioMessageRecordViewDelegate;


@interface NSRTCAudioMessageRecordView : UIControl
@property (nonatomic, assign, readonly) BOOL isRecording;
@property (nonatomic, weak) id<NSRTCAudioMessageRecordViewDelegate> delegate;

@end



@protocol NSRTCAudioMessageRecordViewDelegate <NSObject>

@optional

- (void)recordViewRecordStarted:(NSRTCAudioMessageRecordView *)recordView;
- (void)recordViewRecordFinished:(NSRTCAudioMessageRecordView *)recordView file:(NSString *)file duration:(NSTimeInterval)duration;
- (void)recordView:(NSRTCAudioMessageRecordView *)recordView touchStateChanged:(NSRTCAudioMessageRecordViewTouchState)touchState;
- (void)recordView:(NSRTCAudioMessageRecordView *)recordView volume:(double)volume;
- (void)recordViewRecord:(NSRTCAudioMessageRecordView *)recordView err:(NSError *)err;

@end
