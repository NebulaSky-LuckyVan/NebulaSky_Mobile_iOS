//
//  NSRTCChatViewController.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/1.
//  Copyright © 2019 VanZhang. All rights reserved.
//

 
#import "NSRTCBaseViewController.h"

@interface NSRTCChatViewController : NSRTCBaseViewController


@property (strong, nonatomic) NSString *toUser;
- (instancetype)initWithToUser:(NSString *)toUser;

- (CGRect)getImageRectInWindowAtIndex:(NSInteger)index;

@end 
