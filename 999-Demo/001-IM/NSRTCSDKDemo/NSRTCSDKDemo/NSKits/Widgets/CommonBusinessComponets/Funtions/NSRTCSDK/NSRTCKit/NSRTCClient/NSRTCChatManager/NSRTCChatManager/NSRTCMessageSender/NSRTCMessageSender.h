//
//  NSRTCChatManager+MessageSender.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/15.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface NSRTCMessageSender:NSObject
#pragma mark - message Input
 

+ (void)sendMessage:(NSRTCMessage*)message success:(void(^)(void))successBlock fail:(void(^)(void))failBlock;
 

+ (void)reSendMessage:(NSRTCMessage*)message success:(void(^)(void))successBlock fail:(void(^)(void))failBlock;


 
@end
 
