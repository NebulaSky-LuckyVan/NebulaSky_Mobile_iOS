//
//  NSURLRequestBaseOperation.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "NSURLRequest.h"
@class NSURLRequestItem;
@class NSURLRequestUploadItem;
@class NSURLRequestDownloadItem;
typedef void (^NSURLRequestSuccessHandler)(id response);

typedef void (^NSURLRequestFailHandler)(NSError*error);
@interface NSURLRequestBaseOperation : NSObject


+ (instancetype)shareRequest;

+ (instancetype)shareRequestWithBaseURL:(NSString*)baseURLPath;

+ (void)startNetWorkStatusMonitor:(RequestNetworkReachableBlock)monitorBlock;

- (NSURLRequestItem*)request:(NSURLRequestItem*)reqItem success:(ResponeHandlerBlock)responseHandler fail:(FailHandlerBlock)failHandler;


- (NSURLRequestUploadItem*)upload:(NSURLRequestUploadItem*)reqItem progrss:(ProgresRateHandlerBlock)progressHandler success:(ResponeHandlerBlock)responseHandler fail:(FailHandlerBlock)failHandler;


- (NSURLRequestDownloadItem*)download:(NSURLRequestDownloadItem*)reqItem progrss:(ProgresRateHandlerBlock)progressHandler success:(ResponeHandlerBlock)responseHandler fail:(FailHandlerBlock)failHandler;


@end
