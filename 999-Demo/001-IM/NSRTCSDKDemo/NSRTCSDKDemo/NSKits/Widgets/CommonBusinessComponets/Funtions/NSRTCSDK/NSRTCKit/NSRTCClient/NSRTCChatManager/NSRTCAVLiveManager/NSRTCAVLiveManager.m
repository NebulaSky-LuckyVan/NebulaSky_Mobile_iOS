//
//  NSRTCAVLiveManager.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCAVLiveManager.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


#import <WebRTC/WebRTC.h>



#import "NSRTCChatManager.h"

#import "UIView+Common.h"

#import "NSRTCClient.h"



#import "NSRTCAVLiveConnectionManager.h"
@interface NSRTCAVLiveManager ()
@property (strong, nonatomic) RTCCameraVideoCapturer* capture;
@property (strong, nonatomic) RTCCameraPreviewView *localVideoView;
/* Generate manager for single (or mutiple) videos connections */
@property (strong, nonatomic) NSRTCAVLiveConnectionManager *connectionManager;


@property (weak, nonatomic) id<NSRTCAVLiveConnectionProtocol> delegate;

@property (assign, nonatomic) NSRTCAVLiveMediaServicesType mediaSType;

@end
@implementation NSRTCAVLiveManager

static NSRTCAVLiveManager* _instance;
+ (instancetype)shareInstance {
    return [[self alloc]init];
}
+ (instancetype)toolWithPeerConnectionDelegate:(id<NSRTCAVLiveConnectionProtocol>)delegate{
    return [NSRTCAVLiveManager toolWithPeerConnectionDelegate:delegate mediaServicesType:NSRTCAVLiveMediaServices_Audio_Video];
}
+ (instancetype)toolWithPeerConnectionDelegate:(id<NSRTCAVLiveConnectionProtocol>)delegate mediaServicesType:(NSRTCAVLiveMediaServicesType)mediaSType{
    NSRTCAVLiveManager *tool = [NSRTCAVLiveManager shareInstance];
    tool.mediaSType = mediaSType;
    tool.delegate = delegate;
    return tool;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance  = [super init];
        _instance.mediaSType = NSRTCAVLiveMediaServices_Audio_Video;
    });
    return _instance;
}
- (id)copy{
    return _instance;
}
- (id)mutableCopy {
    return _instance;
}
- (RTCCameraPreviewView *)localVideoView{
    if (!_localVideoView) {
        _localVideoView = [[RTCCameraPreviewView alloc]initWithFrame:CGRectZero];
    }
    return _localVideoView;
}
//==============================================================================================================================================================//
  
- (AVCaptureSession*) startCaptureWithCameraPosition:(AVCaptureDevicePosition)position mediaChatRoom:(NSString *)room CompletionHandler:(void (^)(NSError *))complection{
    AVCaptureSession *caputreSession = nil;
    ///*DESC:创建音轨*/
    NSDictionary* mandatoryConstraints = @{};
    
    RTCMediaConstraints* constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatoryConstraints
                                                                             optionalConstraints:nil];
    RTCAudioSource* audioSource = [self.connectionManager.factory audioSourceWithConstraints: constraints];
    
    RTCAudioTrack* localAudioTrack = [self.connectionManager.factory audioTrackWithSource:audioSource trackId:@"ADRAMSa0"];
    
    AVCaptureDevice* device = [self checkCameraAuthorityThenRequestDeviceWithCameraPosition:position];
    if (device){
        ///*DESC:创建视频轨*/
        RTCVideoSource* videoSource = [self.connectionManager.factory videoSource];
        self.capture.delegate = videoSource;
        AVCaptureDeviceFormat* format = [[RTCCameraVideoCapturer supportedFormatsForDevice:device] lastObject];
        CGFloat fps = [[format videoSupportedFrameRateRanges] firstObject].maxFrameRate;
        RTCVideoTrack *localVideoTrack = [self.connectionManager.factory videoTrackWithSource:videoSource trackId:@"ARDAMSv0"];
        caputreSession = self.capture.captureSession;
        [self.connectionManager setLocalVideoTrack:localVideoTrack localAudioTrack:localAudioTrack chatRoom:room];
        self.connectionManager.delegate = self.delegate;
        self.localVideoView.captureSession = caputreSession;
        [self.capture startCaptureWithDevice:device
                                      format:format
                                         fps:fps
                           completionHandler:complection];
        
    }
    return caputreSession;
}

