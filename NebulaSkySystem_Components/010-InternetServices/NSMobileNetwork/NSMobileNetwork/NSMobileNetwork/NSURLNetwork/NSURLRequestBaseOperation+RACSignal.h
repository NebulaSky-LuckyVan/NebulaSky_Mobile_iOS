//
//  NSURLRequestBaseOperation+RACSignal.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSURLRequestBaseOperation.h"
#import <ReactiveCocoa/RACSignal.h>

@interface NSURLRequestBaseOperation (RACSignal)

- (RACSignal*)getWithURL:(NSString*)url requestParam:(id)params;

- (RACSignal*)postWithURL:(NSString*)url requestParam:(id)params;

- (RACSignal*)downloadWithURL:(NSString*)url requestParam:(id)params cacheFilePath:(NSString*)cachePath progress:(void(^)(NSProgress *progress))progressHandler;
  
- (RACSignal*)uploadWithURL:(NSString*)url requestParam:(id)params data:(NSData*)fileData name:(NSString*)folderName fileName:(NSString*)fName mimeType:(NSString*)mt progress:(void(^)(NSProgress *progress))progressHandler;

@end
 
