//
//  NSLoginAccountInfoInputCell.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSLoginAccountInfoInputCell.h"
@interface NSLoginAccountInfoInputCell ()
@property (strong, nonatomic) UITextField *accountTextFields;
@property (strong, nonatomic) UITextField *pwdTextFields;
@end
@implementation NSLoginAccountInfoInputCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI{
    //1.
    //AccountLogo
    UIImageView *accountLogoImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    UIImage *accountLogo  = [UIImage imageNamed:@"icon_zhdl"];
    [accountLogoImgView setImage:accountLogo];
    [self.contentView addSubview:accountLogoImgView];
    [accountLogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(15));
        make.width.equalTo(@(accountLogo.size.width/2));
        make.height.equalTo(@(accountLogo.size.height/2));
    }];
    
    //AccountInput
    UITextField *accountTextFields = [[UITextField alloc]initWithFrame:CGRectZero];
    accountTextFields.placeholder = @"请输入账号";
    accountTextFields.font = [UIFont systemFontOfSize:15];
    accountTextFields.textColor = [UIColor orangeColor];
    [self.contentView addSubview:accountTextFields];
    [accountTextFields mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLogoImgView.mas_right).offset(20);
        make.centerY.equalTo(accountLogoImgView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@(50));
    }];
    self.accountTextFields = accountTextFields;
    
    UIView *cutline1 = [[UIView alloc]initWithFrame:CGRectZero];
    [cutline1 setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
    [self.contentView addSubview:cutline1];
    [cutline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountTextFields);
        make.right.equalTo(accountTextFields);
        make.top.equalTo(accountTextFields.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    //2.PasswordLogo
    UIImageView *passwordImgLogoView = [[UIImageView alloc]initWithFrame:CGRectZero];
    UIImage *passwordLogo  = [UIImage imageNamed:@"icon_dlmm"];
    [passwordImgLogoView setImage:passwordLogo];
    [self.contentView addSubview:passwordImgLogoView];
    [passwordImgLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(cutline1.mas_bottom).offset(25);
        make.width.equalTo(@(passwordLogo.size.width/2));
        make.height.equalTo(@(passwordLogo.size.height/2));
    }];
    //2.PasswordInput
    UITextField *pwdTextFields = [[UITextField alloc]initWithFrame:CGRectZero];
    pwdTextFields.placeholder = @"请输入密码";
    pwdTextFields.font = [UIFont systemFontOfSize:15];
    pwdTextFields.textColor = [UIColor orangeColor];
    pwdTextFields.secureTextEntry = YES;
    [self.contentView addSubview:pwdTextFields];
    [pwdTextFields mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordImgLogoView.mas_right).offset(20);
        make.centerY.equalTo(passwordImgLogoView);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@(50));
    }];
    UIView *cutline2 = [[UIView alloc]initWithFrame:CGRectZero];
    [cutline2 setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
    [self.contentView addSubview:cutline2];
    [cutline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pwdTextFields);
        make.right.equalTo(pwdTextFields);
        make.top.equalTo(pwdTextFields.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    self.pwdTextFields = pwdTextFields;
}

@end
