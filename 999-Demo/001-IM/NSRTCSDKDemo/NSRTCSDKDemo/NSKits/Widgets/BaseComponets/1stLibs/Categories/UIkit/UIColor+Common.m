//
//  UIColor+Common.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue {
    
    return [self colorWithHex:hexValue alpha:1.0];
}

@end
