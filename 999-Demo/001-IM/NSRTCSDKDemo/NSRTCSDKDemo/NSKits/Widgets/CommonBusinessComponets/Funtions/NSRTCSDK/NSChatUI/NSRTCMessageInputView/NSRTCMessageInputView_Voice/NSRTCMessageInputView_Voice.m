//
//  NSRTCMessageInputView_Voice.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCMessageInputView_Voice.h"


//#import <NSRTC/NSAudioHandlerKit.h>
#import "NSAudioHandlerKit.h"
 
#import "NSRTCAudioMessageVolumeView.h"
#import "NSRTCAudioMessageRecordView.h"

typedef NS_ENUM(NSInteger, NSRTCMessageInputView_VoiceState) {
    NSRTCMessageInputView_VoiceStateReady,
    NSRTCMessageInputView_VoiceStateRecording,
    NSRTCMessageInputView_VoiceStateCancel
};

@interface NSRTCMessageInputView_Voice () <NSRTCAudioMessageRecordViewDelegate>

@property (strong, nonatomic) UILabel *recordTipsLabel;
@property (strong, nonatomic) NSRTCAudioMessageRecordView *recordView;
@property (strong, nonatomic) NSRTCAudioMessageVolumeView *volumeLeftView;
@property (strong, nonatomic) NSRTCAudioMessageVolumeView *volumeRightView;
@property (assign, nonatomic) NSRTCMessageInputView_VoiceState state;
@property (assign, nonatomic) int duration;
@property (strong, nonatomic) NSTimer *timer;

@end
@implementation NSRTCMessageInputView_Voice


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self creatUI];
    }
    return self;
}


- (void)creatUI {
    
    self.backgroundColor = [UIColor colorWithHex:0xefefef];
    
    _recordTipsLabel = [[UILabel alloc] init];
    _recordTipsLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_recordTipsLabel];
    
    _volumeLeftView = [[NSRTCAudioMessageVolumeView alloc] initWithFrame:CGRectMake(0, 0, kAudioVolumeViewWidth, kAudioVolumeViewHeight)];
    _volumeLeftView.type = NSRTCAudioMessageVolumeViewTypeLeft;
    _volumeLeftView.hidden = YES;
    [self addSubview:_volumeLeftView];
    
    _volumeRightView = [[NSRTCAudioMessageVolumeView alloc] initWithFrame:CGRectMake(0, 0, kAudioVolumeViewWidth, kAudioVolumeViewHeight)];
    _volumeRightView.type = NSRTCAudioMessageVolumeViewTypeRight;
    _volumeRightView.hidden = YES;
    [self addSubview:_volumeRightView];
    
    
    _recordView = [[NSRTCAudioMessageRecordView alloc] initWithFrame:CGRectMake((self.frame.size.width - 86) / 2, 62, 86, 86)];
    _recordView.delegate = self;
    [self addSubview:_recordView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor colorWithHex:0x999999];
    tipLabel.text = @"向上滑动，取消发送";
    [tipLabel sizeToFit];
    [self addSubview:tipLabel];
    tipLabel.center = CGPointMake(self.width/2.0, self.height - 25);
    
    _duration = 0;
    self.state = NSRTCMessageInputView_VoiceStateReady;
}

- (void)dealloc {
    self.state = NSRTCMessageInputView_VoiceStateReady;
}

- (void)setState:(NSRTCMessageInputView_VoiceState)state {
    _state = state;
    switch (state) {
        case NSRTCMessageInputView_VoiceStateReady:
            _recordTipsLabel.textColor = [UIColor colorWithHex:0x999999];
            _recordTipsLabel.text = @"按住说话";
            _volumeRightView.hidden = YES;
            _volumeLeftView.hidden = YES;
            break;
            
        case NSRTCMessageInputView_VoiceStateRecording:
            if (_duration < [NSAudioHandlerKit shared].maxRecordDuration - 5) {
                _recordTipsLabel.textColor = [UIColor colorWithHex:0x2faeea];
            }
            else {
                _recordTipsLabel.textColor = [UIColor colorWithHex:0xde4743];
            }
            _recordTipsLabel.text = [self formattedTime:_duration];
            break;
            
        case NSRTCMessageInputView_VoiceStateCancel:
            _recordTipsLabel.textColor = [UIColor colorWithHex:0x999999];
            _recordTipsLabel.text = @"松开取消";
            _volumeLeftView.hidden = YES;
            _volumeRightView.hidden = YES;
            break;
        default:
            break;
    }
    [_recordTipsLabel sizeToFit];
    _recordTipsLabel.center = CGPointMake(self.width/2, 20);
    if (self.state == NSRTCMessageInputView_VoiceStateRecording) {
        _volumeLeftView.center = CGPointMake(_recordTipsLabel.frame.origin.x - _volumeLeftView.frame.size.width/2 - 12, _recordTipsLabel.center.y);
        _volumeLeftView.hidden = NO;
        _volumeRightView.center = CGPointMake(_recordTipsLabel.frame.origin.x + _recordTipsLabel.frame.size.width + _volumeRightView.frame.size.width/2 + 12, _recordTipsLabel.center.y);
        _volumeRightView.hidden = NO;
    }
}
#pragma mark - RecordTimer
- (void)startTimer {
    _duration = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(increaseRecordTime) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        self.timer = nil;
    }
}

- (void)increaseRecordTime {
    _duration ++;
    _duration++;
    if (self.state == NSRTCMessageInputView_VoiceStateRecording) {
        //update time label
        self.state = NSRTCMessageInputView_VoiceStateRecording;
    }
    
}

- (NSString *)formattedTime:(int)duration {
    return [NSString stringWithFormat:@"%02d:%02d", duration / 60, duration % 60];
}

#pragma mark - NSRTCAudioMessageRecordViewDelegate
- (void)recordViewRecordStarted:(NSRTCAudioMessageRecordView *)recordView {
    [_volumeLeftView clearVolume];
    [_volumeRightView clearVolume];
    
    self.state = NSRTCMessageInputView_VoiceStateRecording;
    [self startTimer];
}

- (void)recordViewRecordFinished:(NSRTCAudioMessageRecordView *)recordView file:(NSString *)file duration:(NSTimeInterval)duration {
    [self stopTimer];
    if (self.state == NSRTCMessageInputView_VoiceStateRecording) {
        if (_recordSuccessfully) {
            _recordSuccessfully(file, duration);
        }
    }
    else if (self.state == NSRTCMessageInputView_VoiceStateCancel) {
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    }
    
    self.state = NSRTCMessageInputView_VoiceStateReady;
    _duration = 0;
}

- (void)recordView:(NSRTCAudioMessageRecordView *)recordView touchStateChanged:(NSRTCAudioMessageRecordViewTouchState)touchState {
    if (self.state != NSRTCMessageInputView_VoiceStateReady) {
        if (touchState == NSRTCAudioMessageRecordViewTouchStateInside) {
            self.state = NSRTCMessageInputView_VoiceStateRecording;
        }
        else {
            self.state = NSRTCMessageInputView_VoiceStateCancel;
        }
    }
}

- (void)recordView:(NSRTCAudioMessageRecordView *)recordView volume:(double)volume {
    [_volumeLeftView addVolume:volume];
    [_volumeRightView addVolume:volume];
}

- (void)recordViewRecord:(NSRTCAudioMessageRecordView *)recordView err:(NSError *)err {
    [self stopTimer];
    if (self.state == NSRTCMessageInputView_VoiceStateRecording) {
        DLog(@"错误%@", err.domain);
    }
    self.state = NSRTCMessageInputView_VoiceStateReady;
    _duration = 0;
}


@end
