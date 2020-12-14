//
//  NSRPCResultAnalysis.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRPCResultAnalysis.h"

 

@interface NSRPCResultAnalysis ()

@property (nonatomic, assign) BOOL isCanUse;
@property (nonatomic, copy) NSString * errorCode;
@property (nonatomic, copy) NSString * errorMsg;

@property (nonatomic, strong) NSDictionary * dic;
@property (nonatomic, strong) NSDictionary * bodyDic;

@end

@implementation NSRPCResultAnalysis

+ (instancetype)decodeDictionary:(id)result{
   NSRPCResultAnalysis * ana = [[NSRPCResultAnalysis alloc]init];
   [ana decodeDictionary:result];
   return ana;
}

- (void)decodeDictionary:(id)result{
   // 字典非法 result不可用
   if ([self checkDictionary:result dicName:@"result"] == NO) {
       self.isCanUse = NO;
       return;
   }
   NSDictionary * dic = (NSDictionary *)result;
   self.dic = dic;
   
   
   // header非法 result不可用
   NSDictionary * headerDic = dic[@"header"];
   if ([self checkDictionary:headerDic dicName:@"header"] == NO) {
       self.isCanUse = NO;
       return;
   }
   
   
   // 解析code 和 msg
   NSString * code = headerDic[@"errorCode"];
   NSString * msg = headerDic[@"errorMsg"];
   if ([self checkString:code stringName:@"errorCode"]) self.errorCode = code;
   if ([self checkString:msg stringName:@"errorMsg"]) self.errorMsg = msg;
   
   
   // code不为0 result不可用
   if ([code isEqualToString:@"0"] == NO) {
       self.isCanUse = NO;
       return;
   }
   
   
   // body非法 result不可用
   NSDictionary * bodyDic = dic[@"body"];
   if ([self checkDictionary:bodyDic dicName:@"body"] == NO) {
       self.isCanUse = NO;
       return;
   }
   self.bodyDic = bodyDic;
   
   
   self.isCanUse = YES;
}

- (BOOL)checkDictionary:(id)dic
               dicName:(NSString *)name{
   if(dic == nil){
       NSLog(@"NSRPCResultAnalysis - '%@' is nil",name);
       return NO;
   }else if (![dic isKindOfClass:[NSDictionary class]]) {
       NSLog(@"NSRPCResultAnalysis - '%@' is not a dictionary, %@",name,dic);
       return NO;
   }
   return YES;
}

- (BOOL)checkString:(NSString *)string
        stringName:(NSString *)name{
   if(string == nil){
       NSLog(@"NSRPCResultAnalysis - '%@' string is nil",name);
       return NO;
   }else if (![string isKindOfClass:[NSString class]]) {
       NSLog(@"NSRPCResultAnalysis - '%@' string is not a NSString, %@",name,string);
       return NO;
   }else if(string.length == 0){
       NSLog(@"NSRPCResultAnalysis - '%@' string length is 0",name);
       return NO;
   }
   return YES;
}
@end
