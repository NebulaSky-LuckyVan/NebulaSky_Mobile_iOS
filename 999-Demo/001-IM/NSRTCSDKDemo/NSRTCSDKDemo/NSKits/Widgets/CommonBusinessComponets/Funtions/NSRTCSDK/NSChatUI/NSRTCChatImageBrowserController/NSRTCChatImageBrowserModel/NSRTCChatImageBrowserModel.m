//
//  NSRTCChatImageBrowserModel.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCChatImageBrowserModel.h"
#import "NSRTCDemoMessage.h"
@implementation NSRTCChatImageBrowserModel


- (instancetype)initWithMessage:(NSRTCDemoMessage *)message {
    if (self = [super init]) { 
        self.imageRemotePath = message.bodies.fileRemotePath;
        self.imageName = message.bodies.fileName;
    }
    return self;
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    CGFloat widthRatio = kScreenWidth/imageSize.width;
    CGFloat heigthRatio = kScreenHeight/imageSize.height;
    CGFloat scale = MIN(widthRatio, heigthRatio);
    CGFloat width = scale * imageSize.width;
    CGFloat height = scale * imageSize.height;
    self.imageRect = CGRectMake((kScreenWidth - width)/2.0, (kScreenHeight - height)/2, width, height);
}

@end
