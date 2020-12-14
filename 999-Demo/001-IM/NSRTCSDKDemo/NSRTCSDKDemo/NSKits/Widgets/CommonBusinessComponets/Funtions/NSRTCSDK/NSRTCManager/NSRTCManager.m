//
//  NSRTCManager.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/5.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCManager.h"

@interface NSRTCManager ()
//Desc:
@property (strong, nonatomic) NSArray* allUnReadMsgItems;
@end
@implementation NSRTCManager
- (void)checkUnreadConverstions{
    if([NSRTCChatManager shareManager].user.currentUserID){
        [NSRTCURLRequestOperation requestWithUrlString:[BaseURL stringByAppendingPathComponent:@"getAllUnReadConversation"] parameters:@{@"to_user": [NSRTCChatManager shareManager].user.currentUserID} success:^(id response) {
            self.allUnReadMsgItems = [[NSArray yy_modelArrayWithClass:[NSUnReadConversationModel class] json:response[@"data"][@"conversationList"]] copy];
            [self loadUnreadMsg];
        } fail:^(id error) {
            NSLog(@"error:%@",error);
        }];
    }
}
- (void)loadUnreadMsg{
    for (NSUnReadConversationModel*unReadConvs in self.allUnReadMsgItems) {
        NSDictionary *dict = @{@"type": @"up",
                               @"msg_id": unReadConvs.msg_id,
                               @"from_user": unReadConvs.from_user,
                               @"to_user": unReadConvs.to_user,
                               @"number": unReadConvs.unReadNum};
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
        [NSRTCURLRequestOperation requestWithUrlString:[BaseURL stringByAppendingPathComponent:@"getMsgByLastMsgId"]
                                     parameters:parameters
                                        success:^(id response) {
            NSArray *msgList = response[@"data"][@"msgList"];
            for (NSString *bodyStr in msgList) {
                NSRTCMessage *message = [[NSRTCMessage alloc]initWithToUser:unReadConvs.to_user fromUser:unReadConvs.from_user chatType:unReadConvs.chat_type];
                NSRTCMessageBody *body = nil;
                if ([bodyStr isKindOfClass:[NSString class]]) {
                    body = [NSRTCMessageBody yy_modelWithJSON:[bodyStr stringToJsonDictionary]];
                    message.bodies = body;
                }else if ([bodyStr isKindOfClass:[NSDictionary class]]){
                    body = [NSRTCMessageBody yy_modelWithJSON:bodyStr];
                    message.bodies = body;
                }
                // 消息插入数据库
                [[NSRTCChatMessageDBOperation shareInstance] addMessage:message];
                // 会话插入数据库或者更新会话
                BOOL isChatting = [message.from isEqualToString:[NSRTCChatManager shareManager].currChatPageViewModel.toUser];
                [[NSRTCChatMessageDBOperation shareInstance] addOrUpdateConversationWithMessage:message isChatting:isChatting];
            }
        } fail:^(id error) {
            NSLog(@"error:%@",error);
        }];
    }
}
//




//
- (void)continueRTCHandlerWhileDidEnterBackground:(UIApplication *)application{
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)setupRTCAVMessageNotifyer{
    NSString *noticeName = @"P2PVideoCallMessage";
    id noticeObject = nil;
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:noticeName object:noticeObject]subscribeNext:^(NSNotification *notice) {
        NSDictionary *dataDict = notice.object; ;
        UIViewController *vc = [self requestCurrentVC];
        NSRTCAVLivePhoneCallViewController *phoneCall = [NSRTCAVLivePhoneCallViewController receivePhoneCall:NSRTCAVLivePhoneCallVideoCall phoneCallInfo:dataDict];
        phoneCall.modalPresentationStyle = UIModalPresentationFullScreen;
        [vc presentViewController:phoneCall animated:YES completion:nil];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"P2PAudioCallMessage" object:noticeObject]subscribeNext:^(NSNotification *notice) {
        NSDictionary *dataDict = notice.object; ;
        UIViewController *vc = [self requestCurrentVC];
        NSRTCAVLivePhoneCallViewController *phoneCall = [NSRTCAVLivePhoneCallViewController receivePhoneCall:NSRTCAVLivePhoneCallAudioCall phoneCallInfo:dataDict];
        phoneCall.modalPresentationStyle = UIModalPresentationFullScreen;
        [vc presentViewController:phoneCall animated:YES completion:nil];
    }];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)requestCurrentVC{

        UIViewController *result = nil;

    
#ifdef DTContext
        result = DTContextGet().currentVisibleViewController;
#else
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        if (window.windowLevel != UIWindowLevelNormal)
        {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * tmpWin in windows)
            {
                if (tmpWin.windowLevel == UIWindowLevelNormal)
                {
                    window = tmpWin;
                    break;
                }
            }
        }
    
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
    
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }
        else {
            result = window.rootViewController;
        }
#endif
    return  result;
}



+ (instancetype)manager{
    return [NSRTCManager sharedInstance];
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
+ (instancetype)sharedInstance{
    return [[self alloc]init];
}
//===================================//
@end
