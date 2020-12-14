//
//  NSRTCChatManager.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//
 
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
 
@class NSRTCMessage;
@class NSRTCChatUser;
@class NSRTCChatManager;
@class NSRTCChatViewController;
@class NSRTCChatListViewController;
@class NSRTCChatViewModel;
@class NSRTCChatListViewModel;

 
 

@protocol NSRTCChatMessageIOProtocol <NSObject>

@optional
- (void)chatManager:(NSRTCChatManager *)manager receivedMessage:(NSRTCMessage*)message;


@end


@interface NSRTCChatMessageIOBridge : NSObject


@property (weak, nonatomic) id <NSRTCChatMessageIOProtocol>delegate;

+ (instancetype)bridgeWithReceiveMessageDelegate:(id <NSRTCChatMessageIOProtocol>)delegate;

@end

@interface NSRTCChatManager : NSObject

/*
 当前用户
 */
@property (strong, nonatomic) NSRTCChatUser *user;
 

/**
 正在聊天的会话控制器
 */
@property (nonatomic, weak) NSRTCChatViewModel *currChatPageViewModel;


/**
 消息会话列表
 */
@property (nonatomic, weak) NSRTCChatListViewModel *chatListPageViewModel;


@property (nonatomic, strong ,readonly) NSMutableArray *delegateItems;



+ (instancetype)shareManager;

- (void)setUserAuthToken:(NSString*)token currUserID:(NSString*)userId;
/**
 添加代理
 
 @param delegate 代理
 */
- (NSRTCChatMessageIOBridge*)addDelegate:(id)delegate;

/**
 移除代理
 
 @param delegate 代理
 */
- (void)removeDelegate:(id)delegate;

 





#pragma mark - message Input
/**
 发送文字消息
 
 @param text 图片数据
 @param toUser 发送目标
 @param sendStatus 状态改变返回消息模型
 @return 消息模型
 */
- (NSRTCMessage *)sendTextMessage:(NSString *)text toUser:(NSString *)toUser sendStatus:(void(^)(NSRTCMessage *message))sendStatus;



/**
 发送图片消息
 
 @param imgData 图片数据
 @param sImageData 小图数据
 @param toUser 发送目标
 @param sendStatus 状态改变返回消息模型
 @return 消息模型
 */
- (NSRTCMessage *)sendImgMessage:(NSData *)imgData sImageData:(NSData *)sImageData toUser:(NSString *)toUser sendStatus:(void(^)(NSRTCMessage *message))sendStatus;


/**
 发送语音
 
 @param audioDataPath 语音数据
 @param duration 语音时长
 @param toUser 发送目标
 @param sendStatus 状态改变返回消息模型
 @return 消息模型
 */
- (NSRTCMessage *)sendAudioMessage:(NSString *)audioDataPath duration:(CGFloat)duration toUser:(NSString *)toUser sendStatus:(void(^)(NSRTCMessage *message))sendStatus;

/**
 发送位置消息
 
 @param locationName 位置名称
 @param detailLocationName 详细位置名称
 @param toUser 发送目标人
 @param sendStatus 状态改变返回消息模型
 @return 消息模型
 */
- (NSRTCMessage *)sendLocationMessage:(CLLocationCoordinate2D)location locationName:(NSString *)locationName detailLocationName:(NSString *)detailLocationName toUser:(NSString *)toUser sendStatus:(void(^)(NSRTCMessage *message))sendStatus;

/**
 消息重发
 
 @param message 消息模型
 @param sendStatus 发送状态回调
 */
- (void)resendMessage:(NSRTCMessage *)message sendStatus:(void(^)(NSRTCMessage *message))sendStatus;




/**
 发起P2P音频电话消息 单聊
 
 @param message 消息
 */
- (void)beginP2PAudioCallMessage:(NSDictionary *)message;



/**
 发起P2P视频电话消息 单聊
 
 @param message 消息
 */
- (void)beginP2PVideoCallMessage:(NSDictionary *)message;




/**
 发起Group音频电话消息 群聊
 
 @param message 消息
 */
- (void)beginGroupAudioCallMessage:(NSDictionary *)message;



/**
 发起Group视频电话消息 群聊
 
 @param message 消息
 */
- (void)beginGroupVideoCallMessage:(NSDictionary *)message;



#pragma mark - message Output


/**
 收到富文本消息:文字、表情、图片、短音频、短视频
 
 @param message 消息
 */
- (void)receivedRichTextMessage:(NSDictionary*)message;



/**
 收到P2P音频电话消息 单聊
 
 @param message 消息
 */
- (void)receivedP2PAudioCallMessage:(NSDictionary *)message;



/**
 收到P2P视频电话消息 单聊
 
 @param message 消息
 */
- (void)receivedP2PVideoCallMessage:(NSDictionary *)message;

/**
 收到P2P视频电话消息的拒接 单聊
 
 @param user 用户
 */
- (void)receivedP2PVideoCallRejected:(NSString *)user;




/**
 收到Group音频电话消息 群聊
 
 @param message 消息
 */
- (void)receivedGroupAudioCallMessage:(NSDictionary *)message;



/**
 收到Group视频电话消息 群聊
 
 @param message 消息
 */
- (void)receivedGroupVideoCallMessage:(NSDictionary *)message;



//Desc:
@property (strong, nonatomic) NSString *deviceToken;

@end



