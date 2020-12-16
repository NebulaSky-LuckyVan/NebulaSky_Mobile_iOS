//
//  NSRTCGroupChatViewModel.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/9.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCGroupChatViewModel.h"

@implementation NSRTCGroupChatViewModel
/**
 发送文本消息
 
 @param text 文本
 */
- (void)groupChatSendTextMessageWithText:(NSString *)text{
    NSLog(@"%s",__func__);
}

/**
 发送语音
 
 @param audioSavePath 语音保存路径
 @param duration 语音持续时长
 */
- (void)groupChatSendAudioMessageWithAudioSavePath:(NSString *)audioSavePath duration:(CGFloat)duration{
    NSLog(@"%s",__func__);
}
 
/**
 发送图片消息
 
 @param imgData 图片文件
 */
- (void)groupChatSendImageMessageWithImgData:(NSData *)imgData image:(UIImage *)image size:(NSDictionary *)size{
    NSLog(@"%s",__func__);
}


/**
 发送定位
 
 @param location 地位坐标
 @param locationName 定位名字
 */
- (void)groupChatSendLocationMessageWithLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName detailLocationName:(NSString *)detailLocationName{
    NSLog(@"%s",__func__);
}
@end
