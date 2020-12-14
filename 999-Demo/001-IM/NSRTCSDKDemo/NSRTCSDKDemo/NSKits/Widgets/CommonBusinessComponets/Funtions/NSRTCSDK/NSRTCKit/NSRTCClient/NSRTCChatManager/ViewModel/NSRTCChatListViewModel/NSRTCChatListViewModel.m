//
//  NSRTCChatListViewModel.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCChatListViewModel.h"
#import "NSRTCChatViewModel.h"
#import "NSRTCMessage.h"

@interface NSRTCChatListViewModel ()<NSRTCChatMessageIOProtocol>
@property (nonatomic, strong) NSMutableArray *conversations;

@end

@implementation NSRTCChatListViewModel

- (NSMutableArray *)conversations{
    if (!_conversations) {
        _conversations = [NSMutableArray array];
    }
    return _conversations;
}
+ (instancetype)modelWithViewCtrl:(NSViewController *)viewCtrl{
   NSRTCChatListViewModel *vmd =  [super modelWithViewCtrl:viewCtrl];
    if (vmd) {
        [vmd setup];
    }
    return vmd;
}
- (void)setup {
    // Do any additional setup after loading the view.
    [NSRTCChatManager shareManager].chatListPageViewModel = self;
    [[NSRTCChatManager shareManager] addDelegate:self];
}
- (void)dealloc {
    [[NSRTCChatManager shareManager] removeDelegate:self];
}

- (void)chatManager:(NSRTCChatManager *)manager receivedMessage:(NSRTCMessage*)message{
    NSString *conversationName = message.from;
    
    BOOL isRead = [conversationName isEqualToString:[NSRTCChatManager shareManager].currChatPageViewModel.toUser];
    [self addOrUpdateConversation:conversationName latestMessage:message isRead:isRead];
}

#pragma mark - Data
- (void)queryDataFromDB {
    NSArray *conversations = [[NSRTCChatMessageDBOperation shareInstance] queryAllConversations];
    [self.conversations addObjectsFromArray:conversations];
    !self.updateChatListHandlerBlock?:self.updateChatListHandlerBlock(self.conversations);
}

#pragma mark - Public

- (void)chatWithUser:(NSString*)user{
    if (![user isEqualToString:[NSRTCChatManager shareManager].user.currentUserID]) {
        NSRTCChatViewController *chatVC = [[NSRTCChatViewController alloc] initWithToUser:user];
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:chatVC animated:YES];
    }
}


- (NSRTCConversation *)isExistConversationWithToUser:(NSString *)toUser {
    NSRTCConversation *conversationModel;
    NSInteger index = 0;
    for (NSRTCConversation *conversation in self.conversations) {
        if ([conversation.userName isEqualToString:toUser]) {
            conversationModel = conversation;
            break;
        }
        index++;
    }
    return conversationModel;
}

- (void)addOrUpdateConversation:(NSString *)conversationName latestMessage:(NSRTCMessage *)message isRead:(BOOL)isRead{
    
    NSRTCConversation *conversation = [self isExistConversationWithToUser:conversationName];
    if (conversation) {
        [self updateLatestMsgForConversation:conversation latestMessage:message isRead:isRead];
    }
    else {
        // 如果当前会话开启，则已读消息
        [self addConversationWithMessage:message conversationId:conversationName isReaded:isRead];
    }
}

- (void)addConversationWithMessage:(NSRTCMessage *)message conversationId:(NSString *)conversationId isReaded:(BOOL)read{
    
    NSRTCConversation *conversation = [[NSRTCConversation alloc] initWithMessageModel:message conversationId:conversationId];
    conversation.unReadCount = read?0:1;
    
    [self.conversations insertObject:conversation atIndex:0];
    !self.updateChatListHandlerBlock?:self.updateChatListHandlerBlock(self.conversations);
}

- (void)updateLatestMsgForConversation:(NSRTCConversation *)conversation latestMessage:(NSRTCMessage *)message isRead:(BOOL)isRead{
    
    conversation.unReadCount += 1;
    if (isRead) {
        conversation.unReadCount = 0;
    }
    conversation.latestMessage = message;
    // 将会话放到最前面
    [self.conversations removeObject:conversation];
    [self.conversations insertObject:conversation atIndex:0];
    !self.updateChatListHandlerBlock?:self.updateChatListHandlerBlock(self.conversations);
    
    
}

- (void)updateRedPointForUnreadWithConveration:(NSString *)conversationName {
    NSRTCConversation *conversation = [self isExistConversationWithToUser:conversationName];
    if (conversation) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.conversations indexOfObject:conversation] inSection:0];
        [self updateRedPointForCellAtIndexPath:indexPath];
    }
}
// 打开会话，更新未读消息数量
- (void)updateRedPointForCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NSRTCConversation *model = self.conversations[indexPath.row];
    model.unReadCount = 0; 
    !self.updateConversationReadStatusHandlerBlock?:self.updateConversationReadStatusHandlerBlock(indexPath);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
