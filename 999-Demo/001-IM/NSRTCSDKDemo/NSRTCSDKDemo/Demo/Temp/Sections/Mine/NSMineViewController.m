//
//  NSMineViewController.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSMineViewController.h"
#import "NSMineHeaderBanner.h"
#import "NSMineViewModel.h"
#import "NSMineCell.h"

@interface NSMineViewController ()
//Desc:
@property (strong, nonatomic) NSMineViewModel *viewModel;
@end
@interface NSMineViewController ()
//Desc:
@property (strong, nonatomic) NSMineHeaderBanner *header;

@end

@implementation NSMineViewController
- (NSMineHeaderBanner *)header{
    if (!_header) {
        __weak typeof(self) weakSelf  = self;
        _header  = [[NSMineHeaderBanner alloc]init];
        NSString *userName  = [NSRTCChatManager shareManager].user.currentUserID;
        _header.userNameLb.text = userName.length>0?userName:@"昵称";
        _header.identifyLb.text = userName.length>0?[NSString stringWithFormat:@"ID:%@",userName]:@"ID:12345678";

        [_header.seeDetailBtn action:^(UIButton *sendor) {
            [weakSelf.viewModel userDetailPage];
        }];
        [_header.userIconBtn action:^(UIButton *sendor) {
            [weakSelf.viewModel changeUserIcon];
        }];
    }
    return _header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)bindViewModel{
    [super bindViewModel];
    self.viewModel  = [NSMineViewModel modelWithViewCtrl:self];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[[UIColor colorFromHexString:@"#F57A00"] colorWithAlphaComponent:0]];
     self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
     [self setNeedsStatusBarAppearanceUpdate];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[[UIColor colorFromHexString:@"#FFFFFF"] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)setupUI{
    [super setupUI];
    __weak typeof(self) weakSelf  = self;
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingBtn.top  = 20;
    settingBtn.AU_size = CGSizeMake(50, 50);
    settingBtn.left = self.view.width - 15-50;
    [settingBtn action:^(UIButton *sendor) {
        [weakSelf.viewModel settingPage];
    }];
    [settingBtn setImage:[[UIImage imageNamed:@"icon_set_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    UIBarButtonItem *settingItem  = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    messageBtn.top  = 20;
    messageBtn.AU_size = CGSizeMake(50, 50);
    messageBtn.left = self.view.width - 15-50;
    [messageBtn action:^(UIButton *sendor) {
        [weakSelf.viewModel messagePage];
    }];
    [messageBtn setImage:[[UIImage imageNamed:@"ding"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    UIBarButtonItem *messageItem  = [[UIBarButtonItem alloc]initWithCustomView:messageBtn];
    
    self.navigationItem.rightBarButtonItems = @[settingItem,messageItem];
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logout setTitle:@"安全退出" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout sizeToFit];
    [logout action:^(UIButton *sendor) {
        [weakSelf.viewModel logout];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:logout];
    
    
    
    self.header.height = 250.0/375.0*self.view.width;
    self.tableView.tableHeaderView  = self.header;
    
    
    
    
    [self dataSouece:^(NSTableView *tableView, NSDataSource *datasource) {
        //1.Registe Class
        NSMutableArray *ClassList  = [NSMutableArray array];
        [ClassList addObject:[NSMineCell class]];
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
            return 4;
        } setCellForRow:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            NSMineCell *cell = [(UITableView*)tableView dequeueReusableCellWithIdentifier:[NSMineCell reuseIdentifier]];
          
            NSString *title = @"";
            NSString *icon = @"";
            switch (indexPath.row) {
                case 0:{
                    icon = @"dklj";
                    title = [weakSelf getNextConnectHandlerTitle:[NSRTCClient status]];
                }break;
                case 1:{
                    icon = @"gywm";
                    title = @"关于我们";
                }break;
                case 2:{
                    icon = @"bzzx";
                    title = @"帮助中心";
                }break;
                case 3:{
                    icon = @"aqzx";
                    title = @"安全中心";
                }break;
                    
                default:
                    break;
            }
            [cell.iconImgView setImage:[UIImage imageNamed:icon]];
            cell.titleLb.text = title;
            [cell.titleLb sizeToFit];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }];
        
        [datasource tb_SetNumberOfSections:^NSUInteger(UITableView *tableView) {
            return 1;
        } setNumberOfRows:^NSUInteger(UITableView *tableView, NSUInteger section) {
            return 4;
        } setCellForRow:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            NSMineCell *cell = [(UITableView*)tableView dequeueReusableCellWithIdentifier:[NSMineCell reuseIdentifier]];
          
            NSString *title = @"";
            NSString *icon = @"";
            switch (indexPath.row) {
                case 0:{
                    icon = @"dklj";
                    title = [weakSelf getNextConnectHandlerTitle:[NSRTCClient status]];
                }break;
                case 1:{
                    icon = @"gywm";
                    title = @"关于我们";
                }break;
                case 2:{
                    icon = @"bzzx";
                    title = @"帮助中心";
                }break;
                case 3:{
                    icon = @"aqzx";
                    title = @"安全中心";
                }break;
                    
                default:
                    break;
            }
            [cell.iconImgView setImage:[UIImage imageNamed:icon]];
            cell.titleLb.text = title;
            [cell.titleLb sizeToFit];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }];
    } delegate:^(NSTableView *tableView, NSDelegate *delegate) {
        
        [delegate SetDidScroll:^(UIScrollView *scrollView, CGPoint contentOffset, CGSize contentSize, UIEdgeInsets contentInset) {
            NSLog(@"offsetY:%.2f",scrollView.mj_offsetY);
            [weakSelf changeNaviBarUIWithOffset:scrollView.mj_offsetY];
        }];
        [delegate tb_SetHeightForHeader:^CGFloat(UITableView *tableView, NSUInteger section) {
            return 0;
        } SetHeightForFooter:^CGFloat(UITableView *tableView, NSUInteger section) {
            return 0;
        } SetHeightForRow:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [delegate tb_SetSelectResponseForRow:^(UITableView *tableView, NSIndexPath *indexPath) {
            [(UITableView*)tableView deselectRowAtIndexPath:indexPath animated:NO];
            [weakSelf.viewModel actionAtIndex:indexPath withItem:[NSViewItem itemWithView:nil model:nil]];
        } didSelectForRow:^(UITableView *tableView, NSIndexPath *indexPath) {
        
        }];
    }];
  
    
     
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(-NAVIGATION_BAR_HEIGHT));
    }];
    
}

