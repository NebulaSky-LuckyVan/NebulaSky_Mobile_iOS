//
//  NSRTCChatMessageDBOperation.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCChatMessageDBOperation.h"

#import "NSRTCChatManager.h"
#import "NSRTCMessage.h"
#import "NSRTCConversation.h"
#import "NSRTCChatUser.h"
#import <FMDB/FMDB.h>
#import <YYModel/YYModel.h>

#import "NSString+Common.h"
#import "NSDate+Common.h"
static NSRTCChatMessageDBOperation *instance = nil;

@interface NSRTCChatMessageDBOperation ()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMDatabaseQueue *DBQueue;

@end
@implementation NSRTCChatMessageDBOperation

#pragma mark - Lazy
- (FMDatabaseQueue *)DBQueue {
    
    NSString *dbName = [NSString stringWithFormat:@"%@.db", [NSRTCChatManager shareManager].user.currentUserID];
    NSString *path = _DBQueue.path;
    if (!_DBQueue || ![path containsString:dbName]) {
        NSString *tablePath = [[self DBMianPath] stringByAppendingPathComponent:dbName];
        
        _DBQueue = [FMDatabaseQueue databaseQueueWithPath:tablePath];
        [_DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
            
            // 打开数据库
            if ([db open]) {
                
                // 会话数据库表
                BOOL success = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS conversation (id TEXT NOT NULL, type INT1, ext TEXT, unreadcount Integer, latestmsgtext TEXT, latestmsgtimestamp INT32)"];
                if (success) {
                    NSLog(@"创建会话表成功");
                }
                else {
                    NSLog(@"创建会话表失败");
                }
                
                // 消息数据表
                BOOL msgSuccess = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS message (id TEXT NOT NULL, localtime INT32, timestamp INT32, conversation TEXT, msgdirection INT1, chattype TEXT, bodies TEXT, status INT1)"];
                if (msgSuccess) {
                    NSLog(@"创建消息表成功");
                }
                else {
                    NSLog(@"创建消息表失败");
                }
            }
        }];
    }
    return _DBQueue;
}
#pragma mark - init
+ (instancetype)shareInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
    });
    return instance;
}


#pragma mark - Private
- (NSString *)DBMianPath {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSLog(@"%@======", NSHomeDirectory());
    //    path = @"/Users/fengli/Desktop";
    path = [path stringByAppendingPathComponent:@"FLChatDB"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = false;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if (!(isDir && isDirExist)) {
        
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (bCreateDir) {
            
            NSLog(@"文件路径创建成功");
        }
    }
    return path;
    
}


/**
 查询会话再数据库是否存在
 
 @param conversationId 会话的ID
 @param exist 是否存在，且返回db以便下步操作
 */
- (void)conversation:(NSString *)conversationId isExist:(void(^)(BOOL isExist, FMDatabase *db, NSInteger unReadCount))exist{
    
    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        BOOL e = NO;
        NSInteger unreadCount = 0;
        FMResultSet *result = [db executeQuery:@"SELECT * FROM conversation WHERE id = ?", conversationId];
        while (result.next) {
            e = YES;
            unreadCount = [result intForColumnIndex:3];
            break;
        }
        exist(e, db, unreadCount);
    }];
    
}

- (void)message:(NSRTCMessage *)message baseId:(BOOL)baseId isExist:(void(^)(BOOL isExist, FMDatabase *db))exist {
    
    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        BOOL e = NO;
        if (!message.msg_id.length) {
            exist(NO, db);
            return ;
        }
        FMResultSet *result;
        if (baseId) {  // 基于消息ID查询
            result = [db executeQuery:@"SELECT * FROM message WHERE id = ?", message.msg_id];
        }
        else {  // 基于消息发送的本地时间查询
            result = [db executeQuery:@"SELECT * FROM message WHERE localtime = ?", @(message.sendtime)];
        }
        
        while (result.next) {
            
            e = YES;
            break;
        }
        exist(e, db);
    }];
}

- (void)creatMessagesListTable {
    
    
    if ([self.db open]) {
        
        
    }
    else {
        NSLog(@"数据库打开失败");
    }
}

