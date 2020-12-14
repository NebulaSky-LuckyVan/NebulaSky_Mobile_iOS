//
//  NSString+Common.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface NSString (Common)

/** 字符串转字典 */
- (NSDictionary *)stringToJsonDictionary;
/** 生成唯一编码 */
+ (NSString *)creatUUIDString;

/** 获取文件保存路径 */
+ (NSString *)getFielSavePath;
/** 获取音频保存路径 */
+ (NSString *)getAudioSavePath;
/** md5编码 */
- (NSString *)md5Str;

- (NSString *)emotionSpecailName;
@end
 
