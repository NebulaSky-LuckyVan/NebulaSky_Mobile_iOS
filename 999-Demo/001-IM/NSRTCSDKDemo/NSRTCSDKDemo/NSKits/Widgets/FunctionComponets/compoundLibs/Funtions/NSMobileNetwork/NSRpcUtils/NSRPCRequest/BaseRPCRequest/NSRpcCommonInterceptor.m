//
//  NSRpcCommonInterceptor.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRpcCommonInterceptor.h"
#import "NSCheetahRPCHeaderInfo.h"
@interface NSRpcCommonInterceptor ()

@property(nonatomic, strong) NSMutableArray *necessaryInterceptors; // 必须执行的拦截器
@property(nonatomic, strong) NSMutableArray *interceptorArray;

@end
@implementation NSRpcCommonInterceptor


- (id)init
{
    self = [super init];
    if (self)
    {
        // 必须执行的拦截器
        NSMutableArray *necessaryInterceptorList = [[NSMutableArray alloc] init];
        //TODO 注册必须执行的拦截器
        NSCheetahRPCHeaderInfo *cheetahRpc = [[NSCheetahRPCHeaderInfo alloc] init];
        [necessaryInterceptorList addObject:cheetahRpc];
       
        self.necessaryInterceptors = necessaryInterceptorList;
        
        NSMutableArray *interceptorList = [[NSMutableArray alloc]init];
        //TODO 注册需要的拦截器（某些rpc可以忽略）
        self.interceptorArray = interceptorList;
    }
    return self;
}

//rpc发送前执行
- (DTRpcOperation *)beforeRpcOperation:(DTRpcOperation *)operation
{
    DTRpcOperation *newOperation = operation;
    //全局生效拦截器
    if (self.necessaryInterceptors && [self.necessaryInterceptors count] > 0) {
        NSArray *tmpArray = [self.necessaryInterceptors copy];
        for (id<DTRpcInterceptor> interceptor in tmpArray) {
            if ([interceptor respondsToSelector:@selector(beforeRpcOperation:)]) {
                newOperation = [interceptor beforeRpcOperation:newOperation];
            }
        }
    }
    //rpcoperation.ignoreInterceptor设置为yes即可
    if (!operation.ignoreInterceptor && self.interceptorArray && [self.interceptorArray count] > 0) {
        NSArray *tmpArray = [self.interceptorArray copy];
        for (id<DTRpcInterceptor> interceptor in tmpArray) {
            if ([interceptor respondsToSelector:@selector(beforeRpcOperation:)]) {
                newOperation = [interceptor beforeRpcOperation:newOperation];
            }
        }
    }
    
    return newOperation;
}

//rpc结果返回给业务方前执行
- (DTRpcOperation *)afterRpcOperation:(DTRpcOperation *)operation
{
    DTRpcOperation *newOperation = operation;
    if (self.necessaryInterceptors && [self.necessaryInterceptors count] > 0) {
        NSArray *tmpArray = [self.necessaryInterceptors copy];
        for (id<DTRpcInterceptor> interceptor in tmpArray) {
            if ([interceptor respondsToSelector:@selector(afterRpcOperation:)]) {
                newOperation = [interceptor afterRpcOperation:newOperation];
            }
        }
    }
    if (!operation.ignoreInterceptor && self.interceptorArray && [self.interceptorArray count] > 0) {
        NSArray *tmpArray = [self.interceptorArray copy];
        for (id<DTRpcInterceptor> interceptor in tmpArray) {
            if ([interceptor respondsToSelector:@selector(afterRpcOperation:)]) {
                newOperation = [interceptor afterRpcOperation:newOperation];
            }
        }
    }
    return newOperation;
}

//rpc异常需要处理时执行
- (void)handleException:(NSException *)exception
{
    if (self.interceptorArray && [self.interceptorArray count] > 0) {
        NSArray *tmpArray = [self.interceptorArray copy];
        for (id<DTRpcInterceptor> interceptor in tmpArray) {
            if ([interceptor respondsToSelector:@selector(handleException:)]) {
                [interceptor handleException:exception];
            }
        }
    }
}

//添加rpc拦截器
- (void)addRpcInterceptor:(id<DTRpcInterceptor>)RPCInterceptor
{
    if (RPCInterceptor == nil) {
        return;
    }
    if (self.interceptorArray == nil) {
        self.interceptorArray = [[NSMutableArray alloc]init];
    }
    if ([self.interceptorArray indexOfObject:RPCInterceptor] == NSNotFound) {
        [self.interceptorArray addObject:RPCInterceptor];
    }
}

//移除rpc拦截器
- (void)removeRpcInterceptor:(id<DTRpcInterceptor>)RPCInterceptor
{
    if (RPCInterceptor == nil || self.interceptorArray == nil || [self.interceptorArray count] == 0) {
        return;
    }
    [self.interceptorArray removeObject:RPCInterceptor];
}

#pragma mark - Utils
-(NSArray*)interceptorList
{
    NSArray *arr = [[NSArray alloc] initWithArray:self.interceptorArray];
    return arr;
}

@end
