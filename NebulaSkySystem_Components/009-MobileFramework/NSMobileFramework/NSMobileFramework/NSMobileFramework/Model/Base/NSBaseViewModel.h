//
//  NSBaseViewModel.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSBaseModel.h"
@class NSViewController;
#import <ReactiveCocoa/ReactiveCocoa.h>
@class RACSignal, RACSubject, RACCommand, RACReplaySubject;
//Works：
//Kicking off network or database requests
//Determining when information should be hidden or shown
//Date and number formatting
//Localization
@interface NSBaseViewModel : NSBaseModel
@property (weak, nonatomic,setter=setSuperViewController:)   NSViewController *viewController ;

+(instancetype)modelWithViewCtrl:(NSViewController*)viewCtrl;

////获取网络的链接状态
//- (void)checkNetwotkStatusWithURL:(NSString *)urlPath resultHandler:(RequestNetworkReachableBlock)reachableHandlerBlock;
//
//- (void)request:(YNETRTCRequstItem*)requestItem success:(ResponeHandlerBlock)response fail:(FailHandlerBlock)failHandlerBlock;

@end
 
