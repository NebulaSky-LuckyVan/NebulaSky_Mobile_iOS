//
//  DemoViewController.m
//  DobuleMicroApplications
//
//  Created by VanZhang on 2020/11/17.
//  Copyright © 2020 Alibaba. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"Hello World!";
    label.font = [UIFont systemFontOfSize:26];
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    label.center = CGPointMake(self.view.frame.size.width / 2, 0.4 * self.view.frame.size.height);
    [self.view addSubview:label];
     
    
    UIButton *SwitchMicroAppBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [SwitchMicroAppBtn setTitle:@"切换应用" forState:UIControlStateNormal];
    [SwitchMicroAppBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    SwitchMicroAppBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    SwitchMicroAppBtn.frame = CGRectMake(0, 0, 100, 50);
    SwitchMicroAppBtn.center = CGPointMake(label.center.x, label.center.y*0.7);
    [self.view addSubview:SwitchMicroAppBtn];
    
    [SwitchMicroAppBtn addTarget:self action:@selector(swithchMicroApp:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]init];
}
 
 
- (void)swithchMicroApp:(UIButton*)sendor{
    NSString*currMicroAppId =  DTContextGet().currentApplication.descriptor.name;
    NSString *microAppsId = @"";
    NSMutableDictionary *launchParams = [NSMutableDictionary dictionary];
    DTMicroApplicationLaunchMode transitionAnimationMode = kDTMicroApplicationLaunchModeClearTop;
    NSString *sourceId = @"";
    if ([currMicroAppId isEqualToString:@"App1LauncherId"]) {
        microAppsId = @"App2LauncherId";
        [launchParams addEntriesFromDictionary:@{@"key1":@"value1"}];
        transitionAnimationMode = kDTMicroApplicationLaunchModeFlipFromLeft;
        sourceId = @"";
    }else if ([currMicroAppId isEqualToString:@"App2LauncherId"]) {
        microAppsId = @"App1LauncherId";
        [launchParams addEntriesFromDictionary:@{@"key2":@"value2"}];
        transitionAnimationMode = kDTMicroApplicationLaunchModeFlipFromRight;
        sourceId = @"";
    }
    if ([DTContextGet() canHandleStartApplication:microAppsId params:launchParams]) {
        [DTContextGet() startApplication:microAppsId
                                  params:launchParams
                             appClearTop:NO
                              launchMode:transitionAnimationMode
                                sourceId:sourceId];
    }
}

@end
