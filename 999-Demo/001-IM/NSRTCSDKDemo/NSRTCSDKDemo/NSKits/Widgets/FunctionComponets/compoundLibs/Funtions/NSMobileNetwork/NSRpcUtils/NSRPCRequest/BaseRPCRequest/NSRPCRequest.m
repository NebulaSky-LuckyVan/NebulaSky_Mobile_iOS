//
//  NSRPCRequest.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRPCRequest.h"
#import <UTDID/UTDevice.h>

@implementation NSRPCRequest

-(NSString *)sessiondId{
    if (!_sessiondId) {
        _sessiondId = [NSString stringWithFormat:@"JSESSIONID=%@",![UTDevice utdid]?@"":[UTDevice utdid]];
    
    }
    return _sessiondId;
}

-(void)requestWithItem:(NSRequestItem *)requestItem success:(NSBaseRPCResponeHandler)responseHandler failure:(NSBaseRPCFailHandler)failHandler{
    if (requestItem.params&&requestItem.params.count>0) {
        NSDictionary *dict = @{@"_requestBody" : @{@"body" : [requestItem.params firstObject]}};
        requestItem.params = @[dict];
    }
    if (!requestItem.requestHeaderField||requestItem.requestHeaderField.count==0) {
        NSDictionary *requestHeaderField = @{@"Cookie" : self.sessiondId};
        requestItem.requestHeaderField = requestHeaderField;
    }
    [super requestWithItem:requestItem success:responseHandler failure:failHandler];
}

- (NSArray *)networkDisconnectTipsNotShowFilters{
    return @[
            @"com.ifp.MP5035", // 请求行方总开关
            @"com.ifp.MP5646", // 获取用户白名单状态
            @"com.ifp.MP0002", // 获取服务器时间
            @"com.ifp.MP5706", // 关闭网银后台的指纹（面容）或手势登录开关
    ];
}
@end
