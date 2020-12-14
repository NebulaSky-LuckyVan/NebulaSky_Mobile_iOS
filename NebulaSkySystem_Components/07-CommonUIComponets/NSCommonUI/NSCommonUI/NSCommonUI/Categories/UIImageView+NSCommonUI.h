//
//  UIImageView+NSCommonUI.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (NSCommonUI)

@end

@interface UIImageView (NSRadiusImage)
- (void)setCornerRadiusImage:(UIImage*)image withCornerRadius:(CGFloat)radius;
@end

