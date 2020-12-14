//
//  NSContanctsViewController.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSContanctsViewController.h"

#import "NSRTCFriendModel.h"
#import "NSRTCFriendsListCell.h"

#import "NSContanctsViewModel.h"

#import "NSContanctsHeader.h"
#import "NSContanctsUserCell.h"
#import "NSContanctsUser.h"
#import "NSContanctsHeaderBanner.h"



#import "NSSearchPageController.h"
 
@interface NSContanctsViewController ()<NSRTCChatMessageIOProtocol>

//Desc:
@property (strong, nonatomic) NSSearchPageController *searchCtrlPage;



@end
@interface NSContanctsViewController ()<NSContanctsHeaderMenuHandlerProtocol>
//Desc:
@property (strong, nonatomic) NSContanctsViewModel *viewModel;

@end

@implementation NSContanctsViewController

- (NSSearchPageController *)searchCtrlPage{
    if (!_searchCtrlPage) {
        @weakify(self);
        _searchCtrlPage = [[NSSearchPageController alloc]initWithNormalSearchPageWithSearchComplection:^(NSString *  titles) { 
            [self_weak_.viewModel.requestExcuteContactFilterHandlerSbj sendNext:titles];
        }];
    }
    return _searchCtrlPage;
}
    
#pragma mark - Lazy
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}
#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    [[NSRTCChatManager shareManager] addDelegate:self];
}
- (void)contactsHeader:(NSContanctsHeader*)header click:(ContanctsHeaderMenuBtn)menuBtn{
    [self.viewModel.requestExcuteContactHeaderClickHandlerSbj sendNext:@(menuBtn)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[[UIColor colorFromHexString:@"#FFFFFF"] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)setupUI{
    
    __weak typeof(self)  weakSelf = self;
    [self dataSouece:^(NSTableView *tableView, NSDataSource *datasource) {
        //1.Registe Class
        NSMutableArray *ClassList  = [NSMutableArray array];
        [ClassList addObject:[NSContanctsHeader class]];
        [ClassList addObject:[NSContanctsUserCell class]];
        [ClassList addObject:[NSContanctsHeaderBanner class]];
        for (Class cellClass in ClassList) {
            BOOL isTbClass  = [cellClass isSubclassOfClass:[UITableViewCell class]];
            BOOL isTbHeaderFooterClass  = [cellClass isSubclassOfClass:[UITableViewHeaderFooterView class]];
            if (isTbClass||isTbHeaderFooterClass) {
                datasource.registTableViewCellWithClass(cellClass,tableView);
            }
        }
        //2.Set section row
        [datasource tb_SetNumberOfSections:^NSUInteger(UITableView *tableView) {
            return 1+weakSelf.dataSource.count;
        } setNumberOfRows:^NSUInteger(UITableView *tableView, NSUInteger section) {
            return section!=0?[weakSelf.dataSource[section-1] count]:1;
        } setCellForRow:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.section==0) {
                NSContanctsHeader *cell = [tableView dequeueReusableCellWithIdentifier:[NSContanctsHeader reuseId]];
                cell.delegate = weakSelf;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                NSContanctsUserCell *cell = [(UITableView*)tableView dequeueReusableCellWithIdentifier:[NSContanctsUserCell reuseId]];
                NSArray *users = weakSelf.dataSource[indexPath.section-1];
                NSViewItem *itm = users[indexPath.row];
                NSContanctsUser *user = itm.Model;
                cell.nameLabel.text = user.name;
                //        cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Fruit-%ld", (indexPath.row % 10)]];
                [cell.iconImage setImage:[UIImage imageNamed:@"tx"]];
                [cell.iconImage setCornerRadius:20];
                cell.IsEditing = weakSelf.viewModel.IsEditing;
                cell.isSelected = itm.IsSelected;
                return cell;
            }
        }];
    } delegate:^(NSTableView *tableView, NSDelegate *delegate) {
        [delegate tb_SetHeightForHeader:^CGFloat(UITableView *tableView, NSUInteger section) {
            return section==1?55:section==0?0:20;
        } SetHeightForFooter:^CGFloat(UITableView *tableView, NSUInteger section) {
            return 0 ;
        } SetHeightForRow:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return indexPath.section==0?(50*7 + 15): 55;
        }];
        
        [delegate tb_SetViewForHeader:^UIView *(UITableView *tableView, NSUInteger section) {
            NSContanctsHeaderBanner *header = [(UITableView*)tableView dequeueReusableHeaderFooterViewWithIdentifier:[NSContanctsHeaderBanner headerReuseId]];
            header.titleLb.text = section==1?@"常用联系人": self.sectionTitles[section-1];
            header.titleLb.font = [UIFont boldSystemFontOfSize:section==1?17:10];
            return section==0?nil:header;
        } SetViewForFooter:^UIView *(UITableView *tableView, NSUInteger section) {
            UITableViewHeaderFooterView *footer = [(UITableView*)tableView dequeueReusableHeaderFooterViewWithIdentifier:[UITableViewHeaderFooterView footerReuseId]];
            return section==0?nil: footer;
        }];
        
        [delegate tb_SetSelectResponseForRow:^(UITableView *tableView, NSIndexPath *indexPath) {
            [(UITableView*)tableView deselectRowAtIndexPath:indexPath animated:NO];
            if (indexPath.section>=1) {
//                NSString *user = [weakSelf.dataSource[indexPath.section-1][indexPath.row] name];
                NSViewItem  *itm = weakSelf.dataSource[indexPath.section-1][indexPath.row];//NSViewItem
                NSContanctsUser *user = itm.Model;
                [weakSelf.viewModel actionAtIndex:indexPath withItem:itm];
            }
        } didSelectForRow:NULL];
    }];
    [self.tableView reloadData];
    
    UIButton *startNewServiceBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [startNewServiceBtn action:^(UIButton *sendor) {
        [weakSelf.viewModel.requestOpenDrodownMenuHandlerSbj sendNext:nil];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:startNewServiceBtn];
}



#pragma mark - Request

- (void)bindViewModel{
   self.viewModel  = [NSContanctsViewModel modelWithViewCtrl:self];
   [self.viewModel.requestContanctsListHandlerSbj sendNext:nil];
   [self.viewModel.requestContanctsListHandlerSbj subscribeCompleted:^{
       [self.tableView reloadData];
   }];
}




@end
