//
//  NSRTCAVLiveConnectionManager.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCAVLiveConnectionManager.h"


#import <WebRTC/WebRTC.h>

/*
 *  公网地址
 */
//static NSString *const RTCSTUNServerURL = @"turn:112.74.60.202:3478";
//static NSString *const RTCSTUNServerURLTransport = @"turn:112.74.60.202:3478?transport=udp";
static NSString *const RTCSTUNServerURL = @"turn:39.108.177.160:3478";
static NSString *const RTCSTUNServerURLTransport = @"turn:39.108.177.160:3478?transport=udp";


static NSString *const RTCFreeSTUNServerURL1 = @"stun:stun.l.google.com:19302";
static NSString *const RTCFreeSTUNServerURL2 = @"stun:stun1.l.google.com:19302";
static NSString *const RTCFreeSTUNServerURL3 = @"stun:stun2.l.google.com:19302";
static NSString *const RTCFreeSTUNServerURL4 = @"stun:stun3.l.google.com:19302";
static NSString *const RTCFreeSTUNServerURL5 = @"stun:stun4.l.google.com:19302";
static NSString *const RTCFreeSTUNServerURL6 = @"stun:stun.ekiga.net";
static NSString *const RTCFreeSTUNServerURL7 = @"stun:stun.ideasip.com";
static NSString *const RTCFreeSTUNServerURL8 = @"stun:stun.schlund.de";
static NSString *const RTCFreeSTUNServerURL9 = @"stun:stun.stunprotocol.org:3478";
static NSString *const RTCFreeSTUNServerURL10 = @"stun:stun.voiparound.com";
static NSString *const RTCFreeSTUNServerURL11 = @"stun:stun.voipbuster.com";
static NSString *const RTCFreeSTUNServerURL12 = @"stun:stun.voipstunt.com";
static NSString *const RTCFreeSTUNServerURL13 = @"stun:stun.voxgratia.org";
static NSString *const RTCFreeSTUNServerURL14 = @"stun:stun.services.mozilla.com";
@interface NSRTCAVLiveConnectionManager ()<RTCPeerConnectionDelegate>
 
@property (strong, nonatomic) NSString *mediaChatRoom;
/*链接List*/
@property (strong, nonatomic) NSMutableDictionary  * remoteAudioTracksDict;
@property (strong, nonatomic) NSMutableDictionary  * remoteVideoTracksDict;
@property (strong, nonatomic) NSMutableDictionary  * connectionsDict;
@property (strong, nonatomic) NSMutableArray  * connectionIds;

@property (strong, nonatomic) NSMutableArray *IceServers;

@end

@implementation NSRTCAVLiveConnectionManager

static id _instance;
- (void)setLocalVideoTrack:(RTCVideoTrack *)vTrack localAudioTrack:(RTCAudioTrack *)aTrack chatRoom:(NSString *)room{
    self.localVideoTrack = vTrack;
    self.localAudioTrack = aTrack;
    self.mediaChatRoom = room;
}
//Audio:@"ADRAMSa0"
//Video:@"ADRAMSv0"
//StreamId:@[@"ARDAMS"]
- (void)enableRemoteAudioTrack:(BOOL)enable withConnectinId:(NSString*)connectionId from:(NSString*)fromUser to:(NSString*)toUser{
    
    //默认认为本地拨出 也即是默认认为本地是 fromUser
    BOOL isLocalAsCaller = YES;
    RTCPeerConnection *conc = [self getPeerConnectionIdFromConnectionId:connectionId];
    if (!conc) {
        isLocalAsCaller = NO;
        if (toUser.length>0) {
            conc = [self getPeerConnectionIdFromConnectionId:toUser];
        }else if (fromUser.length>0){
            conc = [self getPeerConnectionIdFromConnectionId:fromUser];
        }
    }
    if (!isLocalAsCaller) {
        [conc.senders enumerateObjectsUsingBlock:^(RTCRtpSender <RTCRtpSender>* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RTCMediaStreamTrack *track =  obj.track;
            if ([track.trackId isEqualToString:@"ADRAMSa0"]) {
                RTCAudioTrack *audioTrack = (RTCAudioTrack*)track;
                [audioTrack setIsEnabled:enable];
                *stop = YES;
            }
        }];
    }else{
        [conc.receivers enumerateObjectsUsingBlock:^(RTCRtpReceiver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RTCMediaStreamTrack *track =  obj.track;
            if ([track.trackId isEqualToString:@"ADRAMSa0"]) {
                RTCAudioTrack *audioTrack = (RTCAudioTrack*)track;
                [audioTrack setIsEnabled:enable];
                *stop = YES;
            }
        }];
    }
    
}

