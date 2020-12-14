//
//  NSRTCGroupChatViewController.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/9.
//  Copyright © 2020 NebulaSky. All rights reserved.
//
 
 

@interface NSRTCGroupChatViewController : NSRTCBaseViewController

+ (instancetype)groupChatWithUsers:(NSArray<NSString *>*)toUsers;
- (CGRect)getImageRectInWindowAtIndex:(NSInteger)index;

@end
 
