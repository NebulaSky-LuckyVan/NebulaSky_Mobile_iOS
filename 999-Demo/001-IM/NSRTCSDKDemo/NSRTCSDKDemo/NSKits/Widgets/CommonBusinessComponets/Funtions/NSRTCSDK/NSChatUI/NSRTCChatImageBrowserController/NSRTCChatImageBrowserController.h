//
//  NSRTCChatImageBrowserController.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//


 
//#import <NSRTC/NSRTCBaseViewController.h>

//#import "NSRTCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSRTCChatImageBrowserController : NSRTCBaseViewController

- (instancetype)initWithImageModels:(NSArray *)imageModels selectedIndex:(NSInteger)selectedIndex;

- (void)show;

@end

NS_ASSUME_NONNULL_END
