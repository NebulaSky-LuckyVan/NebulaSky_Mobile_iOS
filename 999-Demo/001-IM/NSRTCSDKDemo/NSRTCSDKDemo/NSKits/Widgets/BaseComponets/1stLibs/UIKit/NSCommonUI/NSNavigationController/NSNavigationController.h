//
//  NSNavigationController.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/19.
//

#import "LRCBaseNavigationController.h"
 
// 注意：不要直接使用这个类作为NavigationController，使用它在页面消失的时候对应的App不会自动退出问题。
// 如果有App维度，直接使用startApp launchMode选择present方式，否则可以使用LRNavigationController。
@interface NSNavigationController : LRCBaseNavigationController

@end
 
