//
//  NSRTCChatViewModel.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCChatViewModel.h"


#import "NSRTCChatManager.h"

#import "NSRTCChatMessageDBOperation.h"

#import "NSRTCMessage.h"

#import "NSRTCChatUser.h"




#import "NSRTCChatViewModel.h"
#import "NSRTCChatListViewModel.h"
#import "UIView+Common.h"

 
@interface NSRTCChatViewModel ()<NSRTCChatMessageIOProtocol>

@property (nonatomic, assign) BOOL loadAllMessage;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end
@implementation NSRTCChatViewModel

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

+ (instancetype)modelWithViewCtrl:(NSViewController *)viewCtrl{
    NSRTCChatViewModel *viewModel = [super modelWithViewCtrl:viewCtrl];
    if (viewModel) {
        [viewModel setup];
    }
    return viewModel;
}


- (void)setup{
    // Do any additional setup after loading the view.
    [NSRTCChatManager shareManager].currChatPageViewModel = self;
    [[NSRTCChatManager shareManager] addDelegate:self];
    [self performSelector:@selector(updateUnreadMessageRedIconForListAndDB) withObject:nil afterDelay:0.5];
}



#pragma mark - Data
- (void)queryDataFromDB:(void(^)(NSArray *datasource))ComplectionHandlerBlock {
    
    
    if (self.loadAllMessage) {
        
        [UIView showStatus:@"没有更多消息记录"];
        !ComplectionHandlerBlock?:ComplectionHandlerBlock(self.dataSource);
        return;
    }
    NSInteger limit = 10;
    NSArray *dataArray = [[NSRTCChatMessageDBOperation shareInstance] queryMessagesWithUser:self.toUser limit:limit page:_currentPage];
    
    _currentPage ++;
    if (dataArray.count < limit) {
        self.loadAllMessage = YES;
    }
    [self.dataSource insertObjects:dataArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dataArray.count)]];
    !ComplectionHandlerBlock?:ComplectionHandlerBlock(self.dataSource);
}

/**
 将当前会话添加到消息列表中
 */
- (void)addCurrentConversationToChatList {
    
    if (self.dataSource.count) { // 当前会话中有消息记录
        NSRTCMessage *message = [self.dataSource lastObject];
        if ([message.from isEqualToString:[NSRTCChatManager shareManager].user.currentUserID]) { // 消息是自己发送的，则更新消息列表最新消息UI（接收到别人的消息, chatListVC会更新UI,这里不做处理）
            [[NSRTCChatManager shareManager].chatListPageViewModel addOrUpdateConversation:message.to latestMessage:message isRead:YES];
        }
    }
}
/**
 发送文本消息
 
 @param text 文本
 */
- (void)sendTextMessageWithText:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    NSRTCMessage *message = [[NSRTCChatManager shareManager] sendTextMessage:text toUser:_toUser sendStatus:^(NSRTCMessage *newMessage) {
        
        [weakSelf updateSendStatusUIWithMessage:newMessage];
    }];
    [self chatManager:nil receivedMessage:message];
}

/**
 发送语音
 
 @param audioSavePath 语音保存路径
 @param duration 语音持续时长
 */
- (void)sendAudioMessageWithAudioSavePath:(NSString *)audioSavePath duration:(CGFloat)duration {
    __weak typeof(self) weakSelf = self;
    NSRTCMessage *message = [[NSRTCChatManager shareManager] sendAudioMessage:audioSavePath duration:duration toUser:_toUser sendStatus:^(NSRTCMessage *newMessage) {
        [weakSelf updateSendStatusUIWithMessage:newMessage];
    }];
    [self chatManager:nil receivedMessage:message];
}
 

/**
 发送图片消息
 
 @param imgData 图片文件
 */
- (void)sendImageMessageWithImgData:(NSData *)imgData image:(UIImage *)image size:(NSDictionary *)size{
    
    __weak typeof(self) weakSelf = self;
    NSRTCMessage *message = [[NSRTCChatManager shareManager] sendImgMessage:imgData  sImageData:UIImageJPEGRepresentation(image, 1) toUser:self.toUser sendStatus:^(NSRTCMessage *newMessage) {
        
        [weakSelf updateSendStatusUIWithMessage:newMessage];
    }];
    [self chatManager:nil receivedMessage:message];
}


/**
 发送定位
 
 @param location 地位坐标
 @param locationName 定位名字
 */
- (void)sendLocationMessageWithLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName detailLocationName:(NSString *)detailLocationName{
    __weak typeof(self) weakSelf = self;
    NSRTCMessage *message = [[NSRTCChatManager shareManager] sendLocationMessage:location locationName:locationName detailLocationName:detailLocationName toUser:self.toUser sendStatus:^(NSRTCMessage *newMessage) {
        
        [weakSelf updateSendStatusUIWithMessage:newMessage];
    }];
    [self chatManager:nil receivedMessage:message];
}

// 更新消息列表未读消息数量, 更新数据库
- (void)updateUnreadMessageRedIconForListAndDB {
    
    [[NSRTCChatManager shareManager].chatListPageViewModel updateRedPointForUnreadWithConveration:self.toUser];
    [[NSRTCChatMessageDBOperation shareInstance] updateUnreadCountOfConversation:self.toUser unreadCount:0];
}




- (void)chatManager:(NSRTCChatManager *)manager receivedMessage:(NSRTCMessage*)message{
    if (manager) { // 接收到的消息
        if ([message.from isEqualToString:message.to]) { // 自己发送给自己的消息
            // 不展示UI
            return;
        }
    }
    
    if (![message.from isEqualToString:self.toUser] && ![message.to isEqualToString:self.toUser]) { // 不是该会话的消息
        
        // 不展示UI
        return;
    }
    if ([message.from isEqualToString:self.toUser]||[message.from isEqualToString:[NSRTCChatManager shareManager].user.currentUserID]) {
        [self.dataSource addObject:message];
        !self.updateAfterReceivingMessageHandlerBlock?:self.updateAfterReceivingMessageHandlerBlock(self.dataSource);
    }
}

















 

#pragma mark - Pravite

/**
 刷新消息的发送状态
 
 @param message 消息
 */
- (void)updateSendStatusUIWithMessage:(NSRTCMessage *)message {
    
    NSInteger index = [self.dataSource indexOfObject:message];
    if (index >= 0) {
        !self.updateSendStatusWithMessageHandlerBlock?:self.updateSendStatusWithMessageHandlerBlock(message);
    }
}
- (void)dealloc {
    [[NSRTCChatManager shareManager] removeDelegate:self];
}
@end
