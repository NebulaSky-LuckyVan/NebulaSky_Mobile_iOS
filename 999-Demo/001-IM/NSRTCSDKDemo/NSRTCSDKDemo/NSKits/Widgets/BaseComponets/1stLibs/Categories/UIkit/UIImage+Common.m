//
//  UIImage+Common.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "UIImage+Common.h"
#import <objc/runtime.h>

@implementation UIImage (Common)
+ (void)load{
    [self swizzled];
}
+ (void)swizzled{
    SEL loadImgSel = @selector(loadigImage:);
    Method loadImgSelMethod =  class_getClassMethod(self, loadImgSel);
    SEL loadImgSystemSel = @selector(imageNamed:);
    Method loadImgSystemSelMethod =  class_getClassMethod(self, loadImgSystemSel);
    method_exchangeImplementations(loadImgSelMethod, loadImgSystemSelMethod);
}
+ (UIImage*)loadigImage:(NSString*)imageName{
    UIImage*image = [self loadigImage:imageName];
    if (!image) {
        NSString *bundlePath = [[NSBundle bundleWithPath:[[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"NSRTCAssets.bundle/Contents/Resources"]] bundlePath];
        NSString *assetsPath = [bundlePath stringByAppendingPathComponent:imageName];
        NSString *assetsPath3x = [assetsPath stringByAppendingString:@"@3x"];
        NSString *assetsPath2x = [assetsPath stringByAppendingString:@"@2x"];
        image = [UIImage imageWithContentsOfFile:assetsPath3x];
        if (!image) {
            image = [UIImage imageWithContentsOfFile:assetsPath2x];
            if (!image) {
                image = [UIImage imageWithContentsOfFile:assetsPath];
            }
        }
    }
    return image;
}



//==================//

-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality{
    if (highQuality) {
        targetSize = CGSizeMake(2*targetSize.width, 2*targetSize.height);
    }
    return [self scaledToSize:targetSize];
}

-(UIImage*)scaledToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat scaleFactor = 0.0;
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
    }
    scaleFactor = MIN(scaleFactor, 1.0);
    CGFloat targetWidth = imageSize.width* scaleFactor;
    CGFloat targetHeight = imageSize.height* scaleFactor;
    
    targetSize = CGSizeMake(floorf(targetWidth), floorf(targetHeight));
    UIGraphicsBeginImageContext(targetSize); // this will crop
    [sourceImage drawInRect:CGRectMake(0, 0, ceilf(targetWidth), ceilf(targetHeight))];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"could not scale image");
        newImage = sourceImage;
    }
    UIGraphicsEndImageContext();
    return newImage;
}
    

//==================//

@end
