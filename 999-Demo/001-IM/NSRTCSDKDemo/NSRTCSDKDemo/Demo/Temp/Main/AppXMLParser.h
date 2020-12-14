//
//  AppXMLParser.h
//  BasePoroject
//
//  Created by Mac on 2018/9/16.
//  Copyright © 2018年 VanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildVcObj.h"
@interface AppXMLParser : NSObject
+(instancetype)shareInstance;
-(NSMutableArray*)parser;
-(NSMutableArray*)parserWithFileName:(NSString*)fileName;
@end
