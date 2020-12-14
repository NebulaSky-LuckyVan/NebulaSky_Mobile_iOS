//
//  NSAppPropertylistParser.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSAppPropertylistParser.h"


@interface NSAppPropertylistParser ()
//Desc:
@property (strong, nonatomic) NSMutableArray *childVcs;
@end
@implementation NSAppPropertylistParser

static id _instance;
+(instancetype)shareInstance{
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
-(instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}
-(id)copy{
    return _instance;
}


-(NSMutableArray*)parser;{
    NSString *configFilePath = [[NSBundle mainBundle]pathForResource:@"NSProj.config" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    NSArray *childVcs = [NSArray yy_modelArrayWithClass:[ChildVcObj class] json:dict[@"ChildVcs"]];
    
    
    _childVcs = [childVcs mutableCopy];
    
    return _childVcs;
}

-(NSMutableArray *)parserWithFileName:(NSString *)fileName{
    NSString *configFilePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    NSArray *childVcs = dict[@"ChildVcs"];
    _childVcs = [childVcs mutableCopy];
    
    return _childVcs;
}

@end
