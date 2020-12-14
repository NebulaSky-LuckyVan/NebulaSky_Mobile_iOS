//
//  NSRTCVideoViewController.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

//#import <NSRTC/NSRTCBaseViewController.h>

#import "NSRTCBaseViewController.h"


@interface NSRTCVideoViewController : NSRTCBaseViewController
@property (nonatomic, copy) void(^takePhotoOrVideo)(NSData *data, BOOL isPhoto);
@property (nonatomic, assign) NSInteger maxSeconds;


@end
 

