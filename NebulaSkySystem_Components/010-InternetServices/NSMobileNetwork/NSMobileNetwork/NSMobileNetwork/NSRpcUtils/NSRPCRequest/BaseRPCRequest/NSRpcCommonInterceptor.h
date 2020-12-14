//
//  NSRpcCommonInterceptor.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APMobileNetwork/APMobileNetwork.h>

 
@interface NSRpcCommonInterceptor : NSObject<DTRpcInterceptor>

/**
 * 添加RPC拦截器。
 *
 * @param RPCInterceptor 要添加的RPC拦截器对象。
 */
- (void)addRpcInterceptor:(id<DTRpcInterceptor>)RPCInterceptor;

/**
 * 从现有的拦截器列表中移除RPC拦截器。
 *
 * @param RPCInterceptor 要移除的RPC拦截器对象。
 */
- (void)removeRpcInterceptor:(id<DTRpcInterceptor>)RPCInterceptor;

/**
 * 返回当前DTRpcCommonInterceptor对象的拦截器列表。
 *
 * @return 拦截器列表数组。
 */
-(NSArray*)interceptorList;
@end
 
