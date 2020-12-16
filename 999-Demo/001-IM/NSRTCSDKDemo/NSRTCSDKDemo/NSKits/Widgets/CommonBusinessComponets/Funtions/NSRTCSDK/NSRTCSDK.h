//
//  NSRTCSDK.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#ifndef NSRTCSDK_h
#define NSRTCSDK_h
#ifdef __OBJC__
#ifdef __cplusplus
//#include <opencv2/opencv.hpp>
//#include <opencv2/stitching/detail/blenders.hpp>
//#include <opencv2/stitching/detail/exposure_compensate.hpp>
#else
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Availability.h>
#endif

#import "NSRTCConstant.h"
 




#import "NSRTCClient.h"
#import "NSRTCMessage.h"
#import "NSRTCManager.h"
#import "NSRTCMessageConstructor.h"
#import "NSRTCChatManager.h"
#import "NSRTCChatMessageDBOperation.h"



#import "NSRTCChatUser.h"
#import "NSRTCMessageNotifyer.h"
 

#import "NSRTCConversation.h"
#import "NSUnReadConversationModel.h"

#import "NSRTCChatViewModel.h"
#import "NSRTCAVChatViewModel.h"
#import "NSRTCChatListViewModel.h"

#import "NSRTCChatUser.h" 
#import "NSRTCAVLiveChatUser.h"
#import "NSRTCAVLiveManager.h"
#import "NSRTCAVLiveConnectionManager.h"
#import "NSRTCAVLivePhoneCallManager.h"

#endif

#endif /* NSRTCSDK_h */
