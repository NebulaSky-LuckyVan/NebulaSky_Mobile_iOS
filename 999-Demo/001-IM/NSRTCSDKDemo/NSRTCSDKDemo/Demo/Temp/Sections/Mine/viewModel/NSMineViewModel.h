//
//  NSMineViewModel.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//
 
#import "NSItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSMineViewModel : NSItemViewModel

- (void)logout;

- (void)settingPage;

- (void)messagePage;

- (void)changeUserIcon;

- (void)userDetailPage;

- (void)connect;

- (void)disconnect;

- (void)aboutUsPage;

- (void)helpCenterPage;

- (void)safetyCenterPage;

@end

NS_ASSUME_NONNULL_END
