//
//  NSRTCAVLiveManager.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureDevice.h>
@class RTCPeerConnection;
@class RTCSessionDescription;
@class RTCCameraPreviewView;

@protocol NSRTCAVLiveConnectionProtocol;


typedef NS_ENUM(NSUInteger,NSRTCAVLiveMediaServicesType) {
    NSRTCAVLiveMediaServices_Audio  = 0,
    NSRTCAVLiveMediaServices_Video,
    NSRTCAVLiveMediaServices_Audio_Video,
};

@interface NSRTCAVLiveManager : NSObject


+ (instancetype)shareInstance;
+ (instancetype)toolWithPeerConnectionDelegate:(id<NSRTCAVLiveConnectionProtocol>)delegate;
+ (instancetype)toolWithPeerConnectionDelegate:(id<NSRTCAVLiveConnectionProtocol>)delegate mediaServicesType:(NSRTCAVLiveMediaServicesType)mediaSType;


@property (strong, nonatomic,readonly) RTCCameraPreviewView *localVideoView;


- (AVCaptureSession*)startCaptureWithCameraPosition:(AVCaptureDevicePosition)position mediaChatRoom:(NSString*)room CompletionHandler:(void(^)(NSError *err))complection ;

- (void)changeCameraPosition:(AVCaptureDevicePosition)position;


- (void)changeLocalMicrophoneEnabled:(BOOL)enable withConnectinId:(NSString*)connectionId from:(NSString*)fromUser to:(NSString*)toUser;
- (void)changeRemoteMicrophoneEnabled:(BOOL)enable withConnectinId:(NSString*)connectionId from:(NSString*)fromUser to:(NSString*)toUser;

- (void)startAudioChatWithMediaChatRoom:(NSString *)room CompletionHandler:(void (^)(NSError *))complection;

//setLocalOffer
- (RTCPeerConnection *)createPeerConnection:(NSString *)connectionId;

- (void)closePeerConnectionWithConnectionId:(NSString*)connectionId;

- (void)startPeerConnectionWithConnectionId:(NSString*)connectionId setLocalSdpComplection:(void(^)(RTCSessionDescription *sessionDescp))block;

- (void)checkPeerConnectionWithConnectionId:(NSString*)Id;
//sendLocalSdpOffer
- (void)sendLocalSdpOffer:(RTCSessionDescription*)sdp withRoomId:(NSString*)roomId;
//setLocalAnwser
- (void)setLocalSdpAnwserFromRemoteSdpOffer:(NSDictionary*)responseData connectionId:(NSString*)Id complection:(void(^)(RTCSessionDescription*sdp))block;
//sendLocalAnwser
- (void)sendLocalSdpAnwser:(RTCSessionDescription*)sdp withRoomId:(NSString*)roomId;

- (void)addRemoteIceCandidate:(NSDictionary*)responseData;

- (void)setRemoteSdpFromRemoteAnwser:(NSDictionary*)responseData;
 

- (void)stopCaputre;

- (NSArray*)getCurrConnectionIds;

- (void)emptyPeerConnection;

- (void)emptyPeerConnectionFactory;
@end
 
