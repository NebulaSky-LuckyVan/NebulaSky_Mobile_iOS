//
//  NSContanctsHeader.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSContanctsHeader.h"
#import "NSContactsHeaderCell.h"
#import "NSContactsHeaderClassifyCell.h"


@interface NSContanctsHeader ()<UISearchBarDelegate>

@property (strong, nonatomic) NSContactsHeaderCell *phoneContacts;
@property (strong, nonatomic) NSContactsHeaderCell *companyContacts;
@property (strong, nonatomic) NSContactsHeaderClassifyCell *orginizationStructureContacts;
@property (strong, nonatomic) NSContactsHeaderClassifyCell *zoneContacts;
@property (strong, nonatomic) NSContactsHeaderClassifyCell *characterContacts;
@property (strong, nonatomic) NSContactsHeaderClassifyCell *otherContacts;


@end

@interface NSContanctsHeader ()


@end

@implementation NSContanctsHeader

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup{
    
    [self setBackgroundColor:[UIColor colorWithHex:0xF5F6F9]];
//    UISearchBar*searchBar = [[UISearchBar alloc]init];
//    searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    searchBar.delegate = self;
//    [self addSubview:searchBar];
//    [self.searchCtrlPage setValue:searchBar forKey:@"searchBar"];
//    self.searchCtrlPage.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    UISearchBar *searchBar = self.searchCtrlPage.searchBar;
//    [searchBar setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
//    [self addSubview:searchBar];
    
//    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self);
//        make.height.equalTo(@(50));
//    }];
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchBtn setImage:[UIImage imageNamed:@"searchBox"] forState:UIControlStateNormal];
    [self.contentView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(50));
    }];
    [searchBtn action:^(UIButton *sendor) { 
        if ([self.delegate respondsToSelector:@selector(contactsHeader:click:)]) {
            [self.delegate contactsHeader:self click:ContanctsHeaderMenuBtn_SearchContacts];
        }
    }];
    
    
    
    NSContactsHeaderCell *phoneContacts = [[NSContactsHeaderCell alloc]init];
//    [phoneContacts setFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.contentView addSubview:phoneContacts];
    [phoneContacts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(searchBtn.mas_bottom);
        make.height.equalTo(searchBtn);
    }];
    [phoneContacts.iconImage setImage:[UIImage imageNamed:@"sjlxr"]];
    phoneContacts.nameLabel.text = @"手机联系人";
    [phoneContacts setBackgroundColor:[UIColor whiteColor]];
    [phoneContacts.handlerBtn action:^(UIButton *sendor) {
        if ([self.delegate respondsToSelector:@selector(contactsHeader:click:)]) {
            [self.delegate contactsHeader:self click:ContanctsHeaderMenuBtn_PhoneContacts];
        }
    }];
    self.phoneContacts = phoneContacts;
    
    
    NSContactsHeaderCell *companyContacts = [[NSContactsHeaderCell alloc]init];
//    [companyContacts setFrame:CGRectMake(0, 50*2+10, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.contentView addSubview:companyContacts];
    [companyContacts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneContacts.mas_bottom).offset(10);
        make.left.right.height.equalTo(phoneContacts);
    }];
    [companyContacts.iconImage setImage:[UIImage imageNamed:@"gs"]];
    companyContacts.nameLabel.text = @"北京易诚互动网络技术有限公司";
    [companyContacts setBackgroundColor:[UIColor whiteColor]];
    [companyContacts.handlerBtn action:^(UIButton *sendor) {
        if ([self.delegate respondsToSelector:@selector(contactsHeader:click:)]) {
            [self.delegate contactsHeader:self click:ContanctsHeaderMenuBtn_CompanyContacts];
        }
    }];
    self.companyContacts = companyContacts;
  
    NSContactsHeaderClassifyCell *orginizationStructureContacts = [[NSContactsHeaderClassifyCell alloc]init];
//    [orginizationStructureContacts setFrame:CGRectMake(0, 50*3+10, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.contentView addSubview:orginizationStructureContacts];
    [orginizationStructureContacts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(companyContacts.mas_bottom);
        make.height.equalTo(@(50));
    }];
    orginizationStructureContacts.nameLabel.text = @"按组织架构选择";
    [orginizationStructureContacts setBackgroundColor:[UIColor whiteColor]];
    [orginizationStructureContacts.handlerBtn action:^(UIButton *sendor) {
        if ([self.delegate respondsToSelector:@selector(contactsHeader:click:)]) {
            [self.delegate contactsHeader:self click:ContanctsHeaderMenuBtn_OriginazationStuctureContacts];
        }
    }];
    self.orginizationStructureContacts = orginizationStructureContacts;
    
    
    NSContactsHeaderClassifyCell *zoneContacts = [[NSContactsHeaderClassifyCell alloc]init];
//    [zoneContacts setFrame:CGRectMake(0, 50*4+10, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.contentView addSubview:zoneContacts];
    [zoneContacts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(orginizationStructureContacts.mas_bottom);
        make.height.equalTo(searchBtn);
    }];
    zoneContacts.nameLabel.text = @"交付五分区-502分部";
    [zoneContacts setBackgroundColor:[UIColor whiteColor]];
    [zoneContacts.handlerBtn action:^(UIButton *sendor) {
        if ([self.delegate respondsToSelector:@selector(contactsHeader:click:)]) {
            [self.delegate contactsHeader:self click:ContanctsHeaderMenuBtn_ZoneContacts];
        }
    }];
    self.zoneContacts = zoneContacts;
    
    NSContactsHeaderClassifyCell *characterContacts = [[NSContactsHeaderClassifyCell alloc]init];
//    [characterContacts setFrame:CGRectMake(0, 50*5+10, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.contentView addSubview:characterContacts];
    [characterContacts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(zoneContacts.mas_bottom);
        make.height.equalTo(searchBtn);
    }];
    characterContacts.nameLabel.text = @"按角色选择";
    [characterContacts setBackgroundColor:[UIColor whiteColor]];
    [characterContacts.handlerBtn action:^(UIButton *sendor) {
        if ([self.delegate respondsToSelector:@selector(contactsHeader:click:)]) {
            [self.delegate contactsHeader:self click:ContanctsHeaderMenuBtn_RoleContacts];
        }
    }];
    
    self.characterContacts = characterContacts;
    
    NSContactsHeaderClassifyCell *otherContacts = [[NSContactsHeaderClassifyCell alloc]init];
//    [otherContacts setFrame:CGRectMake(0, 50*6+10, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.contentView addSubview:otherContacts];
    [otherContacts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(characterContacts.mas_bottom);
        make.height.equalTo(searchBtn);
    }];
    otherContacts.nameLabel.text = @"外部联系人";
    [otherContacts setBackgroundColor:[UIColor whiteColor]];
    [otherContacts.handlerBtn action:^(UIButton *sendor) {
        if ([self.delegate respondsToSelector:@selector(contactsHeader:click:)]) {
            [self.delegate contactsHeader:self click:ContanctsHeaderMenuBtn_OtherContacts];
        }
    }];
    self.otherContacts = otherContacts;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end
