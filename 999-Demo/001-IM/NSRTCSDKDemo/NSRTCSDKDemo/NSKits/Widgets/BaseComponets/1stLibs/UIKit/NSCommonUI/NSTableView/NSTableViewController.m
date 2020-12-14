//
//  NSTableViewController.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//

#import "NSTableViewController.h"
#import "NSCommonUIFactory.h"
#import <Masonry/Masonry.h>
@interface NSTableViewController ()

@end

@implementation NSTableViewController
-(NSTableView *)tableView{
    if (!_tableView) {
        _tableView = [NSCommonUIFactory tableViewWithSuperView:self.view datasource:NULL delegate:NULL];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setupUI{
    [super setupUI];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self_weak_.view);
        make.top.equalTo(@(-35));
    }];
    [self.tableView reloadData];
}
- (void)bindViewModel{
    [super bindViewModel];
}
- (void)setupNoticeMonitors{
    
}
- (void)dataSouece:(void(^)(NSTableView *tableView,NSDataSource*datasource))datasourceHandlerBlock delegate:(void(^)(NSTableView *tableView,NSDelegate*delegate))delegateHandlerBlock{
    [NSCommonUIFactory tableView:self.tableView datasource:datasourceHandlerBlock delegate:delegateHandlerBlock];
}


@end
