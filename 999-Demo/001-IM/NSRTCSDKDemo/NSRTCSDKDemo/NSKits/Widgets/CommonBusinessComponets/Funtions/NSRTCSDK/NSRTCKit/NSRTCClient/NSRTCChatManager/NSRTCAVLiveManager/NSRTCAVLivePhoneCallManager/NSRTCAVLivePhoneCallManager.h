//
//  NSRTCAVLivePhoneCallManager.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h> 

#import "NSRTCAVLiveChatUser.h"



typedef NS_ENUM(NSUInteger,NSRTCAVLiveMediaPhoneCallType) {
   NSRTCAVLiveSingleAudioPhoneCall  = 0,//音频电话单聊
   NSRTCAVLiveSingleVideoPhoneCall,//视频电话单聊
   NSRTCAVLiveGroupAudioPhoneCall,//音频电话群聊
   NSRTCAVLiveGroupVideoPhoneCall,//视频电话群聊
};
@protocol NSRTCAVLivePhoneCallProtocol;
@interface NSRTCAVLivePhoneCallManager : NSObject

+ (instancetype)managerWithCallType:(NSRTCAVLiveMediaPhoneCallType)callType;

+ (instancetype)shareInstance;

- (void)endPhoneCall;

@property (strong, nonatomic) NSString *singleCallFromUser;

@property (strong, nonatomic) NSString *singleCallToUser;

@property (strong, nonatomic) NSString *mediaChatRoom;

@property (weak,   nonatomic) id<NSRTCAVLivePhoneCallProtocol> delegate;


//初始化socket并且连接
- (void)connectServer:(NSString *)server port:(NSString *)port room:(NSString *)room userToken:(NSString*)token;

- (void)requestSingleChatRoomWithTargetUser:(NSString*)toUser success:(void(^)(NSString*roomId))successHandler fail:(void(^)(void))failHandler;
/**
 *  加入房间
 */
- (void)joinAVChatRoom:(NSString *)room;
/**
 *  拒接电话
 */
- (void)rejectSinglePhoneCall:(NSDictionary*)user;
/**
 *  退出房间
 */
- (void)exitRoom;

/**
 *  加入群聊
 */
- (void)user:(NSString*)userId joinGroupChatWithRoomId:(NSString*)room;

/**
 *  离开群聊
 */
- (void)user:(NSString*)userId leaveGroupChatWithRoomId:(NSString*)room;

- (void)changeCamera;

- (void)changeRemoteVoiceEnable;
- (void)changeLocalVoiceEnable;

@end

@protocol NSRTCAVLivePhoneCallProtocol <NSObject>

- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager joinedWithUser:(NSRTCAVLiveChatUser*)user;
- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager byeWithConnectionId:(NSString*)connectionId;
- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager rejectedWithConnectionId:(NSString*)connectionId;
- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager fullWithRoomId:(NSString*)roomId;
- (void)callManager:(NSRTCAVLivePhoneCallManager*)manager leaveAllWithRoomId:(NSString*)roomId;

@end
 
