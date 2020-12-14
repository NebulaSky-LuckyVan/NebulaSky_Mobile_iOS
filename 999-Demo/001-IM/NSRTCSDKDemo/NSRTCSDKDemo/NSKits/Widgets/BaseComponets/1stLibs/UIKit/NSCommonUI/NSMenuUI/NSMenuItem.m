//
//  NSMenuItem.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/9.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSMenuItem.h"

@implementation NSMenuItem

+ (instancetype)itemWithImage:(UIImage *)image
                        title:(NSString *)title
                       action:(void (^)(NSMenuItem *item))action;
{
    return [[NSMenuItem alloc] init:title
                               image:image
                              action:(void (^)(NSMenuItem *item))action];
}
- (instancetype) init:(NSString *) title
                image:(UIImage *) image
               action:(void (^)(NSMenuItem *item))action
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _action = action;
    }
    return self;
}

- (void)clickMenuItem
{
    if (self.action) {
        self.action(self);
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}
@end
