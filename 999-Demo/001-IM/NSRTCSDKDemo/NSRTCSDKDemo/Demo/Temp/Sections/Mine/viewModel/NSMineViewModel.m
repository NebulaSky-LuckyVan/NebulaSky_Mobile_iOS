//
//  NSMineViewModel.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSMineViewModel.h"

#import "NSLoginPageController.h"
#import "NSMineViewController.h"
@interface NSMineViewModel ()

@end
@implementation NSMineViewModel
-(void)actionAtIndex:(NSIndexPath *)index withItem:(NSViewItem *)itm{
    switch (index.row) {
        case 0:{
            if ([NSRTCClient status]==NSRTCClientStatus_Connected) {
                 [self disconnect];
            }else{
                 [self connect];
            }
            [self.currTableViewCtrl.tableView reloadData];
        }break;
        case 1:{
            [self aboutUsPage];
        }break;
        case 2:{
            [self helpCenterPage];
        }break;
        case 3:{
            [self safetyCenterPage];
        }break;
            
        default:
            break;
    }
}

- (void)logout{
    [[NSRTCClient shareClient] closeClient];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [UIApplication sharedApplication].delegate.window.rootViewController = [[NSLoginPageController alloc]init];
    [DTContextGet().navigationController pushViewController:[NSLoginPageController alloc] animated:YES];
}

- (void)settingPage{
    NSLog(@"%s",__func__);
}

- (void)messagePage{
    NSLog(@"%s",__func__);
}

- (void)changeUserIcon{
    NSLog(@"%s",__func__);
}

- (void)userDetailPage{
    NSLog(@"%s",__func__);
}
- (void)connect{
    
    [[NSRTCClient shareClient] connectClient];
}

- (void)disconnect{
    
    [[NSRTCClient shareClient] closeClient];
}

- (void)aboutUsPage{
    NSLog(@"%s",__func__);
}

- (void)helpCenterPage{
    NSLog(@"%s",__func__);
}

- (void)safetyCenterPage{
    NSLog(@"%s",__func__);
}
@end
