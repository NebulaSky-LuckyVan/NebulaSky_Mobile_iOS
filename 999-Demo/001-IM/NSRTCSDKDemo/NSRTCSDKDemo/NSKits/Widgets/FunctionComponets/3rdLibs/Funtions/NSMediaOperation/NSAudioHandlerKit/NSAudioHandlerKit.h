//
//  NSAudioHandlerKit.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol  NSAudioHandlerDelegate;
@interface NSAudioHandlerKit : NSObject

@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong, readonly) AVAudioRecorder *audioRecorder;
@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) BOOL isRecording;
@property (nonatomic, assign) NSTimeInterval minRecordDuration;
@property (nonatomic, assign) NSTimeInterval maxRecordDuration;
@property (nonatomic, weak) id<NSAudioHandlerDelegate> delegate;
@property (nonatomic, strong) id validator;

+ (instancetype)shared;

- (void)play:(NSString *)file validator:(id)validator;
- (void)stopPlay;
- (void)record;
- (void)stopRecord;
- (void)stopAll;

@end


@protocol NSAudioHandlerDelegate <NSObject>

@optional

- (void)didAudioPlayStarted:(NSAudioHandlerKit *)am;
- (void)didAudioPlayStoped:(NSAudioHandlerKit *)am successfully:(BOOL)successfully;
- (void)didAudioPlay:(NSAudioHandlerKit *)am err:(NSError *)err;

- (void)didAudioRecordStarted:(NSAudioHandlerKit *)am;
- (void)didAudioRecording:(NSAudioHandlerKit *)am volume:(double)volume;
- (void)didAudioRecordStoped:(NSAudioHandlerKit *)am file:(NSString *)file duration:(NSTimeInterval)duration successfully:(BOOL)successfully;
- (void)didAudioRecord:(NSAudioHandlerKit *)am err:(NSError *)err;

@end
