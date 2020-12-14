//
//  NSRTCURLRequestOperation.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCURLRequestOperation.h"
#import "NSURLRequestBaseOperation+RACSignal.h"

#import "NSURLRequest.h"
#import "NSRTCChatManager.h"
#import "NSRTCChatUser.h"
@implementation NSRTCURLRequestOperation

+ (NSString *)strUTF8Encoding:(NSString *)str
{
    /*! ios9适配的话 打开第一个 */
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
}
+ (NSURLSessionTask *)requestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(NSRTCSuccess)successBlock fail:(NSRTCFail)failureBlock {
  
    if (urlString == nil)
    {
        return nil;
    }
    
    __block BOOL networkCouldReachable = YES;
 
    [NSURLRequestBaseOperation startNetWorkStatusMonitor:^(BOOL networkReachable) {
        networkCouldReachable = networkReachable;
    }];
    if (!networkCouldReachable) {   //没有网络
        failureBlock([NSError errorWithDomain:@"connerror" code:0 userInfo:nil]);
        return nil;
    }
    /*! 检查地址中是否有中文 */
    NSString *urlPath = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    dict[@"auth_token"] = [NSRTCChatManager shareManager].user.auth_token;
    NSURLRequestItem *requestItem = [NSURLRequestItem itemWithURLPath:urlPath pramaters:dict];
    
#pragma mark to do
    NSLog(@"******************** 请求参数 ***************************");
    NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",
         requestItem.headerBody.requestHeader, (requestItem.requestType == NSURLRequest_GET) ? @"GET":@"POST",[NSMutableString stringWithFormat:@"%@/%@",requestItem.DOMAINURLPATH,requestItem.urlPath], parameters);
    NSLog(@"******************************************************");
    
    
    NSURLRequestItem *finalRequestItem =  [[NSURLRequestBaseOperation shareRequest]request:requestItem success:^(id response) {
        !successBlock?:successBlock(response);
    } fail:^(id fail) {
        !failureBlock?:failureBlock(fail);
    }];
    
    return finalRequestItem.dataTask;
}

+ (NSURLSessionTask *)request:(NSRTCRequestType)request withUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(NSRTCSuccess)successBlock fail:(NSRTCFail)failureBlock {
    
    if (urlString == nil)
    {
        return nil;
    }
    __block BOOL networkCouldReachable = YES;
    [NSURLRequestBaseOperation startNetWorkStatusMonitor:^(BOOL networkReachable) {
        networkCouldReachable = networkReachable;
    }];
    if (!networkCouldReachable) {   //没有网络
        failureBlock([NSError errorWithDomain:@"connerror" code:0 userInfo:nil]);
        return nil;
    }
    /*! 检查地址中是否有中文 */
    NSString *urlPath = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    dict[@"auth_token"] = [NSRTCChatManager shareManager].user.auth_token;
    
    NSURLRequestItem *requestItem = [NSURLRequestItem itemWithURLPath:urlPath pramaters:dict];
    if (request==GetRequest) {
        requestItem.requestType = NSURLRequest_GET;
    }else if (request==PostRequest){
        requestItem.requestType = NSURLRequest_POST;
    }
#pragma mark to do
    
    void (^CallLogInfoHandler)(id,BOOL) = ^(id result ,BOOL success){
        
        NSLog(@"******************** 请求参数 ***************************");
        NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",
              requestItem.headerBody.requestHeader, (requestItem.requestType == NSURLRequest_GET) ? @"GET":@"POST",[NSMutableString stringWithFormat:@"%@/%@",requestItem.DOMAINURLPATH,requestItem.urlPath], dict);
        NSLog(@"******************************************************");
        if (success) {
            NSLog(@"请求成功:%@",result);
        }else{
            NSLog(@"请求失败:%@",result);
        }
        
    };
    NSURLRequestItem *finalRequestItem =  [[NSURLRequestBaseOperation shareRequest]request:requestItem success:^(id response) {
        !successBlock?:successBlock(response);
        CallLogInfoHandler(response,YES);
        
    } fail:^(id fail) {
        !failureBlock?:failureBlock(fail);
        CallLogInfoHandler(fail,NO);
    }];
    
    return finalRequestItem.dataTask;
}
+ (NSURLSessionTask *)request:(NSRTCRequestType)request withUrlString:(NSString *)urlString bodyParameters:(NSDictionary *)body success:(NSRTCSuccess)successBlock fail:(NSRTCFail)failureBlock{
    
    
    if (urlString == nil)
    {
        return nil;
    }
    __block BOOL networkCouldReachable = YES;
    [NSURLRequestBaseOperation startNetWorkStatusMonitor:^(BOOL networkReachable) {
        networkCouldReachable = networkReachable;
    }];
    if (!networkCouldReachable) {   //没有网络
        failureBlock([NSError errorWithDomain:@"connerror" code:0 userInfo:nil]);
        return nil;
    }
    /*! 检查地址中是否有中文 */
    NSString *urlPath = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:body];
    dict[@"auth_token"] = [NSRTCChatManager shareManager].user.auth_token;
    
    NSURLRequestItem *requestItem = [NSURLRequestItem itemWithURLPath:urlPath pramaters:dict];
    if (request==GetRequest) {
        requestItem.requestType = NSURLRequest_GET;
    }else if (request==PostRequest){
        requestItem.requestType = NSURLRequest_POST;
    }
    requestItem.headerBody.requestBody = dict;
    
    
