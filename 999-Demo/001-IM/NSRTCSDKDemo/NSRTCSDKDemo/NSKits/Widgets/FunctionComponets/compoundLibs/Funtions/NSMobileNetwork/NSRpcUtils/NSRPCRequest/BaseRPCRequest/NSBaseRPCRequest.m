//
//  NSBaseRPCRequest.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSBaseRPCRequest.h"
#import "NSRpcCommonInterceptor.h" 
#import <MPMgsAdapter/MPRpcInterface.h>
#import <APMobileNetwork/APMobileNetwork.h>
@interface NSBaseRPCRequest ()
//Desc:
@property (strong, nonatomic) NSDateFormatter * dateFormatter;
@end
@implementation NSBaseRPCRequest


+ (void)initialize{
    /***** RPC全局配置 *****/
    [MPRpcInterface initRpc];
    NSRpcCommonInterceptor *mpTestIntercaptor = [[NSRpcCommonInterceptor alloc] init];
    // 自定义子拦截器
    [MPRpcInterface addRpcInterceptor:mpTestIntercaptor];
}



- (void)requestWithItem:(NSRequestItem*)requestItem
                success:(NSBaseRPCResponeHandler)responseHandler
                failure:(NSBaseRPCFailHandler)failHandler{
   __block id result = nil;
    
    NSString *contentBodyBox
    = @"******************************************************************************************";
    NSString *log = [NSString stringWithFormat:@"%@\nRPC Request:%@\nrequestHeaderField:%@\nrequestParams:%@",
                    contentBodyBox,
                    requestItem.operationType,
                    requestItem.requestHeaderField,
                    requestItem.params];
   [DTRpcAsyncCaller callAsyncBlock:^{
       @try {
           DTRpcMethod *method =  [[DTRpcMethod alloc]init];
           method.operationType = requestItem.operationType;
           method.checkLogin =  requestItem.checkLogin ;
           method.signCheck =  requestItem.signCheck ;
           method.timeoutInterval = requestItem.timeoutInterval;
           method.returnType = requestItem.returnType;
          
           
           
           NSArray *params = requestItem.params;
           NSDictionary*requestHeader = requestItem.requestHeaderField;
           void (^CallRPCResponseHeaderHandlerBlock)(NSDictionary *) = ^(NSDictionary *allHeaderFields){
               NSLog(@"allHeaderFields:%@",allHeaderFields);
#warning 根据具体的项目要求决定是否存储该字段
//               if ([allHeaderFields.allKeys containsObject:@"x-auth-token"]) {
//                   [LRCheetahUserInfoManager manager].xAuthToken = [allHeaderFields[@"x-auth-token"] copy];
//               }
           };
           result = [[DTRpcClient defaultClient]executeMethod:method
                                                       params:params
                                           requestHeaderField:requestHeader
                                         responseHeaderFields:CallRPCResponseHeaderHandlerBlock];
       } @catch (DTRpcException *exception) {
    
           //断网情况提示用户检查网络
//           NSString *currPageCtrlClass = [NSString stringWithFormat:@"%@",[DTContextGet().currentVisibleViewController class]];
           NSString *releaseOrDebug  = @"DEBUG";
           NSString *errorType  = nil;
#ifdef DEBUG
           releaseOrDebug  = @"DEBUG";
# else
           releaseOrDebug = @"RELEASE";

#  endif
                      
           if (exception.code == kDTRpcNetworkError
           &&![[self networkDisconnectTipsNotShowFilters] containsObject:requestItem.operationType]) {
               errorType = @"网络连接错误";
           }else{
               errorType = [NSString stringWithFormat:@"%u",exception.code];
           }
           NSString *operationType = requestItem.operationType;
           
           NSDictionary *dic = @{@"operationType":operationType.length==0?@"":operationType,
                                 @"currentTime":[self.dateFormatter stringFromDate:[NSBaseRPCRequest getCurrentDate]],
//                                 @"currentPage":currPageCtrlClass,
                                 @"errorType":[NSString stringWithFormat:@"%u",exception.code],
                                 @"releaseOrDebug":releaseOrDebug};
#ifdef DEBUG
           NSLog(@"%@\nFailed:%@\n%@",log,dic,contentBodyBox);
#  endif
           !failHandler?:failHandler(exception);
       }
   } completion:^{
#ifdef DEBUG
       NSLog(@"%@\nSuccessed:%@\n%@",log,result,contentBodyBox);
#  endif
       !responseHandler?:responseHandler(result);
   }];
}

  


- (void)checkNetworkConnectionWithComplection:(void(^)(BOOL isReachable,NSError*error))complection{
     //每次请求先判断网路状态，若断网则提示用户
    __block BOOL isReachable = YES;
    NSError *err = nil;
    MPAASNNetworkStatus nStatus = MPAASNNotReachable;
    if (![[DTNetReachability reachabilityForInternetConnection] isReachable]) {
       
        NSError *error
        = [NSError errorWithDomain:NSNetServicesErrorDomain
                              code:404
                          userInfo:@{@"errorMsg":@"网络连接错误",NSLocalizedDescriptionKey:@"网络连接错误"}];
        err = error;
        isReachable = NO;
      }else{
        nStatus =  [[DTNetReachability reachabilityForInternetConnection]getCurrentReachabilityStatus];
        isReachable = YES;
      }
    !complection?:complection(isReachable,err);
}


- (void)startNetworkMonitorWithReacchableHandler:(void(^)(MPAASNNetworkStatus))reachableBlock
                               unreachableHandler:(void(^)(void))unreachableBlock{
    
    [DTNetReachability reachabilityForInternetConnection].reachableBlock = ^(DTNetReachability *reachability) {
        !reachableBlock?:reachableBlock([reachability getCurrentReachabilityStatus]);
    };
    [DTNetReachability reachabilityForInternetConnection].unreachableBlock = ^(DTNetReachability *reachability) {
        !unreachableBlock?:unreachableBlock();
    };
      
}



- (NSArray *)networkDisconnectTipsNotShowFilters{
    return @[];
}
//===============SingleTon====================//
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopy{
    return _instance;
}
- (id)copy{
    return _instance;
}
+ (instancetype)sharedRequest{
    return [[self alloc]init];
}



//===================================//
- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
         _dateFormatter = [[NSDateFormatter alloc] init];
         [_dateFormatter setDateFormat:@"yyyy-MM-dd hh-mmss"];
         NSTimeZone * zone = [NSTimeZone systemTimeZone];
         [_dateFormatter setTimeZone:zone];
    }
    return _dateFormatter;
}

+ (NSDate *)getCurrentDate {
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMT];
    NSDate * currentDate = [[NSDate date] dateByAddingTimeInterval:interval];
    return currentDate;
}
@end
