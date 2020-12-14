//
//  NSContanctsHeader.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSTableViewCell.h"
 

typedef NS_ENUM(NSUInteger,ContanctsHeaderMenuBtn) {
    
    ContanctsHeaderMenuBtn_PhoneContacts = 0,
    ContanctsHeaderMenuBtn_CompanyContacts ,
    ContanctsHeaderMenuBtn_OriginazationStuctureContacts  ,
    ContanctsHeaderMenuBtn_ZoneContacts  ,
    ContanctsHeaderMenuBtn_RoleContacts  ,
    ContanctsHeaderMenuBtn_SearchContacts  ,
    ContanctsHeaderMenuBtn_OtherContacts  ,
    
};
@class NSContanctsHeader;
@protocol NSContanctsHeaderMenuHandlerProtocol <NSObject>

- (void)contactsHeader:(NSContanctsHeader*)header click:(ContanctsHeaderMenuBtn)menuBtn;

@end
@interface NSContanctsHeader : NSTableViewCell
//Desc:
@property (weak, nonatomic) id <NSContanctsHeaderMenuHandlerProtocol>delegate;

@end
 