- (NSRTCMessage *)makeMessageWithFMResult:(FMResultSet *)result {
    
    NSString *messages = [result stringForColumnIndex:6];
    NSRTCMessageBody *body = [NSRTCMessageBody yy_modelWithJSON:[messages stringToJsonDictionary]];
    BOOL isSender = [result boolForColumnIndex:4];
    
    NSString *currentUser = [NSRTCChatManager shareManager].user.currentUserID;
    NSString *conversation = [result stringForColumnIndex:3];
    NSString *toUser = isSender?conversation:currentUser;
    NSString *fromUser = isSender?currentUser:conversation;
    NSString *chat_type = [result stringForColumnIndex:5];
    long long timeStamp = [result longLongIntForColumnIndex:2];
    long long localTime = [result longLongIntForColumnIndex:1];
    NSString *msgId = [result stringForColumnIndex:0];
    NSInteger status = [result intForColumnIndex:7];
    NSRTCMessage *message = [[NSRTCMessage alloc] initWithToUser:toUser fromUser:fromUser chatType:chat_type];
    message.bodies = body;
    message.timestamp = timeStamp;
    message.msg_id = msgId;
    message.sendtime = localTime;
    message.sendStatus = status?NSRTCMessageSendSuccess:NSRTCMessageSendFail;
    return message;
}

#pragma mark - Public
//- (void)addConversation:(XHConversationModel *)conversation {
//
//    [self conversation:conversation.userName isExist:^(BOOL isExist, FMDatabase *db) {
//
//        // 判断不存在再插入数据库
//        if (!isExist) {
//
//
//                NSString *toUser = conversation.userName;
//                NSInteger unreadCount = conversation.unReadCount;
//                NSString *latestMsgId = conversation.latestMsgId;
//                [db executeUpdate:@"INSERT INTO conversation (id, unreadcount, latestmsgid) VALUES (?, ?, ?)", toUser, @(unreadCount), latestMsgId];
//
//        }
//    }];
//}

- (NSArray<NSRTCConversation *> *)queryAllConversations {
    
    NSMutableArray *conversations = [NSMutableArray array];
    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet *result = [db executeQuery:@"SELECT * FROM conversation"];
        while (result.next) {
            NSRTCConversation *conversation = [[NSRTCConversation alloc] init];
            conversation.userName = [result stringForColumnIndex:0];
            conversation.unReadCount = [result intForColumnIndex:3];
            conversation.latestMsgStr = [result stringForColumnIndex:4];
            conversation.latestMsgTimeStamp = [result longLongIntForColumnIndex:5];
            [conversations addObject:conversation];
        }
    }];
    return conversations;
}


- (void)addMessage:(NSRTCMessage *)message {
    
    [self message:message baseId:YES isExist:^(BOOL isExist, FMDatabase *db) {
        
        // 判断再数据库中不存在再插入消息
        if (!isExist) {
            BOOL isSender = [message.from isEqualToString:[NSRTCChatManager shareManager].user.currentUserID];
            NSString *bodies = [message.bodies yy_modelToJSONString];
            NSNumber *time = [NSNumber numberWithLongLong:message.timestamp];
            NSString *msgId = message.msg_id?message.msg_id:@"";
            NSNumber *locTime = [NSNumber numberWithLongLong:message.sendtime];
            NSNumber *status;
            switch (message.sendStatus) {
                case NSRTCMessageSending:
                case NSRTCMessageSendFail:
                    status = @0;
                    break;
                    
                case NSRTCMessageSendSuccess:
                    status = @1;
                    break;
                default:
                    break;
            }
            [db executeUpdate:@"INSERT INTO message (id, localtime, timestamp, conversation, msgdirection, chattype, bodies, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", msgId, locTime,time, isSender?message.to:message.from, isSender?@1:@0, @"chat", bodies, status];
        }
        
    }];
}

- (void)updateMessage:(NSRTCMessage *)message {
    
    [self message:message baseId:NO  isExist:^(BOOL isExist, FMDatabase *db) {
        
        NSNumber *sendStatus;
        switch (message.sendStatus) {
            case NSRTCMessageSendFail:case NSRTCMessageSending:
                sendStatus = @0;
                break;
                
            case NSRTCMessageSendSuccess:
                sendStatus = @1;
                break;
            default:
                break;
        }
        // 如果消息存在，更新状态
        if (isExist) {
            
            [db executeUpdate:@"UPDATE message SET status = ?, id = ?, timestamp = ?, bodies = ? WHERE localtime = ?", sendStatus, message.msg_id, @(message.timestamp), [message.bodies yy_modelToJSONString],@(message.sendtime)];
        }
    }];
}

- (NSArray<NSRTCMessage *> *)queryMessagesWithUser:(NSString *)userName {
    
    return [self queryMessagesWithUser:userName limit:10000 page:0];
}