- (void)changeCameraPosition:(AVCaptureDevicePosition)position{
    [self.capture stopCapture];
    AVCaptureSession *caputreSession = nil;
    AVCaptureDevice* device = [self checkCameraAuthorityThenRequestDeviceWithCameraPosition:position];
    if (device){
        AVCaptureDeviceFormat* format = [[RTCCameraVideoCapturer supportedFormatsForDevice:device] lastObject];
        CGFloat fps = [[format videoSupportedFrameRateRanges] firstObject].maxFrameRate;
        caputreSession = self.capture.captureSession;
        self.connectionManager.delegate = self.delegate;
        self.localVideoView.captureSession = caputreSession;
        [self.capture startCaptureWithDevice:device format:format fps:fps];
    }
}
- (AVCaptureDevice* )checkCameraAuthorityThenRequestDeviceWithCameraPosition:(AVCaptureDevicePosition)p{
    NSArray<AVCaptureDevice* >* captureDevices = [self captureDevices];
    AVCaptureDevicePosition position = AVCaptureDevicePositionFront;
    if (p) {
        position = p;
    }
    AVCaptureDevice* device = nil;
    for (AVCaptureDevice* obj in captureDevices) {
        if (obj.position == position) {
            device = obj;
            break;
        }
    }
    //检测摄像头权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机访问受限");
        [UIView showStatus:@"没有权限访问相机"];
    }
    return device;
}
- (NSArray<AVCaptureDevice*>*)captureDevices{
    return [RTCCameraVideoCapturer captureDevices];
}


-(void)changeRemoteMicrophoneEnabled:(BOOL)enable withConnectinId:(NSString*)connectionId from:(NSString*)fromUser to:(NSString*)toUser{
    [self.connectionManager  enableRemoteAudioTrack:enable withConnectinId:connectionId from:fromUser to:toUser];
}
-(void)changeLocalMicrophoneEnabled:(BOOL)enable withConnectinId:(NSString*)connectionId from:(NSString*)fromUser to:(NSString*)toUser {
    [self.connectionManager  enableLocalAudioTrack:enable withConnectinId:connectionId from:fromUser to:toUser];
}

- (void)startAudioChatWithMediaChatRoom:(NSString *)room CompletionHandler:(void (^)(NSError *))complection{
    
    ///*DESC:创建音轨*/
    NSDictionary* mandatoryConstraints = @{};
    
    RTCMediaConstraints* constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatoryConstraints
                                                                             optionalConstraints:nil];
    RTCAudioSource* audioSource = [self.connectionManager.factory audioSourceWithConstraints: constraints];
    
    RTCAudioTrack* localAudioTrack = [self.connectionManager.factory audioTrackWithSource:audioSource trackId:@"ADRAMSa0"];
    
    [self.connectionManager setLocalVideoTrack:nil localAudioTrack:localAudioTrack chatRoom:room];
    self.connectionManager.delegate = self.delegate;
    !complection?:complection(nil);
    
    
}





- (RTCPeerConnection *)createPeerConnection:(NSString *)connectionId{
    if (!connectionId ||connectionId.length==0){
        return nil ;
    }
    NSRTCAVLivePeerConnectionMediaTrackType mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio_Video;
    switch (self.mediaSType) {
        case NSRTCAVLiveMediaServices_Audio:{
            mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio;
        }break;
        case NSRTCAVLiveMediaServices_Video:{
            mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Video;
        }break;
        case NSRTCAVLiveMediaServices_Audio_Video:{
            mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio_Video;
        }break;
        default:
            break;
    }
    RTCPeerConnection * conc = [self.connectionManager createPeerConnection:connectionId withMediaTrackType:mediaTrackType];
    return conc;
}
- (void)closePeerConnectionWithConnectionId:(NSString*)connectionId{
    __weak typeof(self)weakSelf = self;
    [self.connectionManager.connectionIds enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:connectionId]) {
            [weakSelf.connectionManager closePeerConnection:obj];
            *stop = YES;
        }
    }];

}
- (void)emptyPeerConnection{
    __weak typeof(self)weakSelf = self;
    [self.connectionManager.connectionIds enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.connectionManager closePeerConnection:obj];
    }];
}

