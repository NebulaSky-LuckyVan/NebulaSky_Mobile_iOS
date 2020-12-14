//
//  NSURLRequestItem.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLRequest.h"
@class NSURLRequestHeaderBody;


@interface NSURLRequestItem : NSObject
@property (assign, nonatomic) NSURLRequestType requestType;

@property (assign, nonatomic) NSString * DOMAINURLPATH;
@property (strong, nonatomic) NSString * urlPath;



@property (strong, nonatomic) NSURLRequestHeaderBody *headerBody;
@property (strong, nonatomic) NSMutableDictionary *arguments;


@property (strong, nonatomic) NSURLSessionDataTask *dataTask;



@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) id response;

+ (instancetype)itemWithURLPath:(NSString*)urlPath pramaters:(NSDictionary*)arguments;
@end

@interface NSURLRequestHeaderBody:NSObject

@property (strong, nonatomic) NSMutableDictionary *requestHeader;
@property (strong, nonatomic) NSMutableDictionary *requestBody;
@end



@interface NSURLRequestUploadItem : NSURLRequestItem
@property (strong, nonatomic) NSData   *fileData;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *mimeType;
@property (strong, nonatomic) NSString *fileFolderName;

@property (strong, nonatomic) NSString *uploadAPI;
@property (strong, nonatomic) NSMutableDictionary *uploadArguments;



@property (strong, nonatomic) NSURLSessionDataTask *uploadTask;
@property (strong, nonatomic) NSProgress *progress;

+ (instancetype)itemWithUploadURLPath:(NSString*)urlPath parameters:(NSDictionary*)arguments fileData:(NSData*)data fileName:(NSString*)name folderName:(NSString*)folder mimeType:(NSString*)mimeType;
@end


@interface NSURLRequestDownloadItem : NSURLRequestItem

@property (strong, nonatomic) NSMutableURLRequest* downloadRequest;
@property (strong, nonatomic) NSProgress* downloadProgress;

@property (strong, nonatomic) NSString* cacheFileName;
@property (strong, nonatomic) NSURL* cacheFileFolderURL;
@property (strong, nonatomic) NSString* filePath;


@property (strong, nonatomic) NSURLSessionDownloadTask* downloadTask;


+ (instancetype)itemWithDownloadURLPath:(NSString*)urlPath cacheFileFolderURL:(NSURL*)folderURL;



@end
