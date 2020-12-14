//
//  NSContactsHeaderClassifyCell.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSContactsHeaderClassifyCell.h"

@interface NSContactsHeaderClassifyCell ()

@property (nonatomic, strong) UIButton *handlerBtn;
@end
@implementation NSContactsHeaderClassifyCell


- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    _iconImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(35);
        make.width.height.equalTo(@(13));
    }];
    [_iconImage setImage:[UIImage imageNamed:@"path"]];
    //        [_iconImage addCornerWithRadius:20];
    //        _iconImage.backgroundColor = RGBAColor(arc4random()%256, arc4random()%256, arc4random()%256, 1);
    
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self->_iconImage.mas_right).offset(kPadding+5);
        make.centerY.equalTo(self);
    }];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    //        _statusLabel = [[UILabel alloc] init];
    //        [self.contentView addSubview:_statusLabel];
    //        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //            make.right.equalTo(self).offset(-kMargin);
    //            make.centerY.equalTo(self);
    //        }];
    //        _statusLabel.textColor = [UIColor colorWithHex:0x989898];
    //        _statusLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton *handlerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:handlerBtn];
    [handlerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    self.handlerBtn  = handlerBtn;
    UIView *cutline = [[UIView alloc]initWithFrame:CGRectZero];
    [cutline setBackgroundColor:[[UIColor colorWithHex:0xE5E5E5] colorWithAlphaComponent:0.3]];
    [self addSubview:cutline];
    [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(55));
        make.right.equalTo(@(0));
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

@end
