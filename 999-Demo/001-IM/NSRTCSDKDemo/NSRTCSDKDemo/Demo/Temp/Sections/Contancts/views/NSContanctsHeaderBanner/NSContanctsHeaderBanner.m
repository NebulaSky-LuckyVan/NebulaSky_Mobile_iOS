//
//  NSContanctsHeaderBanner.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSContanctsHeaderBanner.h"
@interface NSContanctsHeaderBanner ()
//Desc:
@property (strong, nonatomic) UILabel *titleLb;
@end
@implementation NSContanctsHeaderBanner
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLb  = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLb.text = @"常用联系人";
        titleLb.font = [UIFont boldSystemFontOfSize:17];
        titleLb.textColor = [UIColor blackColor];
        titleLb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.centerY.equalTo(self);
            make.width.equalTo(@(100));
            make.height.equalTo(@(25));
        }];
        self.titleLb = titleLb;
    }
    return self;
}


@end
