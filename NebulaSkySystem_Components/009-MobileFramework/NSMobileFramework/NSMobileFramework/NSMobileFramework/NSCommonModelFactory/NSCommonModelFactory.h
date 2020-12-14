//
//  NSCommonModelFactory.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDelegate.h"
#import "NSDataSource.h" 

@interface NSCommonModelFactory : NSObject

+ (NSDelegate*)delegate;

+ (NSDataSource*)datasource;

@end
 


