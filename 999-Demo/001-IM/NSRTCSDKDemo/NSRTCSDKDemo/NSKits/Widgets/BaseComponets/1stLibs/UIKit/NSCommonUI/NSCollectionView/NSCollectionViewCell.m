//
//  NSCollectionViewCell.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import "NSCollectionViewCell.h"

@implementation NSCollectionViewCell
+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class])
                          bundle:[NSBundle mainBundle]];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}
@end
