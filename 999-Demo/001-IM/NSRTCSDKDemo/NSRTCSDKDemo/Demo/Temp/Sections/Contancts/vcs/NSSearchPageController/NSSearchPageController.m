//
//  NSSearchPageController.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/18.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSSearchPageController.h"
#import "SearchResultPageController.h"

@interface NSSearchPageController ()
@property (strong, nonatomic) SearchResultPageController *searchResultPage;
//Desc:
@property (strong, nonatomic) NSMutableArray *searchResItems;

//Desc:
@property (copy, nonatomic) NSSearchPageComplectionHandler complection;
@end

@implementation NSSearchPageController

- (SearchResultPageController *)searchResultPage{
    if (!_searchResultPage) {
        __weak typeof(self)weakSelf = self;
        _searchResultPage =  [[SearchResultPageController alloc]initWithSearchResultSelectComplectionHandler:^(NSIndexPath *  indexPath) {
            NSLog(@"选中下标:%zd",indexPath.row);
            NSLog(@"选中内容:%@",self.searchResItems[indexPath.row]); 
            weakSelf.searchResultPage.searchPageController.searchBar.text = @"";
            !weakSelf.complection?:weakSelf.complection(weakSelf.searchResItems[indexPath.row]);
        }];
        _searchResultPage.updateSearchKeyBordsHandler(^(NSString*keywords,SearchResultPageController *weakSearchPage){
            NSLog(@"keywords:%@",keywords);
            NSMutableArray *searchResWithKeyWords = [NSMutableArray array];
            for (NSString *title in self.searchOrinalItems) {
                if ([title containsString:keywords]) {
                    [searchResWithKeyWords addObject:title];
                }
            }
            self.searchResItems = [searchResWithKeyWords mutableCopy];
            weakSearchPage.updateSearchResultItemsHandler(searchResWithKeyWords);
        });
        _searchResultPage.searchPageController = weakSelf;
    }
    return _searchResultPage;
}
- (instancetype)initWithNormalSearchPageWithSearchComplection:(NSSearchPageComplectionHandler)complection{
    
    self = [super initWithSearchResultsController:self.searchResultPage];
    if (self) {
        self.complection = complection;
    }
   
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self.searchResultPage;
    self.searchBar.delegate = self.searchResultPage;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIViewController *currPage  = [self requestCurrentVC];
    [currPage.tabBarController.tabBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIViewController *currPage  = [self requestCurrentVC];
    [currPage.tabBarController.tabBar setHidden:NO];
}

- (UIViewController *)requestCurrentVC{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabrCtrl = (UITabBarController*)nextResponder;
        if ([tabrCtrl.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navCtrl = tabrCtrl.selectedViewController;
            result = navCtrl.topViewController;
        }else{
            result = tabrCtrl.selectedViewController;
        }
    }else if([nextResponder isKindOfClass:[UINavigationController class]]){
        UINavigationController *navCtrl = (UINavigationController*)nextResponder;
        result = navCtrl.topViewController;
        
    } else {
        if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabrCtrl = (UITabBarController*)window.rootViewController;
            if ([tabrCtrl.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navCtrl = tabrCtrl.selectedViewController;
                result = navCtrl.topViewController;
            }else{
                result = tabrCtrl.selectedViewController;
            }
        }
    }
    return result;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
