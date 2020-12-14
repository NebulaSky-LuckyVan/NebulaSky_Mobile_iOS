//
//  NSRTCURLRequestOperation.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLRequestBaseOperation.h"

/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, NSRTCRequestType)
{
    /*! get请求 */
    GetRequest = 0,
    /*! post请求 */
    PostRequest
    
};
/*! 定义请求成功的block */
typedef void( ^NSRTCSuccess)(id response);
/*! 定义请求失败的block */
typedef void( ^NSRTCFail)(id error);

/*! 定义上传进度block */
typedef void( ^NSRTCUploadProgress)(int64_t bytesProgress,
                                int64_t totalBytesProgress);
/*! 定义下载进度block */
typedef void( ^NSRTCDownloadProgress)(CGFloat);



@interface NSRTCURLRequestOperation : NSURLRequestBaseOperation



/*!
 *  网络请求方法,block回调
 *  @param urlString    请求的地址
 *  @param parameters    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */
+ (NSURLSessionTask *)requestWithUrlString:(NSString *)urlString
                                parameters:(NSDictionary *)parameters
                                   success:(NSRTCSuccess)successBlock
                                      fail:(NSRTCFail)failureBlock;

+ (NSURLSessionTask *)request:(NSRTCRequestType)request
                withUrlString:(NSString *)urlString
                   parameters:(NSDictionary *)parameters
                      success:(NSRTCSuccess)successBlock
                         fail:(NSRTCFail)failureBlock;


+ (NSURLSessionTask *)request:(NSRTCRequestType)request
                withUrlString:(NSString *)urlString
               bodyParameters:(NSDictionary *)body
                      success:(NSRTCSuccess)successBlock
                         fail:(NSRTCFail)failureBlock;
#pragma mark - 图片上传
+ (NSURLSessionTask *)uploadImageWithUrlString:(NSString *)urlString
                                    parameters:(NSDictionary *)parameters
                                     imageData:(NSData *)imageData
                                      progress:(NSRTCUploadProgress)progressBlock
                                       success:(NSRTCSuccess)successBlock
                                          fail:(NSRTCFail)failureBlock;

#pragma mark - 文件下载
+ (NSURLSessionDownloadTask *)downLoadWithUrl:(NSString *)url
                           cacheFileFolderURL:(NSURL*)folderURL
                                     progress:(NSRTCDownloadProgress)progressBlock
                                      success:(NSRTCSuccess)successBlock
                                         fail:(NSRTCFail)failureBlock;
@end
 
