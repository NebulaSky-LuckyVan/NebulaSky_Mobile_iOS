//
//  NSRTCChatManager.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCChatManager.h"
#import "NSRTCClient.h"
 


/*Desc:其他及时通讯*/
@interface NSRTCChatManager ()
@property (nonatomic, strong) NSMutableArray *delegateItems;
@property (nonatomic, strong) NSMutableArray *delegateBridgeItems;
@end

/*
    初始化信息_初始SDK【C_S链接】
    AppKey:XXXX
    AppSeceret:XXX
    设置
 */
@implementation NSRTCChatManager
#pragma mark-User info
//===================================//
- (NSRTCChatUser *)user{
    if (!_user) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginUser"];
        _user = [NSRTCChatUser yy_modelWithDictionary:userInfo];
    }
    return _user;
}
- (void)setUserAuthToken:(NSString *)token currUserID:(NSString *)userId{
    self.user.auth_token = token;
    self.user.currentUserID = userId;
}
//===================================//

- (void)setup{
    [self beginMessageMonitor];
}


- (NSMutableArray *)delegateItems{
    if (!_delegateItems) {
        _delegateItems = [NSMutableArray array];
    }
    return _delegateItems;
}
 
#pragma mark - Public
- (void)addDelegate:(id<NSRTCChatMessageIOProtocol>)delegate {
    [self.delegateItems containsObject:delegate]?:[self.delegateItems addObject:delegate];
}
- (void)removeDelegate:(id<NSRTCChatMessageIOProtocol>)delegate {
    ![self.delegateItems containsObject:delegate]?:[self.delegateItems removeObject:delegate];
}

- (void)beginMessageMonitor{
    [NSRTCClient shareClient].onReceivedSingleChatMessage(^(NSDictionary*msg){
        [NSRTCMessageReceiver receivedRichTextMessage:msg];
    }).onReceivedVideoChatInvitation(^(NSDictionary*msg){
        [NSRTCMessageReceiver receivedP2PVideoCallMessage:msg];
    }).onReceivedAudioChatInvitation(^(NSDictionary*msg){
        [NSRTCMessageReceiver receivedP2PAudioCallMessage:msg];
    }).onReceivedVideoChatInvitationRejected(^(NSString*user){
        [NSRTCMessageReceiver receivedP2PVideoCallRejected:user];
    });
}


//===============SingleTon====================//
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        [_instance setup];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopy{
    return _instance;
}
- (id)copy{
    return _instance;
}
+ (instancetype)shareManager{
    return [[self alloc]init];
}
@end
