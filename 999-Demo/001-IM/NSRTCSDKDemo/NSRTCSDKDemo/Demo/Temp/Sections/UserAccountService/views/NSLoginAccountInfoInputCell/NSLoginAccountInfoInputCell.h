//
//  NSLoginAccountInfoInputCell.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLoginAccountInfoInputCell : UITableViewCell
@property (strong, nonatomic ,readonly) UITextField *accountTextFields;
@property (strong, nonatomic ,readonly) UITextField *pwdTextFields;
@end

NS_ASSUME_NONNULL_END
