//
//  NSTabBarController.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "YNETTabBarController.h"
#import "NSNavigationController.h"

#import "NSAppPropertylistParser.h"


#import "NSLoginViewModel.h"


@interface YNETTabBarController ()

@end

@implementation YNETTabBarController

+ (void)initialize{
    UITabBarItem *tabItem = [UITabBarItem appearance];
    //title设置
    [tabItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x191F25],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [tabItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xF57A00],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected]; 
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupChildVcs];
    [self setupTabBarItems];
}
//设置tabbarItem
- (void)setupTabBarItems{
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabbarAppearance = self.tabBar.standardAppearance;
        tabbarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x191F25], NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:10]};
        tabbarAppearance.stackedLayoutAppearance.selected.titleTextAttributes =  @{NSForegroundColorAttributeName:[UIColor colorWithHex:0xF57A00]};
        //底部tabar的黑线不需要可以设置
//        tabbarAppearance.shadowImage =
//        tabbarAppearance.backgroundImage =
        self.tabBar.standardAppearance = tabbarAppearance;
        
      } else {
          // iOS 13以下
          NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
          // 文字颜色
          normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x191F25];
          // 文字大小
          normalAttrs[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
          // UIControlSrateSelected状态下的文字属性
          NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
          // 文字颜色
          selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xF57A00];
          // 统一给所有的UITabBarItem设置文字属性
          UITabBarItem *item = [UITabBarItem appearance];
          [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
          [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
          //底部tabar的黑线不需要可以设置
//          self.tabBar.shadowImage =
//          self.tabBar.backgroundImage =
      }
}
-(void)setupChildVcs{
    
    
    NSArray *childVcs =  [[NSAppPropertylistParser shareInstance]parser]; ;
    
    [childVcs enumerateObjectsUsingBlock:^(ChildVcObj  * childVc, NSUInteger idx, BOOL * stop) {
        Class childVcClass = NSClassFromString(childVc.className);
        if (childVcClass) {
            
            UIViewController*vc = [[childVcClass alloc]init];
            NSNavigationController *nav = [[NSNavigationController alloc]initWithRootViewController:vc];
            UITabBarItem *tabBarItem = nav.tabBarItem;
            float origin = -9 + 6;
            tabBarItem.imageInsets = UIEdgeInsetsMake(origin, 0, -origin,0);//（当只有图片的时候）需要自动调整
            tabBarItem.titlePositionAdjustment = UIOffsetMake(-2 + 8, 2-8);
            vc.navigationItem.title = childVc.navTitle;
            
            
            UIImage *normalImg  = [[UIImage imageNamed: childVc.tabBarItemNormalImage]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            UIImage *selImg  = [[UIImage imageNamed:childVc.tabBarItemSelImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [tabBarItem setImage:normalImg];
            [tabBarItem setSelectedImage:selImg];
            [tabBarItem setTitle:childVc.tabTitle];
            
            [self addChildViewController:nav];
            
        }
    }];
    if (([NSRTCClient status]==NSRTCClientStatus_NotConnected||[NSRTCClient status]==NSRTCClientStatus_Disconnected)&&[[NSUserDefaults standardUserDefaults] boolForKey:kDidLogin]) {
        [NSLoginViewModel socketConnectWithToken: [NSRTCChatManager shareManager].user.auth_token complection:^(BOOL success) {
            if (success) {
                NSLog(@"%@",@"静默登录成功");
            }else{
                NSLog(@"auth_token:%@",[NSRTCChatManager shareManager].user.auth_token);
            }
        }];
    }
    
    
}
#pragma mark - 点击动画
#pragma mark UITabBarControllerDelegate
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //show animations when the user pressed
    
    [self showAnimationsWithIndex:self.selectedIndex];
}
//show animations when the user pressed
-(void)showAnimationsWithIndex:(NSInteger)index{
    //Get the pressed Btn
    NSMutableArray *subBtn = [NSMutableArray arrayWithCapacity:0];
    for (UIView *sbView in self.tabBar.subviews) {
        if ([sbView isKindOfClass:[UIControl class]]) {
            [subBtn addObject:sbView];
        }
    }
    UIControl *pressedBtn = subBtn[index];
    for (UIView *sbView in pressedBtn.subviews) {
        if ([sbView isKindOfClass:[UIImageView class]]) {
            CAKeyframeAnimation *animations = [CAKeyframeAnimation animation];
            animations.keyPath = @"transform.scale";
            animations.values = @[@1.0,@1.1,@0.9,@1.0];
            animations.duration = 0.3;
            animations.calculationMode = kCAAnimationCubic;
            [sbView.layer addAnimation:animations forKey:nil];
        }
    }
}


@end
