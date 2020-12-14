//
//  NSSystemContext.m
//  DobulePlatformApplications
//
//  Created by VanZhang on 2020/11/18.
//

#import "NSSystemContext.h"

@implementation NSSystemContext
- (NSString*)MobileRuntimeConfigPath{
    return [[NSBundle mainBundle]pathForResource:@"NSMobileRuntime" ofType:@"plist"];
}
-(NSDictionary*)mobileRuntimeConfiurationP{
    NSString *MobileRuntimeConfigPath = self.MobileRuntimeConfigPath;
    NSDictionary *Configuration = [NSDictionary dictionaryWithContentsOfFile:MobileRuntimeConfigPath];
    return  Configuration;
}
-(NSArray*)Applications{
    NSArray *Applications = [self.mobileRuntimeConfiurationP[@"Applications"] copy];
    return  Applications;
}
/**
 * 根据指定的名称判断是否可以启动一个应用。
 *
 * @param name 要启动的应用名。
 * @param params 应动应用时，需要转递给另一个应用的参数。
 *
 * @return 可以启动返回YES，否则返回NO。
 */
- (BOOL)canHandleStartApplication:(NSString *)name params:(NSDictionary *)params{
    if(name.length == NSNotFound) {NSLog(@"Checking Alert:'Application's name is empty!!!'"); return NO;}
    BOOL Enable = NO;
    NSArray *Applications = [self.Applications copy];
    for (NSDictionary *MicroAppDesc in Applications) {
        NSString *name = MicroAppDesc[@"name"];
        if ([name isEqualToString:name]) {  Enable = YES;  break; }
    }
    return Enable; 
}



/**
 * 根据指定的名称启动一个应用。
 *
 * @param name 要启动的应用名。
 * @param params 应动应用时，需要转递给另一个应用的参数。
 * @param animated 指定启动应用时，是否显示动画。
 *
 * @return 应用启动成功返回YES，否则返回NO。
 */
- (BOOL)startApplication:(NSString *)name params:(NSDictionary *)params animated:(BOOL)animated{
    return [self startApplication:name params:params appClearTop:YES launchMode:kNSMicroApplicationLaunchMode_PushWithAnimation sourceId:nil sceneParams:nil];
    
}

/**
 * 根据指定的名称启动一个应用。
 *
 * @param name 要启动的应用名。
 * @param params 应动应用时，需要转递给另一个应用的参数。
 * @param launchMode 指定 app 启动的方式。
 *
 * @return 应用启动成功返回YES，否则返回NO。
 */
- (BOOL)startApplication:(NSString *)name params:(NSDictionary *)params
              launchMode:(NSMicroApplicationLaunchMode)launchMode{
    return [self startApplication:name params:params appClearTop:YES launchMode:launchMode sourceId:nil sceneParams:nil];
    
}

///**
// * 同步启动登录应用。
// *
// * @param name 要启动的应用名。
// * @param params 应动应用时，需要转递给另一个应用的参数。
// * @param launchMode 指定 app 启动的方式。
// *
// * @return 应用启动成功返回YES，否则返回NO。
// */
//- (BOOL)startLogonApplicationForSync:(NSString *)name params:(NSDictionary *)params launchMode:(NSMicroApplicationLaunchMode)launchMode;

/**
 * 根据指定的名称启动一个应用。
 *
 * @param name 要启动的应用名。
 * @param params 应动应用时，需要转递给另一个应用的参数。
 * @param launchMode 指定 app 启动的方式。
 * @param sourceId 启动 app 的调用者。
 *
 * @return 应用启动成功返回YES，否则返回NO。
 */
- (BOOL)startApplication:(NSString *)name params:(NSDictionary *)params  launchMode:(NSMicroApplicationLaunchMode)launchMode sourceId:(NSString *)sourceId{
    
    
    return [self startApplication:name params:params appClearTop:YES launchMode:launchMode sourceId:sourceId sceneParams:nil];
    
}

 
- (BOOL)startApplication:(NSString *)name  params:(NSDictionary *)params appClearTop:(BOOL)appClearTop launchMode:(NSMicroApplicationLaunchMode)launchMode   sourceId:(NSString *)sourceId{
   
    
    return [self startApplication:name params:params appClearTop:appClearTop launchMode:launchMode sourceId:sourceId sceneParams:nil];
    
}

