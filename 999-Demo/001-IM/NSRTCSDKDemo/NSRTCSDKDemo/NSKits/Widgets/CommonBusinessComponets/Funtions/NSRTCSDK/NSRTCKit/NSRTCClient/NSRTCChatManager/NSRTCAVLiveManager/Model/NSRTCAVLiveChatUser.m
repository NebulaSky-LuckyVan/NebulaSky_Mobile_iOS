//
//  NSRTCAVLiveChatUser.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCAVLiveChatUser.h"

@implementation NSRTCAVLiveChatUser

+ (instancetype)userWithConnectionId:(NSString*)Id{
    NSRTCAVLiveChatUser *user = [[NSRTCAVLiveChatUser alloc]init];
    user.userId = Id;
    user.connectionId = Id;
    return user;
}
@end