- (void)emptyPeerConnectionFactory{
    if (self.connectionManager.factory) {
        self.connectionManager.factory = nil;
    }
}
- (void)checkPeerConnectionWithConnectionId:(NSString*)Id{
    if (!Id||Id.length==0) { return; }
    if (![self.connectionManager.connectionIds containsObject:Id]) {
        NSRTCAVLivePeerConnectionMediaTrackType mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio_Video;
          switch (self.mediaSType) {
              case NSRTCAVLiveMediaServices_Audio:{
                  mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio;
              }break;
              case NSRTCAVLiveMediaServices_Video:{
                  mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Video;
              }break;
              case NSRTCAVLiveMediaServices_Audio_Video:{
                  mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio_Video;
              }break;
                  
              default:
                  break;
          }
        [self.connectionManager createPeerConnection:Id withMediaTrackType:mediaTrackType];
    }
    
}
- (void)stopCaputre{
    if(self.capture) {
        //官方，SDK内部线程调度不在主线程。。。导致闪退 暂时屏蔽
//        [self.capture stopCaptureWithCompletionHandler:^{
//            NSLog(@"%s",__func__);
//        }];
        self.capture.delegate = nil;
        self.capture = nil;
    }
}
- (NSArray *)getCurrConnectionIds{
    return [self.connectionManager.connectionIds copy];
}


-(RTCCameraVideoCapturer *)capture{
    if (!_capture) {
        RTCVideoSource* videoSource = [self.connectionManager.factory videoSource];
        _capture = [[RTCCameraVideoCapturer alloc] initWithDelegate:videoSource];
    }
    return _capture;
}
//==============================================================================================================================================================//
 

//
- (void)addRemoteIceCandidate:(NSDictionary*)responseData{
    
    NSString* desc = responseData[@"candidate"];
    NSString* sdpMLineIndex = responseData[@"label"];
    int index = [sdpMLineIndex intValue];
    NSString* sdpMid = responseData[@"id"];
    NSString* userId = responseData[@"userId"];
    RTCIceCandidate *candidate = [[RTCIceCandidate alloc] initWithSdp:desc
                                                        sdpMLineIndex:index
                                                               sdpMid:sdpMid];
    RTCPeerConnection *conc =  [self.connectionManager getPeerConnectionIdFromConnectionId:userId];
    if (conc) {
        [conc addIceCandidate:candidate];
    }
}

- (void)setRemoteSdpFromRemoteAnwser:(NSDictionary*)responseData{
    NSString *remoteAnswerSdp = responseData[@"sdp"];
    NSString* userId = responseData[@"userId"];
    if (!userId||userId.length==0) { return; }
    RTCSessionDescription *remoteSdp = [[RTCSessionDescription alloc]
                                        initWithType:RTCSdpTypeAnswer
                                        sdp: remoteAnswerSdp];
    RTCPeerConnection *conc =  [self.connectionManager getPeerConnectionIdFromConnectionId:userId];
    if (conc) {
        [conc setRemoteDescription:remoteSdp completionHandler:^(NSError * _Nullable error) {
              if(!error){
                  NSLog(@"Success to set remote Answer SDP");
              }else{
                  NSLog(@"Failure to set remote Answer SDP, err=%@", error);
              }
        }];
    }
}




 
//setLocalOffer
- (void)sendLocalSdpOffer:(RTCSessionDescription*)sdp withRoomId:(NSString*)roomId{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary* dict = [[NSDictionary alloc] initWithObjects:@[@"offer", sdp.sdp]
                                                           forKeys: @[@"type", @"sdp"]];
        [NSRTCClient shareClient].sendAVChatRoomMessage(roomId,dict);
        
    });
}
//setLocalAnwser
- (void)setLocalSdpAnwserFromRemoteSdpOffer:(NSDictionary*)responseData connectionId:(NSString *)Id complection:(void (^)(RTCSessionDescription *))block{
    NSString*remoteOfferSdp = responseData[@"sdp"];
    NSString*userId = responseData[@"userId"];
    if (!userId||userId.length == 0) {
        userId = Id;
    }
    if (!userId||userId.length == 0) { return; }
    RTCSessionDescription* remoteSdp = [[RTCSessionDescription alloc]  initWithType:RTCSdpTypeOffer sdp: remoteOfferSdp];
    RTCPeerConnection *connc = [self.connectionManager getPeerConnectionIdFromConnectionId:userId];
    if (!connc) {
        NSRTCAVLivePeerConnectionMediaTrackType mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio_Video;
           switch (self.mediaSType) {
                 case NSRTCAVLiveMediaServices_Audio:{
                     mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio;
                 }break;
                 case NSRTCAVLiveMediaServices_Video:{
                     mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Video;
                 }break;
                 case NSRTCAVLiveMediaServices_Audio_Video:{
                     mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio_Video;
                 }break;
                     
                 default:
                     break;
             }
           
        connc = [self.connectionManager createPeerConnection:userId withMediaTrackType:mediaTrackType];
    }
    if (connc) {
        __weak typeof(RTCPeerConnection*)weakConnc  = connc;
        [connc setRemoteDescription:remoteSdp completionHandler:^(NSError * _Nullable error) {
            if (!error) {
                [weakConnc answerForConstraints:[self.connectionManager defalutMediaConstraints] completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
                    [weakConnc setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
                        if(!error){
                            NSLog(@"Successed to set local answer!");
                        }else {
                            NSLog(@"Failed to set local answer, err=%@", error);
                        }
                    }];
                    
                    !block?:block(sdp);
                }];
            }else{
                NSLog(@"setLocalSdpAnwserFromRemoteSdpOffer fail :%@",error);
            }
        }];
    }
}

