//
//  NSCheetahRPCInterceptor.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSCheetahRPCInterceptor.h"

#import <APMobileNetwork/DTRpcInterface.h>
  
#import "NSCheetahRPCHeaderInfo.h"

#import <UTDID/UTDevice.h>

#import <APMobileNetwork/APMobileNetwork.h>
@interface NSCheetahRPCInterceptor()<DTRpcInterceptor>

@end
@implementation NSCheetahRPCInterceptor


- (DTRpcOperation *)beforeRpcOperation:(DTRpcOperation *)operation{
    
    // 业务网关的rpc，都需在请求报文body中的“header”里添加sid字段
    NSString *currentRpcGateway = [operation.gatewayURL absoluteString];
    NSString *businessRpcGateway = [[DTRpcInterface sharedInstance] gatewayURL];
    if ([currentRpcGateway isEqualToString:businessRpcGateway] ) {
        // 业务rpc才添加sid，mpaas组件网关不需要
        NSString *requestDataStr = operation.httpBodyParameters[@"requestData"];
        
        NSMutableArray *requestDataArray = [NSMutableArray arrayWithArray:[NSCheetahRPCInterceptor parseArrayFromJSONString:requestDataStr]];
        if ( [requestDataArray count] > 0 && [requestDataArray[0] isKindOfClass:[NSDictionary class]] && [(NSDictionary*)requestDataArray[0] count] > 0) {
            NSDictionary *requestData = requestDataArray[0];
            NSMutableDictionary *newRequestData = [NSMutableDictionary dictionaryWithDictionary:requestData];
            NSMutableDictionary *newRequestBody = [NSMutableDictionary dictionaryWithDictionary:newRequestData[@"_requestBody"]];
            NSMutableDictionary *newHeader = [NSMutableDictionary dictionaryWithDictionary:newRequestBody[@"header"]];
            [newHeader addEntriesFromDictionary:[NSCheetahRPCHeaderInfo headerInfo]];
            [newHeader addEntriesFromDictionary:@{
                @"Cookie":
                    [NSString stringWithFormat:@"JSESSIONID=%@",![UTDevice utdid]?@"":[UTDevice utdid]],
                @"h_transId":@"11",
                @"h_channel":@"11"
            }];

            [newRequestBody setValue:newHeader forKey:@"header"];
            [newRequestData setValue:newRequestBody forKey:@"_requestBody"];
            if (requestDataArray.count == 0)
            {
                [requestDataArray addObject:newRequestData];
            }
            else
            {
                [requestDataArray replaceObjectAtIndex:0 withObject:newRequestData];
            }
            // 转为string
            NSString *newRequestDataStr = [NSCheetahRPCInterceptor parseJSONStringFromObject:requestDataArray];
            [operation.httpBodyParameters setObject:newRequestDataStr forKey:@"requestData"];
        }
    }
    return operation;
}


- (DTRpcOperation *)afterRpcOperation:(DTRpcOperation *)operation{
    // TODO
    return operation;
}



+ (NSArray *)parseArrayFromJSONString:(NSString *)JSONString
{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

+(NSString *)parseJSONStringFromObject:(id)JSONObject
{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSONObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
    NSString *jsonString =  [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end
