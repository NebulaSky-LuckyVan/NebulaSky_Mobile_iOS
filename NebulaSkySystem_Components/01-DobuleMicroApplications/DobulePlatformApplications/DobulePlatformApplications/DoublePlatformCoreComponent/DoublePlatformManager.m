//
//  DoublePlatformManager.m
//  DobulePlatformApplications
//
//  Created by VanZhang on 2020/11/18.
//

#import "DoublePlatformManager.h"
#import "DoublePlatformAppsRootController.h"
@interface DoublePlatformManager ()
//Desc:
@property (strong, nonatomic) DoublePlatformAppsRootController *AppDelegate;
@end


@implementation DoublePlatformManager
























-(UIViewController *)rootViewController{
    return self.AppDelegate;
}
-(DoublePlatformAppsRootController *)AppDelegate{
    if (!_AppDelegate) {
        _AppDelegate = [[DoublePlatformAppsRootController alloc]init];
    }
    return _AppDelegate;
}
//===============SingleTon====================//
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopy{
    return _instance;
}
- (id)copy{
    return _instance;
}
+ (instancetype)sharedInstance{
    return [[self alloc]init];
}
//===================================//
@end
