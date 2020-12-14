//
//  NSURLRequestItem.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSURLRequestItem.h"

 

@implementation NSURLRequestHeaderBody

- (instancetype)init{
    self = [super init];
    if (self) {
        _requestBody = @{}.mutableCopy;
        _requestHeader = @{}.mutableCopy;
    }
    return self;
}
@end
@implementation NSURLRequestItem

+ (instancetype)itemWithURLPath:(NSString *)urlPath pramaters:(NSDictionary *)arguments{
    NSURLRequestItem *item = [[NSURLRequestItem alloc]init];
    item.urlPath = urlPath;
    item.arguments = [arguments mutableCopy];
    [item setup];
    return item;
}

- (void)setup{
    _requestType = NSURLRequest_POST;
    _headerBody = [[NSURLRequestHeaderBody alloc]init];
    _DOMAINURLPATH = @"";

}

-(NSMutableDictionary *)arguments{
    if (!_arguments) {
        _arguments = [NSMutableDictionary dictionary];
    }
    return _arguments;
}
@end

@implementation NSURLRequestUploadItem


+ (instancetype)itemWithUploadURLPath:(NSString*)urlPath parameters:(NSDictionary*)arguments fileData:(NSData*)data fileName:(NSString*)name folderName:(NSString*)folder mimeType:(NSString*)mimeType  {
    NSURLRequestUploadItem *item = [[NSURLRequestUploadItem alloc]init];
    item.urlPath = urlPath;
    item.arguments = [arguments mutableCopy];
    item.fileName = name;
    item.fileData = data;
    item.fileFolderName = folder;
    item.mimeType = mimeType;
    [item setup];
    return item;
}
- (void)setup{
    _uploadAPI = self.urlPath;
    _uploadArguments = self.arguments;
    _uploadTask = self.dataTask;
    
}
@end

@implementation NSURLRequestDownloadItem
+ (instancetype)itemWithDownloadURLPath:(NSString*)urlPath cacheFileFolderURL:(NSURL*)folderURL{
    NSURLRequestDownloadItem  *downloadItem = [[NSURLRequestDownloadItem alloc]init];
    downloadItem.urlPath = urlPath;
    downloadItem.cacheFileFolderURL = folderURL;
    [downloadItem setup];
    return downloadItem;
}
- (void)setup{
    _downloadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlPath]];
    _downloadRequest.HTTPMethod = @"GET";
    _downloadRequest.timeoutInterval = 0;
    
}
- (void)setCacheFileName:(NSString *)cacheFileName{
    _cacheFileName = cacheFileName;
    if (!self.filePath) {
        self.filePath = [[self.cacheFileFolderURL absoluteString]stringByAppendingPathComponent:cacheFileName];
    }
}
@end