- (void)enableLocalAudioTrack:(BOOL)enable withConnectinId:(NSString*)connectionId from:(NSString*)fromUser to:(NSString*)toUser{
    RTCPeerConnection *conc = [self getPeerConnectionIdFromConnectionId:connectionId];
    BOOL isLocalAsCaller = YES;
    if (!conc) {
        isLocalAsCaller = NO;
        if (toUser.length>0) {
            conc = [self getPeerConnectionIdFromConnectionId:toUser];
        }else if (fromUser.length>0){
            conc = [self getPeerConnectionIdFromConnectionId:fromUser];
        }
    }
    
    if (!isLocalAsCaller) {
        [conc.receivers enumerateObjectsUsingBlock:^(RTCRtpReceiver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RTCMediaStreamTrack *track =  obj.track;
            if ([track.trackId isEqualToString:@"ADRAMSa0"]) {
                RTCAudioTrack *audioTrack = (RTCAudioTrack*)track;
                [audioTrack setIsEnabled:enable];
                *stop = YES;
            }
        }];
    }else{
        [conc.senders enumerateObjectsUsingBlock:^(RTCRtpSender <RTCRtpSender>* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RTCMediaStreamTrack *track =  obj.track;
            if ([track.trackId isEqualToString:@"ADRAMSa0"]) {
                RTCAudioTrack *audioTrack = (RTCAudioTrack*)track;
                [audioTrack setIsEnabled:enable];
                *stop = YES;
            }
        }];
    }
}


+ (instancetype)shareInstance {
    return [[self alloc]init];
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
    });
    return _instance;
}
- (id)copy{
    return _instance;
}
- (id)mutableCopy {
    return _instance;
}

- (void)dealloc{
    __weak typeof(self) weakSelf = self;
    [self.connectionIds enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf closePeerConnection:obj];
    }];
}


/**
 *  创建peerConnection
 */
- (RTCPeerConnection *)createPeerConnection:(NSString *)connectionId
{
    RTCPeerConnection* connection = [self createPeerConnection:connectionId withMediaTrackType:NSRTCAVLivePeerConnectionMediaTrack_Audio_Video];
    
    return connection;
}

- (RTCPeerConnection *)createPeerConnection:(NSString *)connectionId withMediaTrackType:(NSRTCAVLivePeerConnectionMediaTrackType)mediaTrackType
{
    
    RTCConfiguration* configuration = [[RTCConfiguration alloc] init];
    [configuration setIceServers:self.IceServers];
    //用工厂来创建连接
    RTCPeerConnection *connection = [self.factory peerConnectionWithConfiguration:configuration constraints:[self defalutMediaConstraints] delegate:self];
    NSArray<NSString*>* mediaStreamLabels = @[@"ARDAMS"];
    switch (mediaTrackType) {
        case NSRTCAVLivePeerConnectionMediaTrack_Audio:{
            [connection addTrack:_localAudioTrack streamIds:mediaStreamLabels];
            
        }break;
        
        case NSRTCAVLivePeerConnectionMediaTrack_Video:{
            [connection addTrack:_localVideoTrack streamIds:mediaStreamLabels];
            
        }break;
        case NSRTCAVLivePeerConnectionMediaTrack_Audio_Video:{
            [connection addTrack:_localVideoTrack streamIds:mediaStreamLabels];
            [connection addTrack:_localAudioTrack streamIds:mediaStreamLabels];
            
        }break;

            
            
        default:
            break;
    }
    [self.connectionsDict setValue:connection forKey:connectionId];
    [self.connectionIds addObject:connectionId];
    return connection;
}

/**
 *  关闭peerConnection
 *
 */
- (void)closePeerConnection:(NSString *)connectionId
{
    RTCPeerConnection *peerConnection = [self.connectionsDict objectForKey:connectionId];
    if (peerConnection)
    {
        [peerConnection close];
    }
    [self.connectionIds removeObject:connectionId];
    [self.connectionsDict removeObjectForKey:connectionId];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(connectionManager:closeConnectionWithId:)])
        {
            [self.delegate connectionManager:weakSelf closeConnectionWithId:connectionId];
        }
    });
}

