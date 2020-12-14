//
//  NSURLRequestBaseOperation+RACSignal.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSURLRequestBaseOperation+RACSignal.h"
#import "NSURLRequestBaseOperation.h"
#import <MJExtension/MJExtension.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation NSURLRequestBaseOperation (RACSignal)
- (RACSignal*)getWithURL:(NSString*)url requestParam:(id)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary*args = nil;
        if ([params isKindOfClass:[NSDictionary class]]) {
            args = params;
        }else {
            args = [params mj_keyValues];
        }
        dispatch_queue_t networkQueue = dispatch_queue_create("com.NebulaSky.NetworkRequest.fetchData", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        @try {
            NSURLRequestItem *requestItm = [NSURLRequestItem itemWithURLPath:url pramaters:args];
            requestItm.requestType = NSURLRequest_GET;
            [[NSURLRequestBaseOperation shareRequest] request:requestItm success:^(id response) {
                dispatch_async(networkQueue, ^{
                    [subscriber sendNext:response];
                    dispatch_group_leave(group);
                    dispatch_group_leave(group);
                });
            } fail:^(id fail) {
              dispatch_async(networkQueue, ^{
                  [subscriber sendError:fail];
                  dispatch_group_leave(group);
              });
            }];
        } @catch (NSException *exception) {
            dispatch_async(networkQueue, ^{
                NSError *error
                = [NSError errorWithDomain:NSNetServicesErrorDomain
                                      code:400
                                  userInfo:@{@"errorMessage":exception.description,NSLocalizedDescriptionKey:@"catch crash info"}];
                [subscriber sendError:error];

                dispatch_group_leave(group);
            });
        }
        //end for
        //全完成后执行事件
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [subscriber sendCompleted];
        });
        return nil;
    }];
}
- (RACSignal*)postWithURL:(NSString*)url requestParam:(id)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary*args = nil;
        if ([params isKindOfClass:[NSDictionary class]]) {
            args = params;
        }else {
            args = [params mj_keyValues];
        }
        dispatch_queue_t networkQueue = dispatch_queue_create("com.NebulaSky.NetworkRequest.fetchData", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        @try {
            NSURLRequestItem *requestItm = [NSURLRequestItem itemWithURLPath:url pramaters:args];
            requestItm.requestType = NSURLRequest_POST;
            [[NSURLRequestBaseOperation shareRequest] request:requestItm success:^(id response) {
                dispatch_async(networkQueue, ^{
                    [subscriber sendNext:response];
                    dispatch_group_leave(group);
                    dispatch_group_leave(group);
                });
            } fail:^(id fail) {
              dispatch_async(networkQueue, ^{
                  [subscriber sendError:fail];
                  dispatch_group_leave(group);
              });
            }];
        } @catch (NSException *exception) {
            dispatch_async(networkQueue, ^{
                NSError *error
                = [NSError errorWithDomain:NSNetServicesErrorDomain
                                      code:400
                                  userInfo:@{@"errorMessage":exception.description,NSLocalizedDescriptionKey:@"catch crash info"}];
                [subscriber sendError:error];

                dispatch_group_leave(group);
            });
        }
        //end for
        //全完成后执行事件
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

- (RACSignal*)downloadWithURL:(NSString*)url requestParam:(id)params cacheFilePath:(NSString*)cachePath progress:(void(^)(NSProgress *progress))progressHandler{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary*args = nil;
        if ([params isKindOfClass:[NSDictionary class]]) {
            args = params;
        }else {
            args = [params mj_keyValues];
        }
        dispatch_queue_t networkQueue = dispatch_queue_create("com.NebulaSky.NetworkRequest.fetchData", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        @try {
            NSURL *CacheURL = [NSURL URLWithString:cachePath];
            NSURLRequestDownloadItem *requestItm = [NSURLRequestDownloadItem itemWithDownloadURLPath:url cacheFileFolderURL:CacheURL];
            [[NSURLRequestBaseOperation shareRequest]download:requestItm progrss:progressHandler success:^(id response) {
                dispatch_async(networkQueue, ^{
                    [subscriber sendNext:response];
                    dispatch_group_leave(group);
                });
            } fail:^(id fail) {
                dispatch_async(networkQueue, ^{
                    [subscriber sendError:fail];
                    dispatch_group_leave(group);
                });
            }];
        } @catch (NSException *exception) {
            dispatch_async(networkQueue, ^{
                

                NSError *error
                = [NSError errorWithDomain:NSNetServicesErrorDomain
                                      code:400
                                  userInfo:@{@"errorMessage":exception.description,NSLocalizedDescriptionKey:@"catch crash info"}];
                [subscriber sendError:error];
                dispatch_group_leave(group);
            });
        }
        //end for
        //全完成后执行事件
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [subscriber sendCompleted];
        });
        return nil;
    }];
}
 

- (RACSignal*)uploadWithURL:(NSString*)url requestParam:(id)params data:(NSData*)fileData name:(NSString*)folderName fileName:(NSString*)fName mimeType:(NSString*)mt progress:(void(^)(NSProgress *progress))progressHandler{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary*args = nil;
        if ([params isKindOfClass:[NSDictionary class]]) {
            args = params;
        }else {
            args = [params mj_keyValues];
        }
        dispatch_queue_t networkQueue = dispatch_queue_create("com.NebulaSky.NetworkRequest.fetchData", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        @try {
            NSURLRequestUploadItem *requestItm = [NSURLRequestUploadItem itemWithUploadURLPath:url parameters:args fileData:fileData fileName:fName folderName:folderName mimeType:mt];
            [[NSURLRequestBaseOperation shareRequest]upload:requestItm progrss:progressHandler success:^(id response) {
                dispatch_async(networkQueue, ^{
                    [subscriber sendNext:response];
                    dispatch_group_leave(group);
                });
            } fail:^(id fail) {
                dispatch_async(networkQueue, ^{
                    [subscriber sendError:fail];
                    dispatch_group_leave(group);
                });
            }];
            
             
        } @catch (NSException *exception) {
            dispatch_async(networkQueue, ^{
                NSError *error
                = [NSError errorWithDomain:NSNetServicesErrorDomain
                                      code:400
                                  userInfo:@{@"errorMessage":exception.description,NSLocalizedDescriptionKey:@"catch crash info"}];
                [subscriber sendError:error];
                dispatch_group_leave(group);
            });
        }
        //end for
        //全完成后执行事件
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [subscriber sendCompleted];
        });
        return nil;
    }];
}
@end
