//
//  DTFrameworkInterface+MultipleTargetMPaasProject.m
//  MultipleTargetMPaasProject
//
//  Created by VanZhang on 2020/11/20.
//  Copyright © 2020 Alibaba. All rights reserved.
//

#import "DTFrameworkInterface+MultipleTargetMPaasProject.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation DTFrameworkInterface (MultipleTargetMPaasProject)

- (BOOL)shouldLogReportActive
{
    return YES;
}

- (NSTimeInterval)logReportActiveMinInterval
{
    return 0;
}

- (BOOL)shouldLogStartupConsumption
{
    return YES;
}

- (BOOL)shouldAutoactivateBandageKit
{
    return YES;
}

- (BOOL)shouldAutoactivateShareKit
{
    return YES;
}

- (DTNavigationBarBackTextStyle)navigationBarBackTextStyle
{
    return DTNavigationBarBackTextStyleAlipay;
}








@end

#pragma clang diagnostic pop
