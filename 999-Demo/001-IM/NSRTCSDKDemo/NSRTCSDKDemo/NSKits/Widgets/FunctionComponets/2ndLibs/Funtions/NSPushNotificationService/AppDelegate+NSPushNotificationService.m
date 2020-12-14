//
//  AppDelegate+NSPushNotificationService.m
//  NSPushNotificationService
//
//  Created by VanZhang on 2020/12/1.
//

#import "AppDelegate+NSPushNotificationService.h"

#import "NSPushNotificationService.h"



#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation AppDelegate (NSPushNotificationService)


#pragma mark - 推送通知

// 下面这几个回调将在 -[UIApplication registerUserNotificationSettings:]. 这个接口被调用时触发,而用户的授权,将作为第二个参数传入.若得到用户的通知授权,则会在收到通知时,进行相应的回调.

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    NSLog(@"notificationSettings:%@",notificationSettings);
}
//
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[NSPushNotificationService sharedService]genrationDeviceTokenStringWithDeviceToken:deviceToken];
    [NSPushNotificationService sharedService].requestSetDeviceToken(token,deviceToken);;
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
 
    [NSPushNotificationService sharedService].requestRemotePushTokenRegisteFailHandler(error);
}

#pragma lifeCycle--

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}



#pragma mark  iOS 10 获取推送信息 UNUserNotificationCenter---Delegate
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
//APP在前台的时候收到推送的回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSLog(@"willPresentNotification");
    //1. 处理通知
    NSDictionary *message =   notification.request.content.userInfo;
//    YNETRTCMessage *messageModel  = [YNETRTCMessage yy_modelWithJSON:message];
//    NSLog(@"收到消息:%@",[messageModel yy_modelToJSONObject]);
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}

