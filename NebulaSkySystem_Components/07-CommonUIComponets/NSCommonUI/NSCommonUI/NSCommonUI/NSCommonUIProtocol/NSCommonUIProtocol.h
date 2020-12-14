//
//  NSCommonUIProtocol.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import <UIKit/UIKit.h>
 

@protocol NSCommonUIProtocol <NSObject>
@required
+ (UINib *)nib ;
+ (NSString *)reuseIdentifier ;
@end
 
@protocol NSBaseViewCtrlProtocol <NSObject>
 
@required
- (void)setupUI;
- (void)bindViewModel;
- (void)setupNoticeMonitors; 
@optional





@end


