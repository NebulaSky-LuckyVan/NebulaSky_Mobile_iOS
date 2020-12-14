//
//  NSLoginViewModel.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/8.
//  Copyright © 2019 VanZhang. All rights reserved.
//
#import "NSBaseViewModel.h"
 

@interface NSLoginViewModel : NSBaseViewModel
//Desc:
@property (strong, nonatomic) NSString *userName;
//Desc:
@property (strong, nonatomic) NSString *password;
//Desc:
@property (strong, nonatomic) RACSubject *loginHandlerSbj;
//Desc:
@property (strong, nonatomic) RACSubject *syncDeviceIdReLoginHandlerSbj;


//Desc:
@property (strong, nonatomic) RACSubject *registerHandlerSbj;

+ (void)socketConnectWithToken:(NSString *)token complection:(void(^)(BOOL success))complectionHandlerBlock;

@end
 
