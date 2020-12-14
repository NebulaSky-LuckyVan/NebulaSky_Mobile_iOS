//
//  NSBaseRPCRequestItem.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSBaseRPCRequestItem.h"
#import <UTDID/UTDevice.h>

@implementation NSBaseRPCRequestItem
- (instancetype)init{
    self  = [super init];
    if (self) {
        _returnType =  @"@\"NSString\"";//设置默认返回值类型
        _timeoutInterval = 60;
        _checkLogin  = NO;//不打开登录检查
        _signCheck = YES;//默认开启验签
        _isCrypt = NO; // 关闭加密
        _requestHeaderField  = @{
            @"Cookie":[NSString stringWithFormat:@"JSESSIONID=%@",
        [UTDevice utdid]],
            @"h_transId":@"11",
            @"h_channel":@"11",
//            @"x-auth-token":kStringIsEmpty([LRCheetahUserInfoManager manager].xAuthToken)?@"":[LRCheetahUserInfoManager manager].xAuthToken
        };
        
    }
    return self;
}

@end
@implementation NSRequestItem
+ (instancetype)shareWithOperationType:(NSString *)operationType requestParam:(id)params{
    NSRequestItem *itm = [[NSRequestItem alloc]init];
    itm.operationType = [operationType copy];
    itm.params = @[params ? params : [NSNull null]];
    return itm;
}
@end
