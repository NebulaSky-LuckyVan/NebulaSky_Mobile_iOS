//
//  NSRTCManager.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/5.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface NSRTCManager : NSObject
+ (instancetype)manager;

- (void)setupRTCAVMessageNotifyer;

- (void)continueRTCHandlerWhileDidEnterBackground:(UIApplication *)application;

- (void)checkUnreadConverstions;

@end
 
