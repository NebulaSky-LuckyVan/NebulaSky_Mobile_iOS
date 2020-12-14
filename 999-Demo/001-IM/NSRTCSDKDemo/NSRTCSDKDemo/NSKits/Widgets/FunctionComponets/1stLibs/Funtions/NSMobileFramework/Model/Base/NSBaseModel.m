//
//  NSBaseModel.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSBaseModel.h"

#import <objc/runtime.h>
#import <objc/message.h>
@implementation NSBaseModel
//归档
-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount;
    Ivar *ivars =  class_copyIvarList([self class], &outCount);
    for (int i  = 0; i<outCount; i++) {
        Ivar var = ivars[i];
        const char *proName =  ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:proName];
        id value = [self valueForKey:key];
        if (value) {
            [aCoder encodeObject:value forKey:key];
        }
    }
}
//解归档
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        unsigned int outCount;
        Ivar *ivars =  class_copyIvarList([self class], &outCount);
        for (int i  = 0; i<outCount; i++) {
            Ivar var = ivars[i];
            const char *proName =  ivar_getName(var);
            NSString *key = [NSString stringWithUTF8String:proName];
            id value = [aDecoder decodeObjectForKey:key];
            if (value) {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