/**
 * 根据指定的名称启动一个应用。
 *
 * @param name 要启动的应用名。
 * @param params 应动应用时，需要转递给另一个应用的参数。
 * @param launchMode 指定 app 启动的方式。
 * @param appClearTop NO：需要退出已有的，再重新启动一个应用；默认是YES，原来逻辑。
 * @param sourceId 启动 app 的调用者。
 * @param sceneParams app 的场景参数,可用于传递安全管控类参数
 *
 * @return 应用启动成功返回YES，否则返回NO。
 */
- (BOOL)startApplication:(NSString *)name params:(NSDictionary *)params appClearTop:(BOOL)appClearTop   launchMode:(NSMicroApplicationLaunchMode)launchMode sourceId:(NSString *)sourceId sceneParams:(NSDictionary *)sceneParams{
    BOOL IsSuccess = NO;
//    kNSMicroApplicationLaunchMode_PushWithAnimation,     // 有动画的Push方式展示。
//    kNSMicroApplicationLaunchMode_PushNoAnimation,       // 无动画的Push方式展示。
//    kNSMicroApplicationLaunchMode_PresentWithAnimation,  // 有动画的Present方式展示。
//    kNSMicroApplicationLaunchMode_PresentNoAnimation,    // 无动画的Present方式展示。
//    kNSMicroApplicationLaunchMode_FlipFromLeft,          // 左侧弹出的Push方式展示。
//    kNSMicroApplicationLaunchMode_FlipFromRight
    
    //构件单应用实例、由系统的根控制器管理_
    
    if (appClearTop) {//切换系统根控制器上的RootController即可
         
    }else{// 导航切换
        switch (launchMode) {
            case kNSMicroApplicationLaunchMode_ClearTop:{
                
            }break;
            case kNSMicroApplicationLaunchMode_PushWithAnimation:{
                
            }break;
            case kNSMicroApplicationLaunchMode_PushNoAnimation:{
                
            }break;
            case kNSMicroApplicationLaunchMode_PresentWithAnimation:{
                
            }break;
            case kNSMicroApplicationLaunchMode_FlipFromLeft:{
                
            }break;
            case kNSMicroApplicationLaunchMode_FlipFromRight:{
                
            }break;
                
            default:
                break;
        }
    }
    
    
    
    return IsSuccess;
    
}

///**
// * 根据指定的名称同步启动一个应用。
// * 启动时，如果在栈中会清除掉上面的所有app。
// * 同时如果当前有app正在退出，则会走异步启动的逻辑。
// * ！！！！！！！！！！！注意这个接口不要随便自己用，必须是在白名单中的才会启动成功！！！如有需要请联系 基础组
// *
// * @param name 要启动的应用名。
// * @param params 应动应用时，需要转递给另一个应用的参数。
// * @param launchMode 指定 app 启动的方式。
// * @param sourceId 启动 app 的调用者。如果传nil，会自动获取当前页面作为sourceId
// * @param sceneParams app 的场景参数,可用于传递安全管控类参数
// *
// * @return 应用启动成功返回YES，否则返回NO。
// */
//- (BOOL)syncStartApplication:(NSString *)name
//                      params:(NSDictionary *)params
//                  launchMode:(NSMicroApplicationLaunchMode)launchMode
//                    sourceId:(NSString *)sourceId
//                 sceneParams:(NSDictionary *)sceneParams;

/**
 * 返回当前在栈顶的应用，即对用户可见的应用。
 *
 * @return 当前可见的应用。
 */
- (NSMicroApplication *)currentApplication{
    
    return nil;
}

/**
 * 返回当前主程序window上显示的VC，不包括childController。
 * 注意：要保证在主线程里调用。
 *
 * @return 当前可见的VC。
 */
- (UIViewController *)currentVisibleViewController{
    
    return nil;
    
}
@end
