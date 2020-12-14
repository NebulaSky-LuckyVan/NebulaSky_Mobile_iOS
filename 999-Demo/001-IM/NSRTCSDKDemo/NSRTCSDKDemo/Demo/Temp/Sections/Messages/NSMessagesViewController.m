//
//  NSMessagesViewController.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSMessagesViewController.h"
//#import "NSRTCChatViewController.h"

#import "NSChatPageController.h"
//#import <NSRTC/NSRTCConversation.h>
//#import <NSRTC/NSRTCChatViewModel.h>
//#import <NSRTC/NSRTCChatListViewModel.h>
#import "NSUnReadConversationModel.h"


#import "NSRTCConversation.h"
#import "NSRTCChatListViewModel.h"
#import "NSRTCChatViewModel.h"

#import "NSMessagesCell.h"
@interface NSMessagesViewController ()

@property (nonatomic, strong) NSMutableArray *items;

@property (strong, nonatomic) NSRTCChatListViewModel *viewModel;
 

@end

@implementation NSMessagesViewController

#pragma mark - Lazy
- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[[UIColor colorFromHexString:@"#FFFFFF"] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSRTCManager manager] checkUnreadConverstions];
     
}

- (void)bindViewModel{
    self.viewModel = [NSRTCChatListViewModel modelWithViewCtrl:self];
    __weak typeof(self)weakSelf = self;
    self.viewModel.updateChatListHandlerBlock = ^(NSMutableArray *conversations) {
        weakSelf.items = [conversations mutableCopy];
        [weakSelf.tableView reloadData];
    };
    // 打开会话，更新未读消息数量
    self.viewModel.updateConversationReadStatusHandlerBlock = ^(NSIndexPath *indexPath) {
        NSRTCChatListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        [cell updateUnreadCount];
    };
    
    [self.viewModel queryDataFromDB];
    
    
}
#pragma mark - UI
- (void)setupUI {
    [super setupUI];
    @weakify(self);
    [self dataSouece:^(NSTableView *tableView, NSDataSource *datasource) {
        //1.Registe Class
        NSMutableArray *ClassList  = [NSMutableArray array];
        [ClassList addObject:[NSMessagesCell class]];
        for (Class cellClass in ClassList) {
            BOOL isTbClass  = [cellClass isSubclassOfClass:[UITableViewCell class]];
            BOOL isTbHeaderFooterClass  = [cellClass isSubclassOfClass:[UITableViewHeaderFooterView class]];
            if (isTbClass||isTbHeaderFooterClass) {
                datasource.registTableViewCellWithClass(cellClass,tableView);
            }
        }
        //2.Set section row
        [datasource tb_SetNumberOfSections:^NSUInteger(UITableView *tableView) {
            return 1;
        } setNumberOfRows:^NSUInteger(UITableView *tableView, NSUInteger section) {
            return self.items.count;
        } setCellForRow:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            NSMessagesCell *cell = [(UITableView*)tableView dequeueReusableCellWithIdentifier:[NSMessagesCell reuseId]];
            NSRTCConversation *model = self.items[indexPath.row];
            cell.model = model;
            return cell;
        }];
         
    } delegate:^(NSTableView *tableView, NSDelegate *delegate) {
        [delegate tb_SetHeightForHeader:^CGFloat(UITableView *tableView, NSUInteger section) {
            return 0;
        } SetHeightForFooter:^CGFloat(UITableView *tableView, NSUInteger section) {
            return 0;
        } SetHeightForRow:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 70;
        }];
        
        [delegate tb_SetSelectResponseForRow:^(UITableView *tableView, NSIndexPath *indexPath) {
            [(UITableView*)tableView deselectRowAtIndexPath:indexPath animated:NO];
            NSRTCConversation *model = self.items[indexPath.row];
            NSString *user = model.userName;
            [self_weak_.viewModel chatWithUser:user];
        } didSelectForRow:^(UITableView *tableView, NSIndexPath *indexPath) {
             
        }];
    }];
    
    [self.tableView reloadData];
}



 



@end
