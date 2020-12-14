//
//  NSLoginPageFooterBanner.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSLoginPageFooterBanner.h"

@interface NSLoginPageFooterBanner()
//Desc:
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *registetBtn;
@end
@implementation NSLoginPageFooterBanner

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}
- (void)setup{
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn setBackgroundImage:[[UIImage imageNamed:@"btnBanner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(290));
        make.height.equalTo(@(50));
        make.centerX.equalTo(self);
        make.top.equalTo(@(50));
    }]; 
    self.loginBtn = loginBtn;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.width.equalTo(@(80));
        make.height.equalTo(@(20));
    }];
    self.registetBtn = registerBtn;
    
    
}
@end