- (void)sendLocalSdpAnwser:(RTCSessionDescription*)sdp withRoomId:(NSString*)roomId{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //send answer sdp
        NSDictionary* dict = [[NSDictionary alloc] initWithObjects:@[@"answer", sdp.sdp]
                                                           forKeys: @[@"type", @"sdp"]];
        
        [NSRTCClient shareClient].sendAVChatRoomMessage(roomId,dict);
    });
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection setLocalDescriptionWithSdp:(RTCSessionDescription*)sdp complectionHandler:(void(^)(RTCPeerConnection *peerC,RTCSessionDescription*sessionDescp,NSError *error))block{
    __weak typeof(RTCPeerConnection *) weakPeerConnection = peerConnection;
    [peerConnection setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successed to set local offer sdp!");
        }else{
            NSLog(@"Failed to set local offer sdp, err=%@", error);
        }
        !block?:block(weakPeerConnection,sdp,error);
    }];
}
//Generate  an Local SDP offer
- (void)peerConnection:(RTCPeerConnection *)peerConnection generateSdpOffer:(void(^)(RTCPeerConnection *peerConnection,RTCSessionDescription *sdp,NSError *error))complection{
    __weak typeof(RTCPeerConnection *) weakPeerConnection = peerConnection;
    [weakPeerConnection offerForConstraints:[self.connectionManager defalutMediaConstraints]
                          completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
                              if(error){
                                  NSLog(@"Failed to create offer SDP, err=%@", error);
                              } else {
                                  NSLog(@"Successed to create offer SDP");
                              }
                              !complection?:complection(weakPeerConnection,sdp,error);
                          }];
}
- (void)startPeerConnectionWithConnectionId:(NSString*)connectionId setLocalSdpComplection:(void(^)(RTCSessionDescription *sessionDescp))block{
    if(!connectionId||connectionId.length==0)return;
    NSRTCAVLivePeerConnectionMediaTrackType mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio_Video;
    switch (self.mediaSType) {
          case NSRTCAVLiveMediaServices_Audio:{
              mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio;
          }break;
          case NSRTCAVLiveMediaServices_Video:{
              mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Video;
          }break;
          case NSRTCAVLiveMediaServices_Audio_Video:{
              mediaTrackType = NSRTCAVLivePeerConnectionMediaTrack_Audio_Video;
          }break;
              
          default:
              break;
      }
    
    RTCPeerConnection * conc = [self.connectionManager createPeerConnection:connectionId withMediaTrackType:mediaTrackType];
    __weak typeof(self) weakSelf = self;
    [self peerConnection:conc generateSdpOffer:^(RTCPeerConnection *peerConnection, RTCSessionDescription *sdp, NSError *error) {
        if (!error) {
            [weakSelf peerConnection:peerConnection setLocalDescriptionWithSdp:sdp complectionHandler:^(RTCPeerConnection *peerC, RTCSessionDescription *sessionDescp, NSError *error) {
                if (!error) {
                    !block?:block(sessionDescp);
                }else{
                    NSLog(@"setLocalDescription Fail:%@",[error description]);
                }
            }];
        }else{
            NSLog(@"generateSdpOffer Fail:%@",[error description]);
        }
    }];
    
    
}
//==============================================================================================================================================================//
-(NSRTCAVLiveConnectionManager *)connectionManager{
    if (!_connectionManager) {
        _connectionManager = [NSRTCAVLiveConnectionManager shareInstance];
    }
    return _connectionManager;
} 
@end
