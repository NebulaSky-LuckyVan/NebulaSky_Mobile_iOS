//
//  NSRTCCameraPreviewView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebRTC/RTCCameraPreviewView.h>
@interface NSRTCCameraPreviewView : RTCCameraPreviewView
- (void)tapCallBackHandler:(void(^)(void))handler;

@end

