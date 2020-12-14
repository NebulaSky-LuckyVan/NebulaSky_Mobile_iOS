//
//  NSRTCChatListViewController.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/1.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCChatListViewController.h"


#import "NSRTCChatViewController.h"
 
//#import <NSRTC/NSRTCConversation.h>
//#import <NSRTC/NSRTCChatListViewModel.h>

#import "NSRTCConversation.h"
#import "NSRTCChatListViewModel.h"



#import "NSRTCChatListCell.h"
#import "NSRTCStatusTitleView.h"



@interface NSRTCChatListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSRTCStatusTitleView *titleView;

@property (strong, nonatomic) NSRTCChatListViewModel *viewModel;

@end

@implementation NSRTCChatListViewController

#pragma mark - Lazy
- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[NSRTCStatusTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*2/3, 40)];
    }
    return _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
- (void)bindViewModel{
    
    self.viewModel = [NSRTCChatListViewModel modelWithViewCtrl:self];
    
    __weak typeof(self)weakSelf = self;
    self.viewModel.updateChatListHandlerBlock = ^(NSMutableArray *conversations) {
        weakSelf.items = [conversations mutableCopy];
        [weakSelf.tableView reloadData];
    };
    self.viewModel.updateConversationReadStatusHandlerBlock = ^(NSIndexPath *indexPath) {
        NSRTCChatListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        [cell updateUnreadCount];
    };
    
    [self.viewModel queryDataFromDB];
    
    
}
#pragma mark - UI
- (void)setupUI {
    
    
    self.navigationItem.titleView = self.titleView;
    
    UIBarButtonItem *chat = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(chat)];
    self.navigationItem.rightBarButtonItem = chat;
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[NSRTCChatListCell class] forCellReuseIdentifier:@"NSRTCChatListCell"];
    [_tableView setSeparatorColor:[UIColor colorWithHex:0xe5e5e5]];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 80, 0, 0)];
}

#pragma mark - Private
- (void)chat {
    
    NSRTCChatViewController *chatVC = [[NSRTCChatViewController alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

// 打开会话，更新未读消息数量
- (void)updateRedPointForCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NSRTCConversation *model = self.items[indexPath.row];
    model.unReadCount = 0;
    NSRTCChatListCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [cell updateUnreadCount];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSRTCChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSRTCChatListCell" forIndexPath:indexPath];
    NSRTCConversation *model = self.items[indexPath.row];
    model.imageStr = [NSString stringWithFormat:@"Fruit-%ld", indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSRTCConversation *model = self.items[indexPath.row];
    NSRTCChatViewController *chatVC = [[NSRTCChatViewController alloc] initWithToUser:model.userName];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
