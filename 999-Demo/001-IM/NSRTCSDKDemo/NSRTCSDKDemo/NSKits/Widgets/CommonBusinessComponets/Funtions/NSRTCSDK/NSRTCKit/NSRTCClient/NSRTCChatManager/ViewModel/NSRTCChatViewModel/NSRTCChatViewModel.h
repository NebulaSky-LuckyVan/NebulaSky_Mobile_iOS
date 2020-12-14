//
//  NSRTCChatViewModel.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCViewModel.h"
 

@class NSRTCMessage;
@class NSRTCConversation;

typedef void(^CallReceiveMessageHandler)(NSMutableArray*dataSource);
typedef void(^CallUpdateSendStatusWithMessageHandler)(NSRTCMessage*message);

typedef void(^CallChatListConversationUpdateHandler)(NSMutableArray *conversations);

typedef void(^CallConversationReadStatusUpdateHandler)(NSIndexPath *indexPath);

typedef void(^CallStartAVPhoneCallWithUserHandler)(NSString *user);

@interface NSRTCChatViewModel : NSRTCViewModel


@property (nonatomic, copy) NSString *toUser;
 


@property (copy, nonatomic) CallReceiveMessageHandler updateAfterReceivingMessageHandlerBlock;
@property (copy, nonatomic) CallUpdateSendStatusWithMessageHandler updateSendStatusWithMessageHandlerBlock;
@property (copy, nonatomic) CallStartAVPhoneCallWithUserHandler startAVPhoneCallWithUserHandler;

- (void)queryDataFromDB:(void(^)(NSArray *datasource))ComplectionHandlerBlock;





/**
 将当前会话添加到消息列表中
 */
- (void)addCurrentConversationToChatList;
/**
 发送文本消息
 
 @param text 文本
 */
- (void)sendTextMessageWithText:(NSString *)text ;

/**
 发送语音
 
 @param audioSavePath 语音保存路径
 @param duration 语音持续时长
 */
- (void)sendAudioMessageWithAudioSavePath:(NSString *)audioSavePath duration:(CGFloat)duration ;
 
/**
 发送图片消息
 
 @param imgData 图片文件
 */
- (void)sendImageMessageWithImgData:(NSData *)imgData image:(UIImage *)image size:(NSDictionary *)size;


/**
 发送定位
 
 @param location 地位坐标
 @param locationName 定位名字
 */
- (void)sendLocationMessageWithLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName detailLocationName:(NSString *)detailLocationName;

// 更新消息列表未读消息数量, 更新数据库
- (void)updateUnreadMessageRedIconForListAndDB ;

- (void)updateSendStatusUIWithMessage:(NSRTCMessage *)message;

@end
 
