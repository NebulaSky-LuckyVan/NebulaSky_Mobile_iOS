//
//  NSURLRequestBaseOperation.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSURLRequestBaseOperation.h"

#import "NSURLRequestItem.h"
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>

#import "NSMobileNetworkDataParser.h"
@interface NSURLRequestBaseOperation ()
@property (strong, nonatomic) AFURLSessionManager *urlSessionManager;
@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;
@property (strong, nonatomic) AFHTTPRequestSerializer *requestSerializer;
@property (strong, nonatomic) AFHTTPResponseSerializer *responseSerializer;
@property (strong, nonatomic) NSURLSessionConfiguration *urlSessionConfiguration;

@end
@interface NSURLRequestBaseOperation ()
@property (strong, nonatomic) NSString *baseURLPath;
@end
@implementation NSURLRequestBaseOperation



static void (^CallAsyncExcuteHandler)(NSURLSessionTask*) = ^(NSURLSessionTask*requestSessionTask){
    //desc:
    [requestSessionTask suspend];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [requestSessionTask resume];
    });
    [requestSessionTask resume];
};
 
#pragma request

- (NSURLRequestItem *)request:(NSURLRequestItem *)reqItem success:(ResponeHandlerBlock)responseHandler fail:(FailHandlerBlock)failHandler{
    NSURLRequestItem *originalReqItm = reqItem;
    typedef void(^SuccesComplectionHandler)(NSURLSessionDataTask*,id response);
    typedef void(^FailComplectionHandler)(NSURLSessionDataTask*,NSError *error);
    SuccesComplectionHandler CallSuccesComplection = ^(NSURLSessionDataTask*dataTask,id response){
        originalReqItm.response = response;
        if (dataTask) {
            originalReqItm.dataTask = dataTask;
        }
        [NSURLRequestBaseOperation parsingWithJsonData:response result:^(id parserResult) {//JSON解析
            !responseHandler?:responseHandler(parserResult);
        }];
    };
    FailComplectionHandler CallFailComplection = ^(NSURLSessionDataTask*dataTask,NSError *error){
        originalReqItm.error = error;
        if (dataTask) {
            originalReqItm.dataTask = dataTask;
        }
        !failHandler?:failHandler(error);
    };
    
    
    if (reqItem.headerBody.requestBody.allValues.count>0 &&reqItem.headerBody.requestBody.allKeys.count>0) {
        
        NSString *requestUrl = [originalReqItm.DOMAINURLPATH stringByAppendingPathComponent:originalReqItm.urlPath];
        NSLog(@"请求链接为：----%@,请求参数字典为：------%@",requestUrl,originalReqItm.headerBody.requestBody);
        NSArray *requestType = @[@"GET",@"POST",@"PUT",@"PATCH",@"DELETE"]; ;
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:requestType[reqItem.requestType] URLString:requestUrl parameters:nil error:nil];
        request.timeoutInterval = 15;
        
        
        // 设置HttpBody
//        if (reqItem.requestType != NSURLRequest_GET) {
            if (originalReqItm.headerBody.requestBody.allKeys>0&&originalReqItm.headerBody.requestBody.allValues>0) {
                [request setHTTPBody:[originalReqItm.headerBody.requestBody yy_modelToJSONData]];
            }
//        }
        
        originalReqItm.dataTask = [self.urlSessionManager dataTaskWithRequest:request uploadProgress:NULL downloadProgress:NULL completionHandler:^(NSURLResponse *   response, id    responseObject, NSError *   error) {
            if (!error) {
                CallSuccesComplection(originalReqItm.dataTask,responseObject);
            } else {
                CallFailComplection(originalReqItm.dataTask,error);
            }
        }];
        
    }else{
        NSString *url  = @"";
        if (@available(iOS 9.0,*)) {
            url =  [[self.httpSessionManager.baseURL.absoluteString stringByAppendingPathComponent:reqItem.urlPath] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            url = [[self.httpSessionManager.baseURL.absoluteString stringByAppendingPathComponent:url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
        }
        NSLog(@"请求URL:%@",url);
        NSLog(@"请求参数:%@",reqItem.arguments);
        
        
        switch (reqItem.requestType) {
            case NSURLRequest_GET:{
                originalReqItm.dataTask =  [self.httpSessionManager GET:url parameters:reqItem.arguments headers:nil  progress:nil success:CallSuccesComplection failure:CallFailComplection];
            }break;
            case NSURLRequest_POST:{
                originalReqItm.dataTask =  [self.httpSessionManager POST:url parameters:reqItem.arguments headers:nil  progress:nil success:CallSuccesComplection failure:CallFailComplection];
            }break;
            case NSURLRequest_PUT:{
                originalReqItm.dataTask = [self.httpSessionManager PUT:url parameters:reqItem.arguments headers:nil  success:CallSuccesComplection failure:CallFailComplection];
            }break;
            case NSURLRequest_PATCH:{
                originalReqItm.dataTask =  [self.httpSessionManager PATCH:url parameters:reqItem.arguments headers:nil  success:CallSuccesComplection failure:CallFailComplection];
            }break;
            case NSURLRequest_DELETE:{
                originalReqItm.dataTask = [self.httpSessionManager DELETE:url parameters:reqItem.arguments headers:nil  success:CallSuccesComplection failure:CallFailComplection];
            }break;
        }
        CallAsyncExcuteHandler(originalReqItm.dataTask);
    }
    
    return originalReqItm;
}


#pragma upload

- (NSURLRequestUploadItem *)upload:(NSURLRequestUploadItem *)reqItem progrss:(ProgresRateHandlerBlock)progressHandler success:(ResponeHandlerBlock)responseHandler fail:(FailHandlerBlock)failHandler{
    NSURLRequestUploadItem *originalReqItm = reqItem;
    
    typedef void(^ConstructingBodyExcuteHandler)(id<AFMultipartFormData>formData);
    typedef void(^ProgressExcuteHandler)(NSProgress *uploadProgress);
    typedef void(^SuccesComplectionHandler)(NSURLSessionDataTask*,id response);
    typedef void(^FailComplectionHandler)(NSURLSessionDataTask*,NSError *error);
    
    ConstructingBodyExcuteHandler CallConstructingBodyExcuteBlock = ^(id<AFMultipartFormData>formData){
        [formData appendPartWithFileData:originalReqItm.fileData name:originalReqItm.fileFolderName fileName:originalReqItm.fileName mimeType:originalReqItm.mimeType];
    };
    ProgressExcuteHandler CallProgressExcuteBlock = ^(NSProgress *uploadProgress){
        originalReqItm.progress = uploadProgress;
        !progressHandler?:progressHandler(uploadProgress);
    };
    SuccesComplectionHandler CallSuccesComplectionBlock = ^(NSURLSessionDataTask*task,id response){
        originalReqItm.response = response;
        [NSURLRequestBaseOperation parsingWithJsonData:response result:^(id parserResult) {//JSON解析
           originalReqItm.response = parserResult;
           !responseHandler?:responseHandler(parserResult);
        }];
    };
    FailComplectionHandler CallFailComplectionBlock = ^(NSURLSessionDataTask*task,NSError *error){
        originalReqItm.error = error;
        !failHandler?:failHandler(error);
    };
    originalReqItm.uploadTask=  [self.httpSessionManager POST:originalReqItm.uploadAPI
                                                   parameters:originalReqItm.uploadArguments
                                                      headers:nil
                                    constructingBodyWithBlock:CallConstructingBodyExcuteBlock
                                                     progress:CallProgressExcuteBlock
                                                      success:CallSuccesComplectionBlock
                                                      failure:CallFailComplectionBlock];
    CallAsyncExcuteHandler(originalReqItm.uploadTask);
    return originalReqItm;
}


#pragma download

- (NSURLRequestDownloadItem *)download:(NSURLRequestDownloadItem *)reqItem progrss:(ProgresRateHandlerBlock)progressHandler success:(ResponeHandlerBlock)responseHandler fail:(FailHandlerBlock)failHandler{
    NSURLRequestDownloadItem *originalReqItm = reqItem;
    
     
    typedef void(^ProgressExcuteHandler)(NSProgress *uploadProgress);
    typedef NSURL *(^DestinationExcuteHandler)(NSURL *targetPath, NSURLResponse *response);
    typedef void(^ComplectionHandler)(NSURLResponse *response, NSURL *filePath, NSError *error);
     
    ProgressExcuteHandler CallProgressExcuteBlock = ^(NSProgress *downloadProgress){
        originalReqItm.downloadProgress = downloadProgress;
        !progressHandler?:progressHandler(downloadProgress);
     };
    DestinationExcuteHandler CallDestinationExcuteBlock = ^NSURL *(NSURL *  targetPath, NSURLResponse *  response){
        originalReqItm.cacheFileName = [response suggestedFilename];
        return [originalReqItm.cacheFileFolderURL URLByAppendingPathComponent:[response suggestedFilename]];//下载后缓存到这个URL中
    };
    ComplectionHandler CallComplectionBlock = ^(NSURLResponse *response, NSURL *filePath, NSError *error){
        originalReqItm.filePath = [filePath absoluteString];
        originalReqItm.error = error;
        originalReqItm.response = response;
        if (!error) {
            !responseHandler?:responseHandler(response);
        }else{
            !failHandler?:failHandler(error);
        }
    };
    
    
    originalReqItm.downloadTask =  [self.httpSessionManager downloadTaskWithRequest:originalReqItm.downloadRequest
                                                                           progress:CallProgressExcuteBlock
                                                                        destination:CallDestinationExcuteBlock
                                                                  completionHandler:CallComplectionBlock];
    
    CallAsyncExcuteHandler(originalReqItm.downloadTask);
    return originalReqItm;
}


#pragma private base
-(AFHTTPSessionManager *)httpSessionManager{
    if (!_httpSessionManager) {
        _httpSessionManager =  [self managerWithBaseURL:self.baseURLPath];
    }
    return _httpSessionManager;
}
-(AFURLSessionManager *)urlSessionManager{
    if (!_urlSessionManager) {
        _urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:self.urlSessionConfiguration];
        _urlSessionManager.responseSerializer  =  self.responseSerializer;
//        NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"wifi" ofType:@"cer"];
//        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone withPinnedCertificates:[[NSSet alloc] initWithObjects:nil]];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        // 客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        _urlSessionManager.securityPolicy = securityPolicy; 
        [_urlSessionManager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }];
    }
    return _urlSessionManager;
}

