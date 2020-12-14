//
//  NSURLRequest.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//

#ifndef NSURLRequest_h
#define NSURLRequest_h
#import <Foundation/Foundation.h>

typedef void(^ResponeHandlerBlock)(id response);
typedef void(^FailHandlerBlock)(id fail);
typedef void(^ProgresRateHandlerBlock)(NSProgress *progress);
typedef void(^RequestNetworkReachableBlock)(BOOL networkReachable);

typedef NS_ENUM(NSUInteger,NSURLRequestType) {
    NSURLRequest_GET  = 0,
    NSURLRequest_POST,
    NSURLRequest_PUT,
    NSURLRequest_PATCH,
    NSURLRequest_DELETE,
};

#import "NSURLRequestItem.h"
#import "NSURLRequestBaseOperation.h"



#endif /* NSURLRequest_h */
