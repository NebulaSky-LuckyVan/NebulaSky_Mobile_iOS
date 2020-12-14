//
//  NSRTCDemoMessage.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/1.
//  Copyright © 2019 VanZhang. All rights reserved.
//
 

//#import <NSRTC/NSRTCMessage.h>

//#import <NSRTC/NSRTCMessage.h>
#import "NSRTCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSRTCDemoMessage : NSRTCMessage


/** 在聊天界面行高 */
@property (nonatomic, assign) CGFloat messageCellHeight;
/** 文字气泡尺寸 */
@property (nonatomic, assign) CGSize textMessageLabelSize;


@end

NS_ASSUME_NONNULL_END
