//
//  UIView+NSCommonUI.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface UIView (NSCommonUI)

@end
@interface UIView (NSNib)
+ (instancetype)loadingXib;
+ (UINib *)loadingNib:(Class)aClass;
+ (UINib*)loadingNib;
+ (NSString*)reuseId;
+ (NSString*)headerReuseId;
+ (NSString*)footerReuseId;
@end

@interface UIView (NSRadiusCorner)

- (void)addCornerWithRadius:(CGFloat)radius ;
- (void)addCornerWithRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor*)color;


@end


