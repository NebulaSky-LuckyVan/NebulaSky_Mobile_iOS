//
//  NSRTCAudioMessageVolumeView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kAudioVolumeViewVolumeWidth 2.0f
#define kAudioVolumeViewVolumeMinHeight 3.0f
#define kAudioVolumeViewVolumeMaxHeight 16.0f
#define kAudioVolumeViewVolumePadding 2.0f
#define kAudioVolumeViewVolumeNumber 10

#define kAudioVolumeViewWidth (kAudioVolumeViewVolumeWidth*kAudioVolumeViewVolumeNumber+kAudioVolumeViewVolumePadding*(kAudioVolumeViewVolumeNumber-1))
#define kAudioVolumeViewHeight kAudioVolumeViewVolumeMaxHeight


typedef NS_ENUM(NSInteger, NSRTCAudioMessageVolumeViewType) {
    NSRTCAudioMessageVolumeViewTypeLeft,
    NSRTCAudioMessageVolumeViewTypeRight
};
@interface NSRTCAudioMessageVolumeView : UIView

@property (nonatomic, assign) NSRTCAudioMessageVolumeViewType type;

- (void)addVolume:(double)volume;
- (void)clearVolume;
@end

