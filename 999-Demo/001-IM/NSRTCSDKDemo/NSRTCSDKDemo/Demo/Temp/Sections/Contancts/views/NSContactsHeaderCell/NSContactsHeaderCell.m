//
//  NSPhoneContactsCell.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSContactsHeaderCell.h"

@interface NSContactsHeaderCell ()
//Desc:
@property (strong, nonatomic) UIButton *handlerBtn;

@end
@implementation NSContactsHeaderCell
- (instancetype)init{
    self = [super init];
    if (self) {
        
        UIButton *handlerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview:handlerBtn];
        [handlerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        self.handlerBtn  = handlerBtn;
        UIView *cutline = [[UIView alloc]initWithFrame:CGRectZero];
        [cutline setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
        [self addSubview:cutline];
        [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(55));
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@(0.5));
        }];
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

@end
