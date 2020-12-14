//
//  NSMineHeaderBanner.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMineHeaderBanner : NSTableViewCell
@property (nonatomic,strong,readonly) UIButton *userIconBtn;
@property (nonatomic,strong,readonly) UIButton *seeDetailBtn;
@property (nonatomic,strong,readonly) UILabel*userNameLb;
@property (nonatomic,strong,readonly) UILabel*identifyLb;
@end

NS_ASSUME_NONNULL_END