- (NSArray<NSRTCMessage *> *)queryMessagesWithUser:(NSString *)userName limit:(NSInteger)limit page:(NSInteger)page {
    
    if (limit <= 0) {
        return nil;
    }
    
    NSMutableArray *messages = [NSMutableArray array];
    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSDate *date = [NSDate date];
        NSNumber *timeStamp = [NSNumber numberWithLongLong:[date timeStamp]];
        FMResultSet *result = [db executeQuery:@"SELECT * FROM (SELECT * FROM message WHERE conversation = ? AND timestamp < ? ORDER BY timestamp DESC LIMIT ? OFFSET ?) ORDER BY timestamp ASC", userName, timeStamp, @(limit), @(limit*page)];
        while (result.next) {
            
            
            NSRTCMessage *message = [self makeMessageWithFMResult:result];
            [messages addObject:message];
        }
    }];
    
    
    //    // 数组倒序
    //    for (NSInteger index = 0; index < messages.count / 2; index++) {
    //        [messages exchangeObjectAtIndex:index withObjectAtIndex:messages.count - index - 1];
    //    }
    
    //    [messages sortUsingComparator:^NSComparisonResult(NSRTCMessage * _Nonnull obj1, NSRTCMessage *  _Nonnull obj2) {
    //
    //        if (obj1.timestamp > obj2.timestamp) {
    //            return NSOrderedDescending;
    //        }
    //        else if (obj1.timestamp < obj2.timestamp) {
    //
    //            return NSOrderedAscending;
    //        }
    //        return NSOrderedSame;
    //    }];
    return messages;
}


//- (void)updateLatestMessageOfConversation:(XHConversationModel *)conversation andMessage:(NSRTCMessage *)message {
//
//    if (!message.msg_id) {
//        return;
//    }
//
//    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
//
//        BOOL success = [db executeUpdate:@"UPDATE conversation SET latestmsgid = ? WHERE id = ?", message.msg_id, conversation.userName];
//
//        if (success) {
//            NSLog(@"更新成功");
//        }
//        else {
//            NSLog(@"更新失败");
//        }
//    }];
//}


- (void)addOrUpdateConversationWithMessage:(NSRTCMessage *)message isChatting:(BOOL)isChatting{
    
    if (!message) {
        NSLog(@"message为空");
        return;
    }
    // 自己是否是消息发送者
    BOOL isSender = [message.from isEqualToString:[NSRTCChatManager shareManager].user.currentUserID];
    BOOL isReciver = [message.to isEqualToString:[NSRTCChatManager shareManager].user.currentUserID];
    // 聊天的对象
    NSString *conversationName = isSender ? message.to : message.from;
    // 最新消息字符
    NSString *latestMsgStr = [NSRTCConversation getMessageTypeDescStrWithMessage:message];
    // 会话是否开启
    [self conversation:conversationName isExist:^(BOOL isExist, FMDatabase *db, NSInteger unreadCount) {
        
        // 判断不存在再插入数据库
        if (!isExist) {
            
            NSRTCConversation *conversation = [[NSRTCConversation alloc] initWithMessageModel:message conversationId:conversationName];
            conversation.unReadCount = isChatting ? 0 : 1;
            
            NSString *toUser = conversation.userName;
            NSInteger unreadCount = conversation.unReadCount;
            [db executeUpdate:@"INSERT INTO conversation (id, unreadcount, latestmsgtext, latestmsgtimestamp) VALUES (?, ?, ?, ?)", toUser, @(unreadCount), latestMsgStr, @(message.timestamp)];
            
        }
        else {  // 如果已经存在，更新最后一条消息
            
            unreadCount = isChatting ? 0 : (unreadCount + 1);
            BOOL success = [db executeUpdate:@"UPDATE conversation SET latestmsgtext = ?, unreadcount = ?,latestmsgtimestamp = ?  WHERE id = ?", latestMsgStr, @(unreadCount), @(message.timestamp), conversationName];
            
            if (success) {
                NSLog(@"更新成功");
            }
            else {
                NSLog(@"更新失败");
            }
        }
    }];
}

- (void)updateUnreadCountOfConversation:(NSString *)conversationName unreadCount:(NSInteger)unreadCount{
    
    [self conversation:conversationName isExist:^(BOOL isExist, FMDatabase *db, NSInteger unReadCount) {
        
        if (isExist) {
            BOOL success = [db executeUpdate:@"UPDATE conversation SET unreadcount = ? WHERE id = ?", @(unreadCount),conversationName];
            
            if (success) {
                NSLog(@"更新成功");
            }
            else {
                NSLog(@"更新失败");
            }
        }
    }];
}

@end
