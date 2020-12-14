//
//  NSObject+Common.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
 
typedef void(^CallAlertButonClickBlock)(NSInteger buttonIndex);

@interface NSObject (Common)
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles andAction:(CallAlertButonClickBlock)block andParentView:(UIView *)view;

@end
 
 
typedef void (^ExcuteHandlerBlock)(id weakSelf);
@interface NSObject (PerformBlock)

- (void)perform:(ExcuteHandlerBlock)handler after:(NSTimeInterval)delay;

- (void)perform:(ExcuteHandlerBlock)handler onThread:(NSThread*)thread after:(NSTimeInterval)delay;

- (void)perform:(ExcuteHandlerBlock)handler onMainThreadAfter:(NSTimeInterval)delay;

- (void)perform:(ExcuteHandlerBlock)handler onBackgroundAfter:(NSTimeInterval)delay;

@end
 
@interface NSObject (Properties)
+(void)creatPropertyCodeWithDict:(NSDictionary*)dict;

@end
