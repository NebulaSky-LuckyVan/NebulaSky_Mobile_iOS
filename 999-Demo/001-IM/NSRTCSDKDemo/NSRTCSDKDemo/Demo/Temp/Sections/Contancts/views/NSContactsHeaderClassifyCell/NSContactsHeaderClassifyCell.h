//
//  NSContactsHeaderClassifyCell.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSContactsHeaderClassifyCell : NSTableViewCell

@property (nonatomic, strong ,readonly) UILabel *nameLabel;

@property (nonatomic, strong ,readonly) UIImageView *iconImage;
@property (nonatomic, strong ,readonly) UIButton *handlerBtn;
@end

NS_ASSUME_NONNULL_END
