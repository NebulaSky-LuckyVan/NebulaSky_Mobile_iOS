//
//  NSMicroApplicationDescriptor.h
//  DobulePlatformApplications
//
//  Created by VanZhang on 2020/11/19.
//

#import <Foundation/Foundation.h>
 

@interface NSMicroApplicationDescriptor : NSObject
/**
 * 应用Id。
 */
@property(nonatomic, copy) NSString *name;

/**
 * 应用的版本号。
 */
@property(nonatomic, copy) NSString *version;

@end
 
