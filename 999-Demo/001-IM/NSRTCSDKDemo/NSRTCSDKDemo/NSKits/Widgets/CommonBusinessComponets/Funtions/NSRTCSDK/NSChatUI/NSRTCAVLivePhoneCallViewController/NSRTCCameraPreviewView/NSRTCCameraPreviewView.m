//
//  NSRTCCameraPreviewView.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCCameraPreviewView.h"
 

@interface NSRTCCameraPreviewView ()
@property (copy, nonatomic) void (^CallTapHandlerBlock)(void);
@end
@implementation NSRTCCameraPreviewView
-(instancetype)init{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)tapCallBackHandler:(void (^)(void))handler{
    self.CallTapHandlerBlock = [handler copy];
    
}
- (void)tapClick:(UITapGestureRecognizer*)tap{
    !self.CallTapHandlerBlock?:self.CallTapHandlerBlock();
}

@end
