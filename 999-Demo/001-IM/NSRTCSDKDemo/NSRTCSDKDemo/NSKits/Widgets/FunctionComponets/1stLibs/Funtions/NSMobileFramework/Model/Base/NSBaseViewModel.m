//
//  NSBaseViewModel.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSBaseViewModel.h"

#ifdef NSViewController
#import "NSViewController.h"
#endif

@implementation NSBaseViewModel

+(instancetype)modelWithViewCtrl:(NSViewController *)viewCtrl{
    NSBaseViewModel * model = [[self alloc]init];
    model.viewController = viewCtrl;
    return model;
}
#pragma 获取网络可到达状态
- (void)checkNetwotkStatusWithURL:(NSString *)urlPath resultHandler:(RequestNetworkReachableBlock)reachableHandlerBlock{
    [NSURLRequestBaseOperation startNetWorkStatusMonitor:reachableHandlerBlock];
}
- (void)request:(NSURLRequestItem *)requestItem success:(ResponeHandlerBlock)response fail:(FailHandlerBlock)failHandlerBlock{
    [[NSURLRequestBaseOperation shareRequest]request:requestItem success:response fail:failHandlerBlock];
}
@end
