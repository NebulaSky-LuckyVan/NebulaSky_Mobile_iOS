//
//  UIImage+Common.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
 

@interface UIImage (Common)

-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
@end
