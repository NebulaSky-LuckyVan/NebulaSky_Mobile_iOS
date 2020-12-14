//
//  NSRTCChatImageBrowserModel.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//


//#import <NSRTC/NSRTCBaseModel.h>

#import "NSBaseModel.h"

@class NSRTCDemoMessage;
@interface NSRTCChatImageBrowserModel : NSBaseModel
@property (nonatomic, copy) NSString *imageRemotePath;
@property (nonatomic, copy) NSString *thumRemotePath;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGRect imageRect;
//@property (nonatomic, assign) CGRect rectInChatRoom;
@property (nonatomic, assign) NSInteger messageIndex;


- (instancetype)initWithMessage:(NSRTCDemoMessage *)message;

@end

