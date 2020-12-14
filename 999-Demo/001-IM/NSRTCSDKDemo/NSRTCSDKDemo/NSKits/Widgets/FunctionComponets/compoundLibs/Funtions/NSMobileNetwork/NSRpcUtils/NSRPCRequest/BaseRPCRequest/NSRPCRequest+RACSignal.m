//
//  NSRPCRequest+RACSignal.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRPCRequest+RACSignal.h"

@implementation NSRPCRequest (RACSignal)

- (RACSignal*)requestWithOperation:(NSString*)operationType requestParam:(id)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         
        dispatch_queue_t RPCQueue = dispatch_queue_create("com.NebulaSky.RPC.fetchData", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        NSRequestItem *requestItm = [NSRequestItem shareWithOperationType:operationType requestParam:params];
        [[NSRPCRequest sharedRequest]requestWithItem:requestItm success:^(id response) {
          dispatch_async(RPCQueue, ^{
              [subscriber sendNext:response];
          });
        } failure:^(id fail) {
               dispatch_async(RPCQueue, ^{
                dispatch_group_leave(group);
                [subscriber sendError:fail];
            });
        }];
        //end for
        //全完成后执行事件
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [subscriber sendCompleted];
        });
        return nil;
    }];
}
@end
