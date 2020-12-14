//
//  NSData+Common.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSData+Common.h"

@implementation NSData (Common) 
- (BOOL)saveToLocalPath:(NSString *)locPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL saveSuccess = [fileManager createFileAtPath:locPath contents:self attributes:nil];
    if (saveSuccess) {
        NSLog(@"文件保存成功");
    }
    return saveSuccess;
}
@end
