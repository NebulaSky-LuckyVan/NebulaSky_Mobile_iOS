//
//  NSRPCResultAnalysis.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface NSRPCResultAnalysis : NSObject
@property (nonatomic, assign, readonly) BOOL isCanUse;
@property (nonatomic, copy, readonly) NSString * errorCode;
@property (nonatomic, copy, readonly) NSString * errorMsg;

@property (nonatomic, strong, readonly) NSDictionary * dic;
@property (nonatomic, strong, readonly) NSDictionary * bodyDic;

+ (instancetype)decodeDictionary:(id)result;

@end
 
