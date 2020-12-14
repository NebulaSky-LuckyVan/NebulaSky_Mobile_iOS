//
//  UIButton+Common.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "UIButton+Common.h"
#import <objc/runtime.h>

@implementation UIButton (Common)
-(void)observeControlEvents:(UIControlEvents)events withAction:(CommonAction)action{
    objc_setAssociatedObject(self, @selector(btnClick:), action, OBJC_ASSOCIATION_RETAIN);
    [self addTarget:self action:@selector(btnClick:) forControlEvents:events];
}
-(void)action:(CommonAction)action{
    [self observeControlEvents:UIControlEventTouchUpInside withAction:action];
}
-(void)btnClick:(UIButton*)sendor{
    CommonAction action = objc_getAssociatedObject(self, _cmd);
    !action?:action(sendor);
}

@end
