//
//  NSRTCFriendsListCell.h
//  ChatDemo
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NSRTCFriendModel;
@interface NSRTCFriendsListCell : UITableViewCell



@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) NSRTCFriendModel *model;

@end

