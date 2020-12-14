//
//  NSBaseRPCRequest.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 
#import "NSBaseRPCRequestItem.h"
#import <APMobileNetwork/APMobileNetwork.h>

typedef void(^NSBaseRPCResponeHandler)(id response);
typedef void(^NSBaseRPCFailHandler)(id fail);

@interface NSBaseRPCRequest : NSObject


+ (instancetype)sharedRequest;
/**
 @param requestItem 请求粒子,包含请求头,请求路径,请求参数,超时设置等
 @param responseHandler 成功回调
 @param failHandler 失败回调
 */


- (void)requestWithItem:(NSRequestItem*)requestItem
                success:(NSBaseRPCResponeHandler)responseHandler
                failure:(NSBaseRPCFailHandler)failHandler;
  

/**
 RPC网络监听方法
 MPAASNNetworkStatus 网络状态
 MPAASNNotReachable     = 0,
 MPAASNReachableViaWWAN2G = 1,
 MPAASNReachableViaWWAN3G = 2,
 MPAASNReachableViaWWAN4G = 3,
 MPAASNReachableViaWiFi = 4,
 MPAASNReachableViaUnknown = 5,
*/
- (void)startNetworkMonitorWithReacchableHandler:(void(^)(MPAASNNetworkStatus))reachableBlock
                               unreachableHandler:(void(^)(void))unreachableBlock;

/**
 网络异常 过滤地址
 */
- (NSArray *)networkDisconnectTipsNotShowFilters;

@end
