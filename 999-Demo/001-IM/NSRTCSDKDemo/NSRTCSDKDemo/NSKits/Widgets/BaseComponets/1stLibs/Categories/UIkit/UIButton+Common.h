//
//  UIButton+Common.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
 
typedef void(^CommonAction)(UIButton*sendor);
@interface UIButton (Common)
-(void)action:(CommonAction)action;

@end
 
