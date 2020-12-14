//
//  DoublePlatformManager.h
//  DobulePlatformApplications
//
//  Created by VanZhang on 2020/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoublePlatformManager : NSObject

@property (weak, nonatomic) UIViewController *rootViewController;

 

/**
 *  当前 app 所属的所有 view controller。
 */
@property(nonatomic, strong) NSMutableArray *viewControllers;



@end

NS_ASSUME_NONNULL_END
