//
//  NSRTCAVLivePhoneCallViewController.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//


//#import <NSRTC/NSRTCMessage.h>
//#import <NSRTC/NSRTCBaseViewController.h>

//#import <NSRTCSDK/NSRTCBaseViewController.h>
//#import "NSRTCBaseViewController.h"

#import "NSRTCAVLivePhoneCallMainView.h"

@interface NSRTCAVLivePhoneCallViewController : NSViewController
+ (instancetype)takePhoneCall:(NSRTCAVLivePhoneCallCallType)callType toUser:(NSString*)callee;


+ (instancetype)takeGroupPhoneCall:(NSRTCAVLivePhoneCallCallType)callType toUsers:(NSArray*)callees;


+ (instancetype)receivePhoneCall:(NSRTCAVLivePhoneCallCallType)callType phoneCallInfo:(NSDictionary*)phoneCallInfo;

@end

