//
//  NSRTCMessage+Constructor.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/14.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCMessageConstructor.h"

@implementation NSRTCMessageConstructor 
+ (NSRTCMessage*)textMessage:(NSString *)text withReceiver:(NSString*)toUser{
    NSRTCMessageBody *messageBody = [[NSRTCMessageBody alloc] init];
    messageBody.type = @"txt";
    messageBody.msg = text;
    NSRTCMessage *message = [[NSRTCMessage alloc] initWithToUser:toUser
                                                            fromUser:[NSRTCChatManager shareManager].user.currentUserID
                                                            chatType:@"chat"];

    message.bodies = messageBody;
    return message;
}
+ (NSRTCMessage*)imageMessageWithImgData:(NSData *)imgData smallImageData:(NSData *)sImageData withReceiver:(NSString*)toUser{
    NSTimeInterval timeStampValue = [NSDate nowTimeStamp];
    NSString *imageName = [NSString stringWithFormat:@"%@%f.jpg",[NSString creatUUIDString],timeStampValue];
    NSRTCMessage *message = [[NSRTCMessage alloc] initWithToUser:toUser fromUser:[NSRTCChatManager shareManager].user.currentUserID chatType:@"chat"];
    NSRTCMessageBody *messageBody = [[NSRTCMessageBody alloc] init];
    messageBody.type = @"img";
    messageBody.fileName = imageName;

    UIImage *image = [UIImage imageWithData:imgData];
    CGSize size = image.size;
    messageBody.size = @{@"width" : @(size.width), @"height" : @(size.height)};
    // 保存图片到本地沙河
    NSString *savePath = [[NSString getFielSavePath] stringByAppendingPathComponent:imageName];
    NSString *sSavePath = [[NSString getFielSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"s_%@", imageName]];
    [self saveFile:imgData toPath:savePath];
    [self saveFile:sImageData toPath:sSavePath];
    message.bodies = messageBody;
    message.bodies.fileData = imgData;
    return message;
}

+ (NSRTCMessage*)audioMessageWithAudioFilePath:(NSString *)audioDataPath duration:(CGFloat)duration withReceiver:(NSString*)toUser{
 
    NSString *audioName = [audioDataPath lastPathComponent];
    NSRTCMessage *message = [[NSRTCMessage alloc] initWithToUser:toUser fromUser:[NSRTCChatManager shareManager].user.currentUserID chatType:@"chat"];
    NSRTCMessageBody *messageBody = [[NSRTCMessageBody alloc] init];
    messageBody.type = @"audio";
    messageBody.fileName = audioName;
    messageBody.duration = duration * 2;
    NSData *audioData = [NSData dataWithContentsOfFile:audioDataPath];
    message.bodies = messageBody;
    message.bodies.fileData = audioData;
    return message;
}
+ (NSRTCMessage*)locationMessageWithCoordinate2DValue:(CLLocationCoordinate2D)location locationName:(NSString *)locationName detailLocationName:(NSString *)detailLocationName withReceiver:(NSString*)toUser{
    NSRTCMessage *message = [[NSRTCMessage alloc] initWithToUser:toUser fromUser:[NSRTCChatManager shareManager].user.currentUserID chatType:@"chat"];
    NSRTCMessageBody *messageBody = [[NSRTCMessageBody alloc] init];
    messageBody.type = @"loc";
    messageBody.latitude = location.latitude;
    messageBody.longitude = location.longitude;
    messageBody.locationName = locationName;
    messageBody.detailLocationName = detailLocationName;
    message.bodies = messageBody;
    return message;
}
 

+ (BOOL)saveFile:(NSData *)fileData toPath:(NSString *)savePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL saveSuccess = [fileManager createFileAtPath:savePath contents:fileData attributes:nil];
    if (saveSuccess) {
        NSLog(@"文件保存成功");
    }
    return saveSuccess;
}




@end
