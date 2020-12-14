//
//  UIView+Common.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
 

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height 

@interface UIView (Common)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;


- (void)doCircleFrame;
- (void)setCornerRadius:(CGFloat)radius;
- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color;
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;

+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace;
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color;
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace;
- (void)removeViewWithTag:(NSInteger)tag;


- (UIViewController*)viewController;

- (UIViewController *)requestCurrentVC;

+ (UIViewController *)requestCurrentVC;
@end
 
@interface UIView (HUD)

+ (void)showStatus:(NSString *)format, ...;

@end
