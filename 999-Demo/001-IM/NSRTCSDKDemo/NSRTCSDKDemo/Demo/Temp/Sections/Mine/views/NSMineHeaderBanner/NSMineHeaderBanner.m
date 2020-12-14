//
//  NSMineHeaderBanner.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSMineHeaderBanner.h"

@interface NSMineHeaderBanner ()

@property (nonatomic,strong) UIButton*userIconBtn;
@property (nonatomic,strong) UIButton *seeDetailBtn;

@property (nonatomic,strong) UILabel*userNameLb;
@property (nonatomic,strong) UILabel*identifyLb;



@property (nonatomic,strong) UILabel*totalPropertyLb;
@property (nonatomic,strong) UILabel*yesterdayAddLb;


@end
@implementation NSMineHeaderBanner

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    CGFloat height = 180.0/375*[UIScreen mainScreen].bounds.size.width;
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mine_header_cover"]]];
    [headerView setImage:[UIImage imageNamed:@"mine_header_cover"]];
    [self addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(0));
        make.width.equalTo(self);
        make.height.equalTo(@(height));
    }];
    UIImage *centorInfoContainerBgImg  = [UIImage imageNamed:@"bg_mine_banner"];
    // 左端盖宽度
//    NSInteger leftCapWidth = centorInfoContainerBgImg.size.width * 0.5f;
//    // 顶端盖高度
//    NSInteger topCapHeight = centorInfoContainerBgImg.size.height * 0.5f;
//    // 重新赋值
//    centorInfoContainerBgImg = [centorInfoContainerBgImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    

    UIImageView *centorInfoContainer = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width*343.0/375, 117.9/343*(self.width*343.0/375))];
    [self addSubview:centorInfoContainer];
    [centorInfoContainer setUserInteractionEnabled:YES];
    [centorInfoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.right.equalTo(@(-15));
        make.bottom.equalTo(headerView).offset(30);
        make.height.equalTo(@(120.0/343*[UIScreen mainScreen].bounds.size.width));
    }];
    [centorInfoContainer setImage:centorInfoContainerBgImg];
    self.userIconBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.userIconBtn setBackgroundImage:[UIImage imageNamed:@"tx"] forState:UIControlStateNormal];
    
    [self.userIconBtn setCornerRadius:65.0/2];
    [centorInfoContainer addSubview:self.userIconBtn];
    
    [self.userIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(65));
        make.left.equalTo(@(15));
        make.top.equalTo(@(25));
    }];
    self.userNameLb = [[UILabel alloc]init];
    self.userNameLb.text = @"昵称";
    self.userNameLb.font = [UIFont boldSystemFontOfSize:18];
    [centorInfoContainer addSubview:self.userNameLb];
    [self.userNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIconBtn);
        make.left.equalTo(self.userIconBtn.mas_right).offset(25);
        make.width.equalTo(@(150));
        make.height.equalTo(@(25));
    }];
    
    self.identifyLb = [[UILabel alloc]init];
    self.identifyLb.text = @"ID:12345678";
    self.identifyLb.textColor = [UIColor colorWithHex:0x999999];
    self.identifyLb.font = [UIFont systemFontOfSize:12];
    self.identifyLb.numberOfLines = 0;
    self.identifyLb.lineBreakMode = NSLineBreakByWordWrapping;
    [centorInfoContainer addSubview:self.identifyLb];
    [self.identifyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLb.mas_bottom).offset(5);
        make.left.equalTo(self.userNameLb);
        make.width.equalTo(@(150));
        make.height.equalTo(@(15));
    }];
    
    UIImage *arrowImg =  [UIImage imageNamed:@"rightArrow"];
    UIImageView *accImgView2 = [[UIImageView alloc] initWithImage:arrowImg];
    [centorInfoContainer addSubview:accImgView2];
    [accImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(arrowImg.size.width));
        make.height.equalTo(@(arrowImg.size.height));
        make.centerY.equalTo(self.identifyLb);
        make.right.equalTo(@(-35));
    }];
    
    UIButton *seeDetailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [centorInfoContainer addSubview:seeDetailBtn];
    [seeDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(centorInfoContainer);
        make.left.equalTo(self.identifyLb.mas_left);
    }];
    self.seeDetailBtn = seeDetailBtn;
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
