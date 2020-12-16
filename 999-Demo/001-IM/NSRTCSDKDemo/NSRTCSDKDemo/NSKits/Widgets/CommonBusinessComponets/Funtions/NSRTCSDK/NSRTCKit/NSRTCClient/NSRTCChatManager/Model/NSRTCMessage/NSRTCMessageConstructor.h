//
//  NSRTCMessage+Constructor.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/14.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCMessageConstructor.h"
#import "NSRTCMessage.h"
//消息构造
@interface NSRTCMessageConstructor:NSObject
+ (NSRTCMessage*)textMessage:(NSString *)text withReceiver:(NSString*)toUser;

+ (NSRTCMessage*)imageMessageWithImgData:(NSData *)imgData smallImageData:(NSData *)sImageData withReceiver:(NSString*)toUser;

+ (NSRTCMessage*)audioMessageWithAudioFilePath:(NSString *)audioDataPath duration:(CGFloat)duration withReceiver:(NSString*)toUser;

+ (NSRTCMessage*)locationMessageWithCoordinate2DValue:(CLLocationCoordinate2D)location locationName:(NSString *)locationName detailLocationName:(NSString *)detailLocationName withReceiver:(NSString*)toUser;

@end
 
