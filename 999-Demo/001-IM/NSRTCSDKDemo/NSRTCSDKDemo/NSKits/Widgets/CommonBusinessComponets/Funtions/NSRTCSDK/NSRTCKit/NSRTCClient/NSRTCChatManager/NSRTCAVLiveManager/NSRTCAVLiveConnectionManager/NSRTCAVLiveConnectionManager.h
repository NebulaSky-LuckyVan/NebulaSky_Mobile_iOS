//
//  NSRTCAVLiveConnectionManager.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RTCPeerConnection;
@class RTCIceCandidate;
@class RTCMediaConstraints;
@class RTCVideoTrack;
@class RTCAudioTrack;
@class RTCPeerConnectionFactory;


@protocol NSRTCAVLiveConnectionProtocol ;


typedef NS_ENUM(NSUInteger,NSRTCAVLivePeerConnectionMediaTrackType) {
      NSRTCAVLivePeerConnectionMediaTrack_Audio = 0,
      NSRTCAVLivePeerConnectionMediaTrack_Video ,
      NSRTCAVLivePeerConnectionMediaTrack_Audio_Video
};

/*
 * Generate manager for single (or mutiple) videos connections
 */
@interface NSRTCAVLiveConnectionManager : NSObject

+ (instancetype)shareInstance;

- (void)setLocalVideoTrack:(RTCVideoTrack*)vTrack localAudioTrack:(RTCAudioTrack*)aTrack chatRoom:(NSString*)room;

- (void)enableRemoteAudioTrack:(BOOL)enable withConnectinId:(NSString*)connectionId from:(NSString*)fromUser to:(NSString*)toUser;

- (void)enableLocalAudioTrack:(BOOL)enable withConnectinId:(NSString*)connectionId from:(NSString*)fromUser to:(NSString*)toUser;

- (RTCMediaConstraints *)defalutMediaConstraints;

@property (weak, nonatomic) id <NSRTCAVLiveConnectionProtocol> delegate;
@property (strong, nonatomic) RTCPeerConnectionFactory* factory;
@property (strong, nonatomic) RTCVideoTrack *localVideoTrack;
@property (strong, nonatomic) RTCAudioTrack *localAudioTrack;


@property (strong, nonatomic ,readonly) NSString *mediaChatRoom;
@property (strong, nonatomic ,readonly) NSMutableArray       * connectionIds;
@property (strong, nonatomic ,readonly) NSMutableDictionary  * connectionsDict;
@property (strong, nonatomic ,readonly) NSMutableDictionary  * remoteAudioTracksDict;
@property (strong, nonatomic ,readonly) NSMutableDictionary  * remoteVideoTracksDict;

- (RTCPeerConnection *)createPeerConnection:(NSString *)connectionId;
- (RTCPeerConnection *)createPeerConnection:(NSString *)connectionId withMediaTrackType:(NSRTCAVLivePeerConnectionMediaTrackType)mediaTrackType;
- (void)closePeerConnection:(NSString *)connectionId;


- (RTCPeerConnection *)getPeerConnectionIdFromConnectionId:(NSString *)connectionId;

- (NSString *)getConnectionIdFromConnectionsDic:(RTCPeerConnection *)peerConnection;

@end


@protocol NSRTCAVLiveConnectionProtocol <NSObject>

@optional

- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager closeConnectionWithId:(NSString*)Id;

- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager didGenerateIceCandidate:(RTCIceCandidate*)candidate;

- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager addRemoteVideoTrackWithConnectionId:(NSString*)Id;
- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager removeRemoteVideoTrackWithConnectionId:(NSString*)Id;



- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager addRemoteAudioTrackWithConnectionId:(NSString*)Id;
- (void)connectionManager:(NSRTCAVLiveConnectionManager*)manager removeRemoteAudioTrackWithConnectionId:(NSString*)Id;

@end

