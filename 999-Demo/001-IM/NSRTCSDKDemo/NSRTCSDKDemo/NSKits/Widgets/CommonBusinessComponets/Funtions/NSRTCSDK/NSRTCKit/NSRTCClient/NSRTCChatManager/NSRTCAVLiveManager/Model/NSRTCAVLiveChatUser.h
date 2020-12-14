//
//  NSRTCAVLiveChatUser.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 


#import <AVFoundation/AVCaptureSession.h>
@class RTCVideoTrack;
@class RTCAudioTrack;
@class RTCCameraPreviewView;
 
@interface NSRTCAVLiveChatUser : NSObject
@property (strong, nonatomic) NSString *roomId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *connectionId;
@property (strong, nonatomic) RTCVideoTrack *localVideoTrack;
@property (strong, nonatomic) RTCAudioTrack *localAudioTrack;
@property (strong, nonatomic) RTCVideoTrack *remoteVideoTrack;
@property (strong, nonatomic) RTCAudioTrack *remoteAudioTrack;
@property (strong, nonatomic) RTCCameraPreviewView *localVideoView;
@property (strong, nonatomic) AVCaptureSession *localCaputreSession;

+ (instancetype)userWithConnectionId:(NSString*)Id;

@end
 