#pragma mark to do
    
    void (^CallLogInfoHandler)(id,BOOL) = ^(id result ,BOOL success){
        
        NSLog(@"******************** 请求参数 ***************************");
        NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",
              requestItem.headerBody.requestHeader, (requestItem.requestType == NSURLRequest_GET) ? @"GET":@"POST",[NSMutableString stringWithFormat:@"%@/%@",requestItem.DOMAINURLPATH,requestItem.urlPath], dict);
        NSLog(@"******************************************************");
        if (success) {
            NSLog(@"请求成功:%@",result);
        }else{
            NSLog(@"请求失败:%@",result);
        }
        
    };
    NSURLRequestItem *finalRequestItem =  [[NSURLRequestBaseOperation shareRequest]request:requestItem success:^(id response) {
        !successBlock?:successBlock(response);
        CallLogInfoHandler(response,YES);
        
    } fail:^(id fail) {
        !failureBlock?:failureBlock(fail);
        CallLogInfoHandler(fail,NO);
    }];
    
    return finalRequestItem.dataTask;
    
    
    
}
#pragma mark - 图片上传
+ (NSURLSessionTask *)uploadImageWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters imageData:(NSData *)imageData progress:(NSRTCUploadProgress)progressBlock success:(NSRTCSuccess)successBlock fail:(NSRTCFail)failureBlock {
    
    if (urlString == nil)
    {
        return nil;
    }
    
    /*! 检查地址中是否有中文 */
    NSString *urlPath = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    NSURLRequestUploadItem *requestItem = [NSURLRequestUploadItem itemWithUploadURLPath:urlPath parameters:parameters fileData:imageData fileName:parameters[@"imageFileName"] folderName:@"image" mimeType:@"image/jpg"];
    
    NSURLRequestUploadItem *finalRequestItem = [[NSURLRequestBaseOperation shareRequest]upload:requestItem progrss:^(NSProgress *progress) {
        if (@available(iOS 11.0, *)) {
            !progressBlock?:progressBlock([progress.fileCompletedCount unsignedIntValue],[progress.fileTotalCount unsignedIntValue]);
        } else {
            // Fallback on earlier versions
            !progressBlock?:progressBlock(progress.completedUnitCount,progress.totalUnitCount);
        }
    } success:successBlock fail:failureBlock];
    
    return finalRequestItem.uploadTask;
}


+ (NSURLSessionDownloadTask *)downLoadWithUrl:(NSString *)url cacheFileFolderURL:(NSURL *)folderURL progress:(NSRTCDownloadProgress)progressBlock success:(NSRTCSuccess)successBlock fail:(NSRTCFail)failureBlock{
 
    
    
    /*! 检查地址中是否有中文 */
    NSString *urlPath = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    NSURLRequestDownloadItem *requestItem  = [NSURLRequestDownloadItem itemWithDownloadURLPath:urlPath cacheFileFolderURL:folderURL];
    [requestItem setCacheFileName:urlPath.lastPathComponent];
    NSURLRequestDownloadItem *finalRequestItem = [[NSURLRequestBaseOperation shareRequest]download:requestItem progrss:^(NSProgress *progress) {
        if (@available(iOS 11.0, *)) {
            !progressBlock?:progressBlock([progress.fileCompletedCount unsignedIntValue]*1.0/[progress.fileTotalCount unsignedIntValue]);
        } else {
            // Fallback on earlier versions
            !progressBlock?:progressBlock(progress.completedUnitCount*1.0/progress.totalUnitCount);
        }
    } success:successBlock fail:failureBlock];
    
    return finalRequestItem.downloadTask;
}

@end
