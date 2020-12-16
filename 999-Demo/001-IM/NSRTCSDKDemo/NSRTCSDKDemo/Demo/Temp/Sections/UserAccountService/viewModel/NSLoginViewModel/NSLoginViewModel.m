//
//  NSLoginViewModel.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/8.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSLoginViewModel.h"
 
 

#import "NSRTCChatManager.h"
#import "NSRTCClient.h"
#import "NSCategories.h"
#import "NSRTCChatUser.h"
#import "NSTabBarController.h"

#import "AppDelegate.h"


static NSString *salt1 = @"luckyChatUser";
static NSString *salt2 = @"luckyChatManager";
@implementation NSLoginViewModel

 
- (RACSubject *)loginHandlerSbj{
    if (!_loginHandlerSbj) {
        _loginHandlerSbj = [RACSubject subject];
        [_loginHandlerSbj subscribeNext:^(NSDictionary * x) {
            __weak typeof(self) weakSelf = self;
//        deviceId: String,       //当前设备id
//        deviceType: Number,     //设备类型，1：android；2：ios
            NSMutableDictionary *inputInfo = [NSMutableDictionary dictionaryWithDictionary:x];
             if (inputInfo.allValues.count>2) {
                 [weakSelf loginWithMode:NO loginInfo:inputInfo complection:NULL];
             }
        }];
    }
    return _loginHandlerSbj;
}

- (NSString*)encryptPwd:(NSString*)inputPwd{
    NSString *finalPwd = [inputPwd copy];
    finalPwd = [finalPwd md5Str];
    finalPwd = [[salt1 stringByAppendingString:finalPwd]stringByAppendingString:salt2];
    finalPwd = [finalPwd md5Str];
    return finalPwd;
}
- (RACSubject *)syncDeviceIdReLoginHandlerSbj{
    if (!_syncDeviceIdReLoginHandlerSbj) {
        _syncDeviceIdReLoginHandlerSbj = [RACSubject subject];
        [_syncDeviceIdReLoginHandlerSbj subscribeNext:^(NSDictionary * x) {
            __weak typeof(self) weakSelf = self;
            //        deviceId: String,       //当前设备id
            //        deviceType: Number,     //设备类型，1：android；2：ios
            NSMutableDictionary *inputInfo = [NSMutableDictionary dictionaryWithDictionary:x];
            if (inputInfo.allValues.count>2) {
                NSString *finalPwd =  inputInfo[@"password"];
                [weakSelf loginWithMode:YES loginInfo:inputInfo complection:NULL];
            }
        }];
    }
    return _syncDeviceIdReLoginHandlerSbj;
}
 
- (void)loginWithMode:(BOOL)slience loginInfo:(NSDictionary*)requestParams complection:(void(^)(BOOL success))complectionHandlerBlock{
    __weak typeof(self) weakSelf = self;
    NSDictionary *originalLoginInfo = [requestParams copy];
    NSMutableDictionary *loginParams = [requestParams mutableCopy];
    NSString *finalPwd =  loginParams[@"password"];
    loginParams[@"password"] = [weakSelf encryptPwd:finalPwd];
    [NSRTCURLRequestOperation requestWithUrlString:[BaseURL stringByAppendingPathComponent:loginURL] parameters:loginParams success:^(id response) {
        [weakSelf.viewController hideHud];
        if ([response[@"code"] integerValue] < 0) {
            [NSObject showWithTitle:response[@"message"] message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil andAction:nil andParentView:nil];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:originalLoginInfo forKey:@"loginAccountInfo"];
            NSString *auth_token = response[@"data"][@"auth_token"];
            NSString *userId = !self.userName?requestParams[@"userName"]:self.userName;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:auth_token forKey:@"auth_token"];
            [userInfo setObject:userId forKey:@"currentUserID"];
            [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:@"loginUser"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            !slience?[weakSelf socketConnectWithToken:auth_token]:[NSLoginViewModel socketConnectWithToken:auth_token complection:complectionHandlerBlock];
            [[NSRTCChatManager shareManager] setUserAuthToken:auth_token currUserID:userId];
        }
    } fail:^(NSError *error) {
        [weakSelf.viewController hideHud];
        [weakSelf.viewController showError:@"登录失败"];
    }];
}
- (void)socketConnectWithToken:(NSString *)token {
    [self.viewController showMessage:@"连接中"];
    __weak typeof(self) weakSelf = self;
    [NSLoginViewModel socketConnectWithToken:token complection:^(BOOL success) {
        if (!success) {
            [weakSelf.viewController hideHud];
            [weakSelf.viewController showHint:@"连接失败"];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
            [weakSelf.viewController hideHud];
        }
    }];
}
+ (void)socketConnectWithToken:(NSString *)token complection:(void(^)(BOOL success))complectionHandlerBlock{
    [NSRTCClient shareClient].connectServer(BaseURL,token,^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
        !complectionHandlerBlock?:complectionHandlerBlock(YES);
    },^{//Fail
        !complectionHandlerBlock?:complectionHandlerBlock(NO);
    });
    
}



- (RACSubject *)registerHandlerSbj{
    if (!_registerHandlerSbj) {
        _registerHandlerSbj = [RACSubject subject];
        [_registerHandlerSbj subscribeNext:^(id x) {
            __weak typeof(self) weakSelf = self;
            
            NSMutableDictionary *inputInfo = [NSMutableDictionary dictionaryWithDictionary:x];
            if (inputInfo.allValues.count==2) {
            
                    NSString *finalPwd =  inputInfo[@"password"];
                    finalPwd = [finalPwd md5Str];
                    finalPwd = [[salt1 stringByAppendingString:finalPwd]stringByAppendingString:salt2];
                    finalPwd = [finalPwd md5Str];
                    inputInfo[@"password"] = finalPwd;
                    [NSRTCURLRequestOperation requestWithUrlString:[BaseURL stringByAppendingPathComponent:registerURL] parameters:inputInfo success:^(id response) {
                        [weakSelf.viewController hideHud];
                        if([response[@"code"] integerValue] < 0) {
                            [NSObject showWithTitle:@"注册失败" message:response[@"message"] cancelButtonTitle:@"确定" otherButtonTitles:nil andAction:nil andParentView:nil];
                        }else {
                            [NSObject showWithTitle:@"🎉注册成功" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil andAction:nil andParentView:nil];
                        }
                    } fail:^(NSError *error) {
                        [weakSelf.viewController hideHud];
                        [weakSelf.viewController showError:@"注册失败"];
                    }];
                
                       }
        }];
            
    }
    return _registerHandlerSbj;
}
@end
