//
//  NSRTCChatListCell.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCChatListCell.h"
#import "NSRTCChatBadgeLabel.h"
//#import <NSRTC/NSRTCConversation.h>

#import "NSRTCConversation.h"

#import <Masonry/Masonry.h>

#define kPadding 10.0f
#define kMargin 15.0f
@interface NSRTCChatListCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *lastMessageLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSRTCChatBadgeLabel *unReadMsgCountLabel;

@end

@implementation NSRTCChatListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    
    _lastMessageLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_lastMessageLabel];
    _lastMessageLabel.font = [UIFont systemFontOfSize:14];
    _lastMessageLabel.textColor = [UIColor colorWithHex:0x989898];
    
    _timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor colorWithHex:0xdfdfdf];
    
    
    _unReadMsgCountLabel = [[NSRTCChatBadgeLabel alloc] init];
    [self.contentView addSubview:_unReadMsgCountLabel];
    [_unReadMsgCountLabel setPersistentBackgroundColor:[UIColor redColor]];
    _unReadMsgCountLabel.textColor = [UIColor whiteColor];
    _unReadMsgCountLabel.font = [UIFont systemFontOfSize:13];
    _unReadMsgCountLabel.layer.cornerRadius = 7;
    _unReadMsgCountLabel.layer.masksToBounds = YES;
    _unReadMsgCountLabel.textAlignment = NSTextAlignmentCenter;
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kMargin);
        make.width.height.mas_equalTo(50);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self->_iconImageView);
        make.right.equalTo(self).offset(-kPadding);
        make.left.equalTo(self->_iconImageView.mas_right).offset(kPadding);
    }];
    
    [_lastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self->_nameLabel);
        make.bottom.equalTo(self->_iconImageView);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-kMargin);
        make.centerY.equalTo(self->_nameLabel);
    }];
    
    [_unReadMsgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self->_iconImageView.mas_right);
        make.centerY.equalTo(self->_iconImageView.mas_top);
        make.height.mas_equalTo(15);
    }];
    
    
}

- (void)setModel:(NSRTCConversation *)model {
    
    _model = model;
    _iconImageView.image = [UIImage imageNamed:model.imageStr];
    _nameLabel.text = model.userName;
    _timeLabel.text = [NSDate stringTimesWithTimeStamp:model.latestMsgTimeStamp];
    _lastMessageLabel.text = model.latestMsgStr;
    
    [self updateUnreadCount];
}


- (void)updateUnreadCount {
    NSRTCConversation *model = self.model;
    _unReadMsgCountLabel.hidden = model.unReadCount <= 0;
    if (model.unReadCount) {
        _unReadMsgCountLabel.text = model.unReadCount > 99 ? @"99+" : [NSString stringWithFormat:@"%ld", model.unReadCount];
        CGFloat width = model.unReadCount > 9 ? (model.unReadCount > 99 ? 30 : 22) : 15;
        [_unReadMsgCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(width);
        }];
    }
}
@end
