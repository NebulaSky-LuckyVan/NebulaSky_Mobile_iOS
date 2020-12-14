//
//  NSMenuView.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/9.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMenuOperation.h"
 

@interface NSMenuView : UIView

- (void)dismissMenu:(BOOL)animated;
- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
                  menu:(NSMenuOperation *)menu
             menuItems:(NSArray *)menuItems;
@end
 
