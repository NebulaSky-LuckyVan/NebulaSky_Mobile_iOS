//
//  NSMicroApplicationDelegate.h
//  DobulePlatformApplications
//
//  Created by VanZhang on 2020/11/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 
@class NSMicroApplication;

@protocol NSMicroApplicationDelegate <NSObject>

@required

/**
 * 请求应用对象的代理返回根视图控制器。
 *
 * @param application 应用对象。
 *
 * @return 应用的根视图控制器。
 */
- (UIViewController *)rootControllerInApplication:(NSMicroApplication *)application;

@optional

/**
 * 通知应用代理，应用对象已经对经被实例化。
 *
 * @param application 应用对象。
 */
- (void)applicationDidCreate:(NSMicroApplication *)application;

/**
 * 通知应用代理，应用将要启动。
 *
 * @param application 启动的应用对象。
 * @param options 应用运行参数。
 */
- (void)application:(NSMicroApplication *)application willStartLaunchingWithOptions:(NSDictionary *)options;

/**
 * 通知应用代理，应用已启动。
 *
 * @param application 启动的应用对象。
 */
- (void)applicationDidFinishLaunching:(NSMicroApplication *)application;

/**
 * 通知应用代理，应用即将暂停进入后台运行。
 *
 * @param application 启动的应用对象。
 */
- (void)applicationWillPause:(NSMicroApplication *)application;

/**
 通知应用代理，应用即将暂停进入后台运行，并且从app栈中移除，并加入到缓存中
 
 @param application application description
 */
- (void)applicationWillHide:(NSMicroApplication *)application;


/**
 通知应用代理，应用即将暂停进入前台运行
 
 @param application <#application description#>
 */
- (void)applicationWillShow:(NSMicroApplication *)application options:(NSDictionary *)options;

/**
 通知应用代理，应用已经进入前台运行
 
 @param application application description
 */
- (void)applicationDidShow:(NSMicroApplication *)application;

/**
 * 通知应用代理，应用将被重新激活。
 * 激活时机：1、显示调用startApp接口；2、它上面App退出，它将变成当前App；
 * 注意：willResumeWithOptions 代理方法只实现一个，否则两个方法都会回调的。
 *
 * @param application 要激活的应用对象。
 */
- (void)application:(NSMicroApplication *)application willResumeWithOptions:(NSDictionary *)options;

/**
 * 通知应用代理，应用将被重新激活。
 * 激活时机：1、显示调用startApp接口；2、它上面App退出，它将变成当前App；
 * 注意：willResumeWithOptions 代理方法只实现一个，否则两个方法都会回调的。
 *
 * @param application 要激活的应用对象。
 * @param isStartApp  是否通过startApp方式触发的；
 */
- (void)application:(NSMicroApplication *)application willResumeWithOptions:(NSDictionary *)options isStartApp:(BOOL)isStartApp;

/**
 * 通知应用代理，应用已经被激活。
 *
 * @param application 要激活的应用对象。
 */
- (void)applicationDidResume:(NSMicroApplication *)application;

/**
 * 通知应用代理，应用已经被激活。
 *
 * @param application 要激活的应用对象，带上参数的版本。
 */
- (void)application:(NSMicroApplication *)application didResumeWithOptions:(NSDictionary *)options;

/**
 * 通知应用的代理，应用将要退出。
 *
 * @param application 应用对象。
 */
- (void)applicationWillTerminate:(NSMicroApplication *)application;

/**
 * 通知应用的代理，应用将要退出。
 *
 * @param application 应用对象。
 * @param animated 是否以动画方式退出。
 */
- (void)applicationWillTerminate:(NSMicroApplication *)application animated:(BOOL)animated;

/**
 * 询问应用的代理，应用是否可以启动。
 * 注意：只用特殊情况返回：NO，要保证默认是YES才可以启动的。
 *
 * @param application 应用对象。
 * @param params      启动参数。
 * @param launchMode  启动方式。
 *
 * @return 是否可以启动
 */
- (BOOL)applicationShouldStart:(NSMicroApplication *)application params:(NSDictionary *)params aunchMode:(NSMicroApplicationLaunchMode) launchMode;

/**
 * 询问应用的代理，应用是否在真正启动时中断启动。
 * 注意：只用特殊情况返回：YES，要保证默认是NO才可以启动的。
 *
 * @param application 应用对象。
 * @param params      启动参数。
 * @param launchMode  启动方式。
 *
 * @return 是否终止启动
 */
- (BOOL)applicationInterruptStart:(NSMicroApplication *)application params:(NSDictionary *)params aunchMode:(NSMicroApplicationLaunchMode) launchMode;

