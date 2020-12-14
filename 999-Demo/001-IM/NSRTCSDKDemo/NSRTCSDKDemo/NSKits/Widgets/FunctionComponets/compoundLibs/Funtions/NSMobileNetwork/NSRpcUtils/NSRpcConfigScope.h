//
//  NSRpcConfigScope.h
//  NSMobileFramework
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//
 
#import <Foundation/Foundation.h>

/**
 * PRC 配置的作用域。
 */
typedef enum NSRpcConfigScope
{
    
    /** 全局生效。 */
    kNSRpcConfigScopeGlobal,
    
    /** 全局范围内，只生效一次。*/
    kNSRpcConfigScopeGlobalOnce,
    
    /** 本地线程生效。 */
    kNSRpcConfigScopeLocalThread,
    
    /** 最近一次 RPC 调用生效。 */
    kNSRpcConfigScoperaryTemporary,
    
} NSRpcConfigScope;
