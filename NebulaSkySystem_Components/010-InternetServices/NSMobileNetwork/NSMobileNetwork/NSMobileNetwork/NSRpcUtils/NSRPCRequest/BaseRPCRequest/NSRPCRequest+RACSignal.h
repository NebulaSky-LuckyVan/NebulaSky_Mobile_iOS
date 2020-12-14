//
//  NSRPCRequest+RACSignal.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRPCRequest.h"
 
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface NSRPCRequest (RACSignal)
- (RACSignal*)requestWithOperation:(NSString*)operationType requestParam:(id)params;

@end
 
