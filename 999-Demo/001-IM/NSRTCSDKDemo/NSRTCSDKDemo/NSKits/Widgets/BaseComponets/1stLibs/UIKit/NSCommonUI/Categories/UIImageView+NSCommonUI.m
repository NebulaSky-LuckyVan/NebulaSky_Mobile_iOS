//
//  UIImageView+NSCommonUI.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "UIImageView+NSCommonUI.h"
#import "UIView+NSCommonUI.h"
@implementation UIImageView (NSCommonUI)

@end

@implementation UIImageView (NSRadiusImage)
- (void)setCornerRadiusImage:(UIImage*)image withCornerRadius:(CGFloat)radius{
    self.image = image;
    [self addCornerWithRadius:radius];
}
@end
