//
//  NSMicroApplication.h
//  DobulePlatformApplications
//
//  Created by VanZhang on 2020/11/18.
//

#import "NSMicroApplicationLaunchMode.h"
#import "NSMicroApplicationDescriptor.h"



@protocol NSMicroApplicationDelegate;
@class NSViewController;

@interface NSMicroApplication : NSObject
/**
 * 应用的描述信息，如：AppId对应descriptor.name。
 */
@property(nonatomic, strong) NSMicroApplicationDescriptor *descriptor;

/**
 * 当前 app 的代理。
 */
@property(nonatomic, strong) id <NSMicroApplicationDelegate> delegate;

/**
 *  当前 app 所属的所有 view controller。
 */
@property(nonatomic, strong) NSMutableArray *viewControllers;



@end
 
