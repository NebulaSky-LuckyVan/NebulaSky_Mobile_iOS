//
//  NSMicroApplicationLaunchMode.h
//  DobulePlatformApplications
//
//  Created by VanZhang on 2020/11/18.
//
#import <Foundation/Foundation.h>
// App的rootViewController启动时的展示方式 
typedef NS_ENUM(NSInteger, NSMicroApplicationLaunchMode) {
    kNSMicroApplicationLaunchMode_ClearTop,              // 保留定义，暂时不支持。
    kNSMicroApplicationLaunchMode_PushWithAnimation,     // 有动画的Push方式展示。
    kNSMicroApplicationLaunchMode_PushNoAnimation,       // 无动画的Push方式展示。
    kNSMicroApplicationLaunchMode_PresentWithAnimation,  // 有动画的Present方式展示。
    kNSMicroApplicationLaunchMode_PresentNoAnimation,    // 无动画的Present方式展示。
    kNSMicroApplicationLaunchMode_FlipFromLeft,          // 左侧弹出的Push方式展示。
    kNSMicroApplicationLaunchMode_FlipFromRight,         // 右侧弹出的Push方式展示。
};
