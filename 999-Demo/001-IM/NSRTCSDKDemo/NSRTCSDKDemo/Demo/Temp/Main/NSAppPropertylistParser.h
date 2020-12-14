//
//  NSAppPropertylistParser.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildVcObj.h"

@interface NSAppPropertylistParser : NSObject

+(instancetype)shareInstance;
-(NSMutableArray*)parser;
-(NSMutableArray*)parserWithFileName:(NSString*)fileName;
@end

