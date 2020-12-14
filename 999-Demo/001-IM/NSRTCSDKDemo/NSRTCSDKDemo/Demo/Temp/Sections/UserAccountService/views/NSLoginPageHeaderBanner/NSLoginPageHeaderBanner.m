//
//  NSLoginPageHeaderBanner.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSLoginPageHeaderBanner.h"



@implementation NSLoginPageHeaderBanner

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}
- (void)setup{
    UILabel *titleLb  = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLb.text = @"您好!";
    titleLb.font = [UIFont boldSystemFontOfSize:30];
    titleLb.textColor = [UIColor colorWithHex:0x2A2B30];
    titleLb.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(50));
        make.width.equalTo(@(70));
        make.height.equalTo(@(30));
    }];
    
    UILabel *descLb  = [[UILabel alloc]initWithFrame:CGRectZero];
    descLb.text = @"欢迎加入我们";
    descLb.font = [UIFont systemFontOfSize:15];
    descLb.textColor = [UIColor colorWithHex:0x2A2B30];
    descLb.textAlignment = NSTextAlignmentLeft;
    [self addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLb);
        make.top.equalTo(titleLb.mas_bottom).offset(15);
        make.width.equalTo(@(100));
        make.height.equalTo(@(15));
    }];
    
    
    
    
    
}

@end
