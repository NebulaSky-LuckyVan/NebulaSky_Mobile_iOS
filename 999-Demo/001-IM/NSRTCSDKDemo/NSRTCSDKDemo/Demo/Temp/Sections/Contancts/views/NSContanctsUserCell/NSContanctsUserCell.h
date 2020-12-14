//
//  NSContanctsUserCell.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSTableViewCell.h"
 
@interface NSContanctsUserCell : NSTableViewCell

@property (nonatomic, strong ,readonly) UILabel *nameLabel;

@property (nonatomic, strong ,readonly) UIImageView *iconImage;

@property (nonatomic, assign) BOOL IsEditing;
@property (nonatomic, assign) BOOL IsSelected;

@end
