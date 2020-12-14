//
//  NSMessagesCell.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSTableViewCell.h"



@class NSRTCConversation;

@interface NSMessagesCell : NSTableViewCell

@property (nonatomic, strong) NSRTCConversation *model;

- (void)updateUnreadCount;
@end

