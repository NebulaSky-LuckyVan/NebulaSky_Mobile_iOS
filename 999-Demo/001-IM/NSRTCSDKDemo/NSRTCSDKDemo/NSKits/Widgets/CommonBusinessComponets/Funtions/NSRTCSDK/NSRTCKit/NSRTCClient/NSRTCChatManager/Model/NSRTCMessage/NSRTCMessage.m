//
//  NSRTCMessage.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSRTCMessage.h"

 

@implementation NSRTCMessage


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"to" : @"to_user", @"from" : @"from_user"};
}

+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"messageCellHeight"];
}


- (instancetype)initWithToUser:(NSString *)toUser fromUser:(NSString *)fromUser chatType:(NSString *)chatType{
    if (self = [super init]) {
        
        _to = toUser;
        _from = fromUser;
        _chat_type = chatType;
        
    }
    return self;
}
+ (instancetype)startGroupChatFromUser:(NSString *)fromUser withUsers:(NSArray *)users atRoom:(NSString *)roomId{
    NSRTCMessage *message = [[NSRTCMessage alloc]init];
    message.roomMessageOrigin = [fromUser copy];
    message.groupUsers = [users copy];
    message.roomId  = [roomId copy];
    return message;
}


- (void)setBodies:(NSRTCMessageBody *)bodies {
    _bodies = bodies; 
    NSString *type = bodies.type;
    if ([type isEqualToString:@"txt"]) {
        self.type = NSRTCMessageText;
    }
    else if ([type isEqualToString:@"img"]) {
        self.type = NSRTCMessageImage;
        if (bodies.size) {
            
        }
        else {
            bodies.superModel = self;
        }
        
    }
    else if ([type isEqualToString:@"loc"]) {
        self.type = NSRTCMessageLoc;
    }
    else if ([type isEqualToString:@"audio"]) {
        self.type = NSRTCMessageAudio;
    }
    else if ([type isEqualToString:@"video"]) {
        self.type = NSRTCMessageVideo;
    }
    else {
        self.type = NSRTCMessageOther;
    }
    
}

@end
@implementation NSRTCMessageBody

- (void)setSize:(NSDictionary *)sizeDict {
    
    CGFloat width = [[sizeDict objectForKey:@"width"] floatValue];
    CGFloat height = [[sizeDict objectForKey:@"height"]   floatValue];
    CGFloat scale = width/height;
    CGFloat refer = scale>1?width:height;
    CGFloat imageScale;
    if (refer > 300) {
        
        imageScale = refer/300*2.0;
    }
    else {
        imageScale = 1;
    }
    
    _size = @{@"width" : @(width/imageScale), @"height" : @(height/imageScale)};
    if (self.superModel) {
        
        //        [self.superModel setImageCellSize];
    }
}

+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"superModel"];
}

@end
 
