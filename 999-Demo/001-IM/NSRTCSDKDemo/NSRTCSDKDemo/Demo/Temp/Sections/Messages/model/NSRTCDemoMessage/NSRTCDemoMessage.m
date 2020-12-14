//
//  NSRTCDemoMessage.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/1.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCDemoMessage.h"

#import "NSRTCMessageBubbleView.h"

@implementation NSRTCDemoMessage
- (void)setType:(NSRTCMessageType)type{
    [super setType:type];
    switch (type) {
        case NSRTCMessageText:{
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineBreakMode:NSLineBreakByCharWrapping];
            
            NSDictionary *attributes = @{ NSFontAttributeName : [NSRTCMessageBubbleView appearance].textFont, NSParagraphStyleAttributeName : style };
            CGRect rect = [self.bodies.msg boundingRectWithSize:CGSizeMake(kScreenWidth*3/5.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
            
            rect.size.width = ceil(rect.size.width);
            rect.size.height = ceil(rect.size.height>35?rect.size.height:35);
            _textMessageLabelSize = rect.size;
            
            _messageCellHeight = _textMessageLabelSize.height + 10 + [NSRTCMessageBubbleView appearance].textSendInsets.top + [NSRTCMessageBubbleView appearance].textSendInsets.bottom + 15;
             
            
            NSLog(@"messageCellHeight:%.2f",_messageCellHeight);
        }break;
        case NSRTCMessageImage:{
            if (self.bodies.size) {
                [self setImageCellSize];
            }
        }break;
        case NSRTCMessageLoc:{
            _messageCellHeight = 150 + 10 + 15;
        }break;
        case NSRTCMessageAudio:{
            _messageCellHeight = 60;
        }break;
        case NSRTCMessageVideo:{
            _messageCellHeight = 40;
        }break;
        case NSRTCMessageOther:{
        }break;
            
        default:
            break;
    }
}

- (void)setImageCellSize {
    NSDictionary *size = self.bodies.size;
    CGFloat height = [size[@"height"] floatValue];
    _messageCellHeight = height + 10 + 15;
    
}

@end