- (NSMutableDictionary *)remoteAudioTracksDict{
    if (!_remoteAudioTracksDict) {
        _remoteAudioTracksDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _remoteAudioTracksDict;
}
- (NSMutableDictionary *)remoteVideoTracksDict{
    if (!_remoteVideoTracksDict) {
        _remoteVideoTracksDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _remoteVideoTracksDict;
}
- (NSMutableDictionary *)connectionsDict{
    if (!_connectionsDict) {
        _connectionsDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _connectionsDict;
}
- (NSMutableArray *)connectionIds{
    if (!_connectionIds) {
        _connectionIds = [NSMutableArray array];
    }
    return _connectionIds;
}

- (RTCPeerConnectionFactory*)factory{
    if (!_factory) {
        //设置SSL传输
        [RTCPeerConnectionFactory initialize];
        RTCDefaultVideoDecoderFactory* decoderFactory = [[RTCDefaultVideoDecoderFactory alloc] init];
        RTCDefaultVideoEncoderFactory* encoderFactory = [[RTCDefaultVideoEncoderFactory alloc] init];
        NSArray* codecs = [encoderFactory supportedCodecs];
        [encoderFactory setPreferredCodec:codecs[2]];
        _factory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory: encoderFactory
                                                             decoderFactory: decoderFactory];
    }
    return _factory;
}
- (NSMutableArray*)IceServers{
    if (!_IceServers) {
        _IceServers = [[NSMutableArray alloc]init];
        [_IceServers addObject:[[RTCIceServer alloc] initWithURLStrings:@[RTCSTUNServerURL,RTCSTUNServerURLTransport]
                                                               username:@"Rufus"
                                                             credential:@"1q2w3e4r"]];
        
        
        [_IceServers addObject:[[RTCIceServer alloc] initWithURLStrings:
                                                                     @[RTCFreeSTUNServerURL1,
                                                                       RTCFreeSTUNServerURL2,
                                                                       RTCFreeSTUNServerURL3,
                                                                       RTCFreeSTUNServerURL4,
                                                                       RTCFreeSTUNServerURL5,
                                                                       RTCFreeSTUNServerURL6,
                                                                       RTCFreeSTUNServerURL7,
                                                                       RTCFreeSTUNServerURL8,
                                                                       RTCFreeSTUNServerURL9,
                                                                       RTCFreeSTUNServerURL10,
                                                                       RTCFreeSTUNServerURL11,
                                                                       RTCFreeSTUNServerURL12,
                                                                       RTCFreeSTUNServerURL13,
                                                                       RTCFreeSTUNServerURL14]
                                                               username:@""
                                                             credential:@""]];
        
    }
    return _IceServers;
}
- (RTCMediaConstraints *)defalutMediaConstraints{
    return [[RTCMediaConstraints alloc] initWithMandatoryConstraints:@{kRTCMediaConstraintsOfferToReceiveAudio:kRTCMediaConstraintsValueTrue
                                                                       ,kRTCMediaConstraintsOfferToReceiveVideo:kRTCMediaConstraintsValueTrue}
                                                 optionalConstraints:@{ @"DtlsSrtpKeyAgreement" : @"true" }];
}

- (RTCPeerConnection *)getPeerConnectionIdFromConnectionId:(NSString *)connectionId{
    RTCPeerConnection *conc = nil;
    if ([self.connectionIds containsObject:connectionId]) {
      conc =  self.connectionsDict[connectionId];
    }
    return conc;
}

- (NSString *)getConnectionIdFromConnectionsDic:(RTCPeerConnection *)peerConnection
{
    //find socketid by pc
    __block NSString *connectionId  = @"";
    [self.connectionsDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, RTCPeerConnection *obj, BOOL * _Nonnull stop) {
        if ([obj isEqual:peerConnection])
        {
            NSLog(@"%@",key);
            connectionId = key;
            *stop  = YES;
        }
    }];
    return connectionId;
}


#pragma RTCPeerConnectionDelegate

/** Called when the SignalingState changed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeSignalingState:(RTCSignalingState)stateChanged{
    NSLog(@"%s",__func__);
}

/** Called when media is received on a new stream from remote peer. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didAddStream:(RTCMediaStream *)stream{
    NSLog(@"%s",__func__);
}

/** Called when a remote peer closes a stream.
 *  This is not called when RTCSdpSemanticsUnifiedPlan is specified.
 */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveStream:(RTCMediaStream *)stream{
    NSLog(@"%s",__func__);
}

/** Called when negotiation is needed, for example ICE has restarted. */
- (void)peerConnectionShouldNegotiate:(RTCPeerConnection *)peerConnection{
    NSLog(@"%s",__func__);
}

/** Called any time the IceConnectionState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeIceConnectionState:(RTCIceConnectionState)newState{
    NSLog(@"%s",__func__);
}

/** Called any time the IceGatheringState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeIceGatheringState:(RTCIceGatheringState)newState{
    NSLog(@"%s",__func__);
}
//****GenerateIceCandidate****//
/** New ice candidate has been found. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didGenerateIceCandidate:(RTCIceCandidate *)candidate{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(connectionManager:didGenerateIceCandidate:)]){
            [self.delegate connectionManager:self didGenerateIceCandidate:candidate];
        }
    });
}

//****RemoveIceCandidates****//
/** Called when a group of local Ice candidates have been removed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveIceCandidates:(NSArray<RTCIceCandidate *> *)candidates{
    NSLog(@"%s",__func__);
}

/** New data channel has been opened. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didOpenDataChannel:(RTCDataChannel *)dataChannel{
    NSLog(@"%s",__func__);
}

/** Called when signaling indicates a transceiver will be receiving media from
 *  the remote endpoint.
 *  This is only called with RTCSdpSemanticsUnifiedPlan specified.
 */
/** Called any time the IceConnectionState changes following standardized
 * transition. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeStandardizedIceConnectionState:(RTCIceConnectionState)newState{
    NSLog(@"%s",__func__);
}

/** Called any time the PeerConnectionState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeConnectionState:(RTCPeerConnectionState)newState{
    NSLog(@"%s",__func__);
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection didStartReceivingOnTransceiver:(RTCRtpTransceiver *)transceiver{
    NSLog(@"%s",__func__);
}

//****didAddReceiver****//
/** Called when a receiver and its track are created. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didAddReceiver:(RTCRtpReceiver *)rtpReceiver streams:(NSArray<RTCMediaStream *> *)mediaStreams{
    
    RTCMediaStreamTrack* track = rtpReceiver.track;
    NSString *connectionId = [self getConnectionIdFromConnectionsDic:peerConnection];
    
    
    if([track.kind isEqualToString:kRTCMediaStreamTrackKindVideo]){
        RTCVideoTrack *videoTrack = (RTCVideoTrack*)track;
        [videoTrack setIsEnabled:YES];
        [self.remoteVideoTracksDict setValue:videoTrack forKey:connectionId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(connectionManager:addRemoteVideoTrackWithConnectionId:)])
            {
                [self.delegate connectionManager:self addRemoteVideoTrackWithConnectionId:connectionId];
            }
        });
    }else if ([track.kind isEqualToString:kRTCMediaStreamTrackKindAudio]){
        RTCAudioTrack *audioTrack = (RTCAudioTrack*)track;
        [self.remoteAudioTracksDict setValue:audioTrack forKey:connectionId];
        [audioTrack setIsEnabled:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(connectionManager:addRemoteAudioTrackWithConnectionId:)])
            {
                [self.delegate connectionManager:self addRemoteAudioTrackWithConnectionId:connectionId];
            }
        });
    }
    
}

//****didRemoveReceiver****//
/** Called when the receiver and its track are removed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveReceiver:(RTCRtpReceiver *)rtpReceiver{
    
    RTCMediaStreamTrack* track = rtpReceiver.track;
    NSString *connectionId = [self getConnectionIdFromConnectionsDic:peerConnection];
    
    if([track.kind isEqualToString:kRTCMediaStreamTrackKindVideo]){
        RTCVideoTrack *videoTrack = (RTCVideoTrack*)track;
        [videoTrack setIsEnabled:NO];
        [self.remoteVideoTracksDict removeObjectForKey:connectionId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(connectionManager:removeRemoteVideoTrackWithConnectionId:)])
            {
                [self.delegate connectionManager:self removeRemoteVideoTrackWithConnectionId:connectionId];
            }
        });
    }else if ([track.kind isEqualToString:kRTCMediaStreamTrackKindAudio]){
        RTCAudioTrack *audioTrack = (RTCAudioTrack*)track;
        [self.remoteAudioTracksDict removeObjectForKey:connectionId];
        [audioTrack setIsEnabled:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(connectionManager:removeRemoteAudioTrackWithConnectionId:)])
            {
                [self.delegate connectionManager:self removeRemoteAudioTrackWithConnectionId:connectionId];
            }
        });
    }
    
    
}
//====//
@end
