//
//  LRCBaseViewController.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/19.
//

#import "LRCBaseViewController.h"

@interface LRCBaseViewController ()

@end

@implementation LRCBaseViewController
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    LRCBaseViewController *viewCtrl = [super allocWithZone:zone];
    if (viewCtrl) {
        @weakify(viewCtrl);
        [[viewCtrl rac_signalForSelector:@selector(viewDidLoad)]subscribeNext:^(id x) {
            @strongify(viewCtrl);
            viewCtrl.view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
            [viewCtrl setupUI];
            [viewCtrl bindViewModel];
            [viewCtrl setupNoticeMonitors];
        }];
        [[viewCtrl rac_signalForSelector:@selector(viewWillAppear:)]subscribeNext:^(id x) {
 
            
        }];
    }
    return viewCtrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - MVVM配置
// 添加控件
- (void)setupUI{}
// 绑定ViewModel
- (void)bindViewModel{}
// 配置通知监听
- (void)setupNoticeMonitors{}

 



@end