-(AFHTTPRequestSerializer *)requestSerializer{
    if (!_requestSerializer) {
        AFHTTPRequestSerializer *reqSerializer =[AFHTTPRequestSerializer serializer];
        reqSerializer.timeoutInterval = 15.0f;
        reqSerializer.HTTPShouldHandleCookies = YES;
        reqSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [reqSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //        [reqSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        [reqSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        //        [reqSerializer setValue:baseURL.absoluteString forHTTPHeaderField:@"Referer"];
        _requestSerializer = reqSerializer;
    }
    return _requestSerializer;
}
-(AFHTTPResponseSerializer *)responseSerializer{
    if (!_responseSerializer) {
        AFHTTPResponseSerializer *respSerializer = [AFHTTPResponseSerializer serializer];
        respSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                 @"application/json",
                                                 @"text/plain",
                                                 @"text/javascript",
                                                 @"text/json",
                                                 @"text/html",nil];
        _responseSerializer = respSerializer;
    }
    return _responseSerializer;
}
-(NSURLSessionConfiguration *)urlSessionConfiguration{
    if (!_urlSessionConfiguration) {
        NSURLSessionConfiguration *sessionConfig =   [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSessionConfiguration = sessionConfig;
    }
    return _urlSessionConfiguration;
}
#pragma mark - 自定义配置
//2.0
-(AFHTTPSessionManager*)managerWithBaseURL:(NSString*)baseUrlPath{
    NSURL *baseURL = [NSURL URLWithString:baseUrlPath];
#pragma mark  1.配置_NSURLSession 请求的相关细节设置
    NSURLSessionConfiguration *sessionConfig =   self.urlSessionConfiguration;
#pragma mark  2.配置请求_串行器
    AFHTTPRequestSerializer *reqSerializer =self.requestSerializer;
    [reqSerializer setValue:baseURL.absoluteString forHTTPHeaderField:@"Referer"];
#pragma mark  3.配置响应_串行器
    AFHTTPResponseSerializer *respSerializer = self.responseSerializer;
    
    AFHTTPSessionManager *mgr = [self managerWithBaseURL:baseUrlPath
                                    sessionConfiguration:sessionConfig
                                       requestSerializer:reqSerializer
                                      responseSerializer:respSerializer];
#pragma mark  4.证书配置
    //    //设置证书模式
//    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"wifi" ofType:@"cer"];
//    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//    mgr.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
//    // 客户端是否信任非法证书
//    mgr.securityPolicy.allowInvalidCertificates = YES;
//    // 是否在证书域字段中验证域名
//    [mgr.securityPolicy setValidatesDomainName:NO];
    return mgr;
}
//1.0
-(AFHTTPSessionManager*)managerWithBaseURL:(NSString *)baseURL sessionConfiguration:(NSURLSessionConfiguration*)config requestSerializer:(AFHTTPRequestSerializer*)reqSerializer responseSerializer:(AFHTTPResponseSerializer*)respSerializer{
    NSURL *url = [NSURL URLWithString:baseURL];
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc]initWithBaseURL:url sessionConfiguration:config];
    mgr.requestSerializer = reqSerializer;
    mgr.responseSerializer = respSerializer;
    return mgr;
}


#pragma mark- 网络监听
+(void)startNetWorkStatusMonitor:(RequestNetworkReachableBlock)monitorBlock{
    __block BOOL networkReachable  = NO;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown:
                networkReachable = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkReachable = YES;
                break;
            default:
                break;
        }
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        !monitorBlock?:monitorBlock(networkReachable);
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+(void)parsingWithJsonData:(id)jsonData result:(void(^)(id))resBlk{
    [NSMobileNetworkDataParser json_parserWithData:jsonData readingOptions:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
     |NSJSONReadingAllowFragments result:^(id parserResult) {
        !resBlk?:resBlk(parserResult);
    }];
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
+ (instancetype)shareRequest{
    return [self shareRequestWithBaseURL:@""];
}
+ (instancetype)shareRequestWithBaseURL:(NSString *)baseURLPath{
    NSURLRequestBaseOperation *request = [[self alloc]init];
    request.baseURLPath = baseURLPath;
    return request;
}
//===================================//
@end
