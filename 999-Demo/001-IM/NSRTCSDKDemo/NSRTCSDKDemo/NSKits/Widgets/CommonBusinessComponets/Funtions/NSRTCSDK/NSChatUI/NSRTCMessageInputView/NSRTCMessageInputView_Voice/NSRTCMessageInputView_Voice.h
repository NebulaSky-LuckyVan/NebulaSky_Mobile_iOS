//
//  NSRTCMessageInputView_Voice.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface NSRTCMessageInputView_Voice : UIView

@property (copy, nonatomic) void(^recordSuccessfully)(NSString*, NSTimeInterval);

@end
