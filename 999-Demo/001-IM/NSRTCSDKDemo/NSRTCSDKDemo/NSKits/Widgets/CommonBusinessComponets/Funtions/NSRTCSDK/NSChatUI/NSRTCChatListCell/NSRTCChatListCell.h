//
//  NSRTCChatListCell.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSRTCConversation;
@interface NSRTCChatListCell : UITableViewCell

@property (nonatomic, strong) NSRTCConversation *model;

- (void)updateUnreadCount;

@end

