//
//  NSString+AES.h
//  BasePoroject
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018 VanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface NSString (AES)

+ (NSString *)base64StringFromData:(NSData *)data length:(NSUInteger)length;
@end
