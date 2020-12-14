//
//  NSRTCEAGLVideoView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebRTC/RTCEAGLVideoView.h>

@interface NSRTCEAGLVideoView : RTCEAGLVideoView

- (void)tapCallBackHandler:(void(^)(void))handler;
@end

