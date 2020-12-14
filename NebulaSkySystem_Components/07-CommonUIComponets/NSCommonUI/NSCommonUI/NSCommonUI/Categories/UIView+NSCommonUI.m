//
//  UIView+NSCommonUI.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "UIView+NSCommonUI.h"

@implementation UIView (NSCommonUI)

@end
@implementation UIView (NSNib)
+ (instancetype)loadingXib{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class])
                                        owner:nil
                                      options:nil].lastObject;
}
+ (UINib *)loadingNib:(Class)aClass {
    NSString *className = NSStringFromClass(aClass);
    return [UINib nibWithNibName:className bundle:[NSBundle mainBundle]];
}
+ (UINib *)loadingNib{
    return [UIView loadingNib:self];
}
+ (NSString *)reuseId{
    return NSStringFromClass([self class]);
}
+ (NSString *)headerReuseId{
    return [self reuseId];
}
+ (NSString *)footerReuseId{
    return [self reuseId];
}
@end

@implementation UIView (NSRadiusCorner)
- (void)addCornerWithRadius:(CGFloat)radius{
    [self addCornerWithRadius:radius borderWidth:0 borderColor:nil];
}
- (void)addCornerWithRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color{
    [self addCornerWithRadius:radius roundingCorners:UIRectCornerAllCorners borderWidth:width borderColor:color];
}

- (void)addCornerWithRadius:(CGFloat)radius roundingCorners:(UIRectCorner)corners borderWidth:(CGFloat)width borderColor:(UIColor *)color{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    maskLayer.path =  maskPath.CGPath;
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.mask = maskLayer;
    
    if (width&&color) {
        NSLog(@"%s",__func__);
    }
}
@end