/**
 *  询问应用的代理是否要启动多个应用对象。
 *  注意：默认是NO标识不支持；业务可以通过参数params，sourceId，栈顶App等来决定是否返回YES；
 *
 *  @param params     启动参数。
 *  @param launchMode 启动方式。
 *  @param sourceId   启动来源。
 *
 *  @return 返回YES创建一个新的App对象，否则不创建新app对象。
 */
- (BOOL)applicationShouldStartMultapplication:(NSDictionary *)params launchMode:(NSMicroApplicationLaunchMode) launchMode sourceId:(NSString *)sourceId;

/**
 *  询问应用的代理是否要启动多个应用对象。
 *  注意：1、默认是NO标识不支持；业务可以通过参数params，sourceId，栈顶App等来决定是否返回YES；
 *       2、针对appDelegate处理多个app的情况；
 *
 *  @param appId      appId。
 *  @param params     启动参数。
 *  @param launchMode 启动方式。
 *  @param sourceId   启动来源。
 *
 *  @return 返回YES创建一个新的App对象，否则不创建新app对象。
 */
- (BOOL)applicationShouldStartMultapplication:(NSString *)appId params:(NSDictionary *)params launchMode:(NSMicroApplicationLaunchMode) launchMode sourceId:(NSString *)sourceId;

/**
 * 询问应用的代理，应用是否可以退出
 * 注意：只用特殊情况返回：NO，要保证默认是YES才可以退出的。
 *
 * @param application 应用对象。
 *
 * @return 是否可以退出
 */
- (BOOL)applicationShouldTerminate:(NSMicroApplication *)application;

/**
 * 询问应用的代理，是否以无动画启动rootViewController
 * 注意：如果返回YES，则屏蔽startApplication的动画设置
 *
 * @param application 应用对象。
 *
 * @return YES：无动画启动；NO：默认处理方式
 */
- (BOOL)applicationStartRootControllerWithNoAnimation:(NSMicroApplication *)application;

/**
 *  通知应用代理，收到通知消息。
 *
 *  @param application 应用对象。
 *  @param userInfo    封装消息信息。
 *  @param completion  执行完成的block回调。
 */
- (void)application:(NSMicroApplication *)application didReceviceMessage:(NSDictionary *)userInfo completion:(void(^)(NSDictionary *result))completion;

/**
 * 通知应用的代理，应用将以Present方式启动viewController
 *
 * @param application 应用对象。
 * @param params      启动参数。
 * @param navigationController 导航控制器。
 *
 * @return 无
 */
- (void)applicationShouldPresent:(NSMicroApplication *)application params:(NSDictionary *)params navigationController:(UINavigationController *)navigationController;

/**
 * 通知应用的代理，应用已经Present方式启动viewController完成。
 *
 * @param application 应用对象。
 * @param params      启动参数。
 *
 * @return 无
 */
- (void)applicationDidPresent:(NSMicroApplication *)application params:(NSDictionary *)params;

/**
 *  返回应用的启动方式，通过该方法可以动态的修改app的启动方式。
 *
 *  @param application 应用对象。
 *  @param params      启动参数。
 *
 *  @return 返回应用的启动方式。
 */
- (NSMicroApplicationLaunchMode)applicationLaunchMode:(NSMicroApplication *)application params:(NSDictionary *)params;

/**
 *  保活应用如果再次进入的时候需要重新创建viewControllers，可以实现此方法来返回新的viewControllers数组。
 *
 *  @param 老的viewControllers。
 *
 *  @return 返回新的viewControllers。
 */
- (NSArray <UIViewController *> *)delayReleaseApplicationControllers:(NSArray <UIViewController *> *)oldViewContollers;

/**
 *  保活应用如果再次进入的时候需要重新创建viewControllers，可以实现此方法来返回新的viewControllers数组。
 *
 *  @param oldViewContollers 老的viewControllers
 *  @param params 启动参数
 *
 *  @return 返回新的viewControllers。
 */
- (NSArray <UIViewController *> *)delayReleaseApplicationControllers:(NSArray <UIViewController *> *)oldViewContollers
                                                              params:(NSDictionary *)params;


/**
 返回应用是否需要延时释放

 @param application application description
 @return YES or NO
 */
- (BOOL)applicationShouldDelayRelease:(NSMicroApplication *)application;

/**
 返回本次应用能否需要保活，如果调用到此函数，说明保活数组中有此app，
 
 @param application application description
 @return YES or NO
 */
- (BOOL)applicationShouldUseCache:(NSMicroApplication *)application params:(NSDictionary *)params;

/**
 返回缓存此app的最长时间

 @param application application description
 @return 缓存此app的最长时间，单位s
 */
- (NSTimeInterval )survivalTimeIntervalOfApplication:(NSMicroApplication *)application;



/**
 内存警告的时候，是否需要释放缓存中的app

 @param application application description
 @return YES or NO
 */
- (BOOL)applicationShouldReleaseWhenReceivedMemoryWarning:(NSMicroApplication *)application;

@end
 
