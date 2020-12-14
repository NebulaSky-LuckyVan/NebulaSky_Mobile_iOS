//
//  NSMineCell.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSMineCell.h" 

@interface NSMineCell ()
@property (strong, nonatomic) UIImageView *iconImgView;
@property (strong, nonatomic) UILabel *titleLb;

@end
@implementation NSMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup{
    
    
    _iconImgView = [[UIImageView alloc]init];
    _iconImgView.centerY = self.centerY;
    _iconImgView.left = 20;
    [self addSubview:_iconImgView];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.width.height.equalTo(@(20));
        make.centerY.equalTo(self);
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.font = [UIFont systemFontOfSize:15];
    _titleLb.centerY = self.centerY;
    _titleLb.left = 50;
    _titleLb.height = 25;
    _titleLb.textColor = [UIColor colorFromHexString:@"#2A2B30"];
    [self addSubview:_titleLb]; 
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImgView);
        make.left.equalTo(self.iconImgView.mas_right).offset(5);
    }];
    
    UIView *cutLine = [[UIView alloc]init];
    [cutLine setBackgroundColor:[UIColor colorFromHexString:@"#DFDFDF"]];
    [self addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(self);
        make.left.equalTo(@(10));
    }];
}
@end
