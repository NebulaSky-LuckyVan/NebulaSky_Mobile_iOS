//
//  UIColor+Common.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface UIColor (Common)
+ (UIColor *)colorWithHex:(int)hexValue;

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;

@end
 
