//
//  UIView+Common.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "UIView+Common.h"

#import <MBProgressHUD/MBProgressHUD.h>

#define kTagLineView 1007
@implementation UIView (Common)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    [self setFrame:frame];
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    [self setFrame:frame];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    [self setFrame:frame];
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxX:(CGFloat)maxX {
    
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setMaxY:(CGFloat)maxY {
    
}


- (void)doCircleFrame {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    //    self.layer.borderWidth = 0.5;
    //    self.layer.borderColor = kColorDDD.CGColor;
}

- (void)setCornerRadius:(CGFloat)radius {
    
    self.layer.cornerRadius = radius;
    [self _config];
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    [self _config];
}

- (void)_config
{
    self.layer.masksToBounds = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
    
    
}

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}
+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, pointY, [UIScreen mainScreen].bounds.size.width - leftSpace, 0.5)];
    lineView.backgroundColor = color;
    return lineView;
}
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color{
    return [self addLineUp:hasUp andDown:hasDown andColor:color andLeftSpace:0];
}
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
    [self removeViewWithTag:kTagLineView];
    if (hasUp) {
        UIView *upView = [UIView lineViewWithPointYY:0 andColor:color andLeftSpace:leftSpace];
        upView.tag = kTagLineView;
        [self addSubview:upView];
    }
    if (hasDown) {
        UIView *downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds)-0.5 andColor:color andLeftSpace:leftSpace];
        downView.tag = kTagLineView;
        [self addSubview:downView];
    }
}
- (void)removeViewWithTag:(NSInteger)tag{
    for (UIView *aView in [self subviews]) {
        if (aView.tag == tag) {
            [aView removeFromSuperview];
        }
    }
}





- (UIViewController*)viewController{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


- (UIViewController *)requestCurrentVC{
    return [UIView requestCurrentVC];
}
+ (UIViewController *)requestCurrentVC{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabrCtrl = (UITabBarController*)nextResponder;
        if ([tabrCtrl.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navCtrl = tabrCtrl.selectedViewController;
            result = navCtrl.topViewController;
        }else{
            result = tabrCtrl.selectedViewController;
        }
    }else if([nextResponder isKindOfClass:[UINavigationController class]]){
        UINavigationController *navCtrl = (UINavigationController*)nextResponder;
        result = navCtrl.topViewController;
        
    } else {
        if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabrCtrl = (UITabBarController*)window.rootViewController;
            if ([tabrCtrl.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navCtrl = tabrCtrl.selectedViewController;
                result = navCtrl.topViewController;
            }else{
                result = tabrCtrl.selectedViewController;
            }
        }
    }
    return result;
}

@end

@implementation UIView (HUD)

+ (void)showStatus:(NSString *)format, ...{
    
    va_list paramList;
    va_start(paramList,format);
    NSString* log = [[NSString alloc]initWithFormat:format arguments:paramList];
    va_end(paramList);
    
    //弹出提醒添加成功
    MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.labelText =log;
//    hud.label.text = log;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 50, 50)];
    [hud setCustomView:view];
    [hud setMode:MBProgressHUDModeCustomView];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
//    [hud showAnimated:YES];
//    [hud hideAnimated:YES afterDelay:1.0]; //设置1秒钟后自动消失
}


@end
