//
//  NSTableViewCell.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import "NSTableViewCell.h"

@implementation NSTableViewCell
+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class])
                          bundle:[NSBundle mainBundle]];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
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
