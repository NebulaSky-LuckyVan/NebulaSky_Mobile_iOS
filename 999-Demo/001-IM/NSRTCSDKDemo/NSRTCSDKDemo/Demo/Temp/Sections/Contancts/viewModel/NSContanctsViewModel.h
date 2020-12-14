//
//  NSContanctsViewModel.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSItemViewModel.h"
 

@interface NSContanctsViewModel : NSItemViewModel
//Desc:
@property (strong, nonatomic) RACSubject *requestContanctsListHandlerSbj;
@property (strong, nonatomic) RACSubject *requestOpenDrodownMenuHandlerSbj;
//Desc:
@property (strong, nonatomic) RACSubject *requestExcuteContactFilterHandlerSbj;

//Desc:
@property (strong, nonatomic) RACSubject *requestExcuteContactHeaderClickHandlerSbj;

@end
 
