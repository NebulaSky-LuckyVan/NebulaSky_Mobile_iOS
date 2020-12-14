//
//  NSContanctsUserCell.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSContanctsUserCell.h"

@interface NSContanctsUserCell()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *iconImage;


@property (nonatomic, strong) UIImageView *checkBoxImgView;

@end
@implementation NSContanctsUserCell

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
        make.left.equalTo(self).offset(kMargin);
        make.width.height.mas_equalTo(40);
    }];
    //        [_iconImage addCornerWithRadius:20];
    //        _iconImage.backgroundColor = RGBAColor(arc4random()%256, arc4random()%256, arc4random()%256, 1);
    
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self->_iconImage.mas_right).offset(kPadding);
        make.centerY.equalTo(self);
    }];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    
    UIView *cutline = [[UIView alloc]initWithFrame:CGRectZero];
    [cutline setBackgroundColor:[[UIColor colorWithHex:0xE5E5E5] colorWithAlphaComponent:1]];
    [self addSubview:cutline];
    [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right);
        make.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.equalTo(@(0.35));
    }];
    
    
    _checkBoxImgView = [[UIImageView alloc] init];
    [_checkBoxImgView setImage:[UIImage imageNamed:@"checkBox"]];
    [self.contentView addSubview:_checkBoxImgView];
    [_checkBoxImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kMargin);
        make.width.height.mas_equalTo(15);
    }];
    [_checkBoxImgView setHidden:YES];
    
    
    
}
- (void)setIsEditing:(BOOL)IsEditing{
    _IsEditing = IsEditing;
    [_checkBoxImgView setHidden:!IsEditing];
    
}
- (void)setIsSelected:(BOOL)IsSelected{
    _IsSelected = IsSelected;
    [_checkBoxImgView setImage:[UIImage imageNamed:!IsSelected?@"uncheckBox":@"checkBox"]];
}


@end