//APP在后台，点击推送信息，进入APP后执行的回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
/*
    //Local?
    
    //Remote
    NSDictionary *message =   response.notification.request.content.userInfo;
    YNETRTCMessage *messageModel  = [YNETRTCMessage yy_modelWithJSON:message];
    if(messageModel.from){//Local
        YNETRTCConversation *conversation = [[YNETRTCConversation alloc]initWithMessageModel:messageModel conversationId:messageModel.from];
        NSLog(@"处理消息:%@",message);
        UINavigationController *navgationCtrl  =  [YNETRTCMessageNotifyer requestCurrentNavigationVC];
        
        void (^CallPushToCurrNotifyChatHandler)(YNETRTCConversation *conversation) = ^(YNETRTCConversation *conversation){
            //desc:
            
            YNETRTCChatViewController *chatVc  = [[YNETRTCChatViewController alloc]initWithToUser:conversation.userName];
            
            chatVc.hidesBottomBarWhenPushed = YES;
            
            [navgationCtrl pushViewController:chatVc animated:YES];
        };
        if ([navgationCtrl.topViewController isKindOfClass:[YNETRTCChatViewController class]]) {
            YNETRTCChatViewController *currPageChat = (YNETRTCChatViewController*)navgationCtrl.topViewController;
            if ([currPageChat.toUser isEqualToString:messageModel.from]) {//已经在当前页,并且消息接收方是相同,不作处理
                
            }else{
                CallPushToCurrNotifyChatHandler(conversation);
            }
        }else{ //当前页并非 推送过来的目标用户聊天页
            CallPushToCurrNotifyChatHandler(conversation);
        }
    }else{//Remote
        if([message.allKeys containsObject:@"params"]&&[message.allKeys containsObject:@"aps"]){
            NSDictionary*aps = message[@"aps"];
            NSDictionary*params = message[@"params"];
            NSString *pushType = params[@"pushType"];
//            aps =     {
//                alert =         {
//                    body = Rertyujkljkjtrewertyujkhlktrewt;
//                    title = LuckyVan1234;
//                };
//                sound = default;
//            };
            //            {
            //                bodies =     {
            //                    duration = 0;
            //                    latitude = 0;
            //                    longitude = 0;
            //                    msg = Gfhjkl;
            //                    type = txt;
            //                };
            //                "chat_type" = chat;
            //                "from_user" = LuckyVan1234;
            //                isSendSuccess = 0;
            //                "msg_id" = 5dd4b5fc0841fa0f31df2269;
            //                sendStatus = 0;
            //                sendtime = 1574221308302;
            //                timestamp = 1574221308312;
            //                "to_user" = LuckyVan123;
            //                type = 0;
            //            }
//            params =     {
//                channel = IOS;
//                "chat_type" = chat;
//                "from_user" = Lucky123456;
//                msgId = 5dd4b50a0841fa0f31df2268;
//                pushType = SIMPLE;
//                room = "";
//                sendtime = 1574221066238;
//                taskId = 143554942;
//                timestamp = 1574221066303;
//                "to_user" = LuckyVan123;
//                type = txt;
//            }
            
            
            
            
            
            
            if([pushType isEqualToString:@"SIMPLE"]){
                
                NSMutableDictionary *bodies = [NSMutableDictionary dictionary];
                bodies[@"duration"] = @"0";
                bodies[@"latitude"] = @"0";
                bodies[@"longitude"] = @"0";
                bodies[@"msg"] = aps[@"alert"][@"body"];
                bodies[@"type"] = params[@"type"];
                
                NSMutableDictionary *messageInfo = [NSMutableDictionary dictionaryWithDictionary:params];
                messageInfo[@"bodies"] = bodies;
                messageInfo[@"isSendSuccess"] = @"0";
                messageInfo[@"msg_id"] = params[@"msgId"];
                messageInfo[@"sendStatus"] = @"0";
                
                YNETRTCMessage *messageModel  = [YNETRTCMessage yy_modelWithJSON:messageInfo];
                YNETRTCMessageBody *body = [YNETRTCMessageBody yy_modelWithJSON:bodies];
                messageModel.bodies = body;
                
                YNETRTCConversation *conversation = [[YNETRTCConversation alloc]initWithMessageModel:messageModel conversationId:messageModel.from];
                
                // 消息插入数据库
                [[YNETRTCChatMessageDBManager shareManager] addMessage:messageModel];
                
                // 会话插入数据库或者更新会话
                BOOL isChatting = [messageModel.from isEqualToString:[YNETRTCChatManager shareManager].currChatPageViewModel.toUser];
                [[YNETRTCChatMessageDBManager shareManager] addOrUpdateConversationWithMessage:messageModel isChatting:isChatting];
                
                
                
                // 代理处理
                for (id <YNETRTCChatMessageIOProtocol>delegate in [YNETRTCChatManager shareManager].delegateItems) {
                    if ([delegate respondsToSelector:@selector(chatManager:receivedMessage:)]) {
                        if (message) {
                            [delegate chatManager:[YNETRTCChatManager shareManager] receivedMessage:messageModel];
                        }
                    }
                }
                if([params[@"type"] isEqualToString:@"audioChat"]){
                    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                    dataDict[@"room"] = params[@"room"];
                    dataDict[@"from_user"] = @"0";
//                    params[@"from_user"];
                    dataDict[@"chat_type"] = params[@"chat_type"];
                    
                    UIViewController *vc = [UIView requestCurrentVC];
                    YNETRTCAVLivePhoneCallViewController *phoneCall = [YNETRTCAVLivePhoneCallViewController receivePhoneCall:YNETRTCAVLivePhoneCallAudioCall phoneCallInfo:dataDict];
                    [vc presentViewController:phoneCall animated:YES completion:nil];
                }else if([params[@"type"] isEqualToString:@"videoChat"]){
                    
                    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                    dataDict[@"room"] = params[@"room"];
                    dataDict[@"from_user"] = @"0";
                    //                    params[@"from_user"];
                    dataDict[@"chat_type"] = params[@"chat_type"];
                    UIViewController *vc = [UIView requestCurrentVC];
                    YNETRTCAVLivePhoneCallViewController *phoneCall = [YNETRTCAVLivePhoneCallViewController receivePhoneCall:YNETRTCAVLivePhoneCallVideoCall phoneCallInfo:dataDict];
                    [vc presentViewController:phoneCall animated:YES completion:nil];
                }else{
                    UINavigationController *navgationCtrl  =  [YNETRTCMessageNotifyer requestCurrentNavigationVC];
                    
                    void (^CallPushToCurrNotifyChatHandler)(YNETRTCConversation *conversation) = ^(YNETRTCConversation *conversation){
                        //desc:
                        
                        YNETRTCChatViewController *chatVc  = [[YNETRTCChatViewController alloc]initWithToUser:conversation.userName];
                        
                        chatVc.hidesBottomBarWhenPushed = YES;
                        
                        [navgationCtrl pushViewController:chatVc animated:YES];
                    };
                    if ([navgationCtrl.topViewController isKindOfClass:[YNETRTCChatViewController class]]) {
                        YNETRTCChatViewController *currPageChat = (YNETRTCChatViewController*)navgationCtrl.topViewController;
                        if ([currPageChat.toUser isEqualToString:messageModel.from]) {//已经在当前页,并且消息接收方是相同,不作处理
                            
                        }else{
                            CallPushToCurrNotifyChatHandler(conversation);
                        }
                    }else{ //当前页并非 推送过来的目标用户聊天页
                        CallPushToCurrNotifyChatHandler(conversation);
                    }
                    
                    
                }
                
                
                
            }
            
            
            
        }
    }
    dispatch_after(5, dispatch_get_main_queue(), ^{
        NSLog(@"message:%@",message);
    });
 */
}
 

#pragma lifeCycle--






#pragma mark didReceiveRemoteNotification


#pragma mark >iOS7远程消息处理
/*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
 
 This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler API_AVAILABLE(ios(7.0)){
    [[NSPushNotificationService sharedService]didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    
}
#pragma mark-iOS3至iOS10远程推送消息处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[NSPushNotificationService sharedService]didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
}


#pragma mark-iOS9至iOS10远程消息点击处理

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler{
    [[NSPushNotificationService sharedService]remotePushHandleActionWithIdentifier:identifier userInfo:userInfo responseInfo:responseInfo completionHandler:completionHandler];
    
}

#pragma mark-iOS8至iOS10远程消息点击处理
// Called when your app has been activated by the user selecting an action from a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler{
    [[NSPushNotificationService sharedService]remotePushHandleActionWithIdentifier:identifier userInfo:userInfo responseInfo:nil completionHandler:completionHandler];
}


#pragma mark didReceiveLocalNotification


#pragma mark-iOS4至iOS10本地消息处理
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [[NSPushNotificationService sharedService]didReceiveLocalNotification:notification];
}


#pragma mark-iOS8至iOS10本地消息点击处理

// Called when your app has been activated by the user selecting an action from a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler{
    [[NSPushNotificationService sharedService]localPushHandleActionWithIdentifier:identifier localNotification:notification responseInfo:nil completionHandler:completionHandler];
    
}

#pragma mark-iOS9至iOS10本地消息点击处理
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler{
    [[NSPushNotificationService sharedService]localPushHandleActionWithIdentifier:identifier localNotification:notification responseInfo:responseInfo completionHandler:completionHandler];
    
}
@end
