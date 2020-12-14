//
//  NSBaseRPCRequestItem.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface NSBaseRPCRequestItem : NSObject

/** 返回对象的类型。 */
@property(nonatomic, copy) NSString *returnType;
/** rpc超时时长可设置 */
@property(nonatomic,assign) NSTimeInterval timeoutInterval;
/** 检查登录 */
@property(nonatomic, assign) BOOL checkLogin;
/** 签名 */
@property(nonatomic, assign) BOOL signCheck;
/** 加密 */
@property(nonatomic, assign) BOOL isCrypt;


/** params */
@property(nonatomic, strong) NSArray *params;
/** Operation type */
@property(nonatomic,   copy) NSString *operationType;
/** requestHeaderField */
@property(nonatomic, strong) NSDictionary *requestHeaderField;

@end
@interface NSRequestItem : NSBaseRPCRequestItem
/**
 RPC请求通用方法（字典传参的方式）
 @param operationType 与mPaaS后台配置的接口operationType一致
 @param params 要上传的body参数
 */
+ (instancetype)shareWithOperationType:(NSString*)operationType requestParam:(id)params;

@end
