//
//  NSChatPageController.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSChatPageController : NSViewController

@property (strong, nonatomic) NSString *toUser;
- (instancetype)initWithToUser:(NSString *)toUser;

- (CGRect)getImageRectInWindowAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
