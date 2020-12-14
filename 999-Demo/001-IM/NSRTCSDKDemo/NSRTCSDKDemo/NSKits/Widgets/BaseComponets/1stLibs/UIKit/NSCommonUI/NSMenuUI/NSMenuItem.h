//
//  NSMenuItem.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/9.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface NSMenuItem : NSObject

@property (nullable, nonatomic, strong)UIImage *image;
@property (nullable, nonatomic, strong)NSString *title;

@property (nonatomic, copy) void (^action)(NSMenuItem *item);

- (void)clickMenuItem;
+ (instancetype)itemWithImage:(nullable UIImage *)image
                        title:(nullable NSString *)title
                       action:(void (^)(NSMenuItem *item))action;



@end
 