- (NSString *)getNextConnectHandlerTitle:(ClientStatus)status {
    
    NSString *statusDesc;
    switch (status) {
        case NSRTCClientStatus_NotConnected:
            statusDesc = @"重新连接";
            break;
        case NSRTCClientStatus_Connected:
            statusDesc = @"断开连接";
            break;
        case NSRTCClientStatus_Connecting:
            statusDesc = @"连接中";
            break;
        case NSRTCClientStatus_Disconnected:
            statusDesc = @"重新连接";
            break;
        default:
            break;
    }
    return statusDesc;
}

- (void)setNaviBarAlpha:(float)alpha
{
    NSLog(@"alpha:%.2f",alpha);
    [self.navigationController.navigationBar setBarTintColor:[[UIColor colorFromHexString:@"#F57A00"] colorWithAlphaComponent:alpha]];
    if (alpha > 0.5) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

- (void)changeNaviBarUIWithOffset:(CGFloat)offsetY
{
    // 根据偏移量修改下拉刷新view
    
    float boundY = iPhoneX ? (88 + 50) : (64 + 50);
    
    // 往上移动
    float percent_upward = (-offsetY) / boundY;
    percent_upward = percent_upward >= 1 ? 1 : percent_upward;
    
    // 往下移动
    float percent_downward = offsetY / boundY;
    percent_downward = percent_downward >= 1 ? 1 : percent_downward;
    
    if (offsetY < 0 && offsetY >= -boundY)
    {
        // -64 ~ 0
        [self setNaviBarAlpha:percent_upward];
    }
    else if (offsetY < -boundY)
    {
        // < -64
        [self setNaviBarAlpha:1];
    }
    else if (offsetY > 0 && offsetY <= boundY)
    {
        // 0 ~ 64
        [self setNaviBarAlpha:percent_downward];
    }
    else if (offsetY > boundY)
    {
        //  > 64
        [self setNaviBarAlpha:1];
    }
    else if (offsetY == 0)
    {
        // = 0
        [self setNaviBarAlpha:0];
    }
    else
    {
        [self setNaviBarAlpha:1];
    }
    // 根据偏移量来隐藏显示按钮
    if (offsetY <= 0)
    {
        //        _scanBadgeButton.hidden = YES;
        //
        //        _searchBackView.frame = CGRectMake(8, 7, screenWidth - 96 - 16, 30);
        
    }
    else
    {
        // 显示扫码
        //        _scanBadgeButton.hidden = NO;
        //
        //        _searchBackView.frame = CGRectMake(8+40, 7, screenWidth - 96 - 16 - 40, 30);
    }
    
    // 偏移量符合显示二楼提示
    CGFloat alpha_offsetY = -(44.0f + (iPhoneX ? 44.0f : 20.0f));
    if (offsetY < -125.0f + alpha_offsetY)
    {
        
        //        if ([NSHiddenFloorModel checkIsHaveTwoFloor:self.HiddenFloorModel]) {//有数据才显示有惊喜
        //            self.refreshView.titleLB.text = @"下拉有惊喜";
        //        }
    }
}
@end
