//
//  NSLoginPageController.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/8.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSLoginPageController.h"
#import "NSLoginPageHeaderBanner.h"
#import "NSLoginPageFooterBanner.h"
#import "NSLoginAccountInfoInputCell.h"

#import "NSLoginViewModel.h"
@interface NSLoginPageController ()<UITextFieldDelegate>
//Desc:
@property (weak, nonatomic) UITextField* userNameTF;
//Desc:
@property (weak, nonatomic) UITextField* passwordTF;

@end

@interface NSLoginPageController ()
//Desc:
@property (strong, nonatomic) NSLoginViewModel *viewModel;
@end

@implementation NSLoginPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupUI{
    
    [super setupUI];
    
    [self dataSouece:^(NSTableView *tableView, NSDataSource *datasource) {
        //1.Registe Class
        NSMutableArray *ClassList  = [NSMutableArray array];
        [ClassList addObject:[NSLoginAccountInfoInputCell class]];
        [ClassList addObject:[NSLoginPageHeaderBanner class]];
        [ClassList addObject:[NSLoginPageFooterBanner class]];
        [ClassList addObject:[NSLoginAccountInfoInputCell class]];
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
            return 1;
        } setCellForRow:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            NSDictionary *accountInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginAccountInfo"];
            NSLoginAccountInfoInputCell *cell = [(UITableView*)tableView dequeueReusableCellWithIdentifier:[NSLoginAccountInfoInputCell reuseId]];
            self.userNameTF = cell.accountTextFields;
            self.passwordTF = cell.pwdTextFields;
            self.userNameTF.delegate = self;
            self.passwordTF.delegate = self;
            if (accountInfo) {
                cell.accountTextFields.text = accountInfo[@"userName"];
                cell.pwdTextFields.text = accountInfo[@"password"];
            }
            return cell;
        }];
         
    } delegate:^(NSTableView *tableView, NSDelegate *delegate) {
        [delegate tb_SetHeightForHeader:^CGFloat(UITableView *tableView, NSUInteger section) {
            return 333;
        } SetHeightForFooter:^CGFloat(UITableView *tableView, NSUInteger section) {
            return 200 ;
        } SetHeightForRow:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 110;
        }];
        
        [delegate tb_SetViewForHeader:^UIView *(UITableView *tableView, NSUInteger section) {
            NSLoginPageHeaderBanner *header = [(UITableView*)tableView dequeueReusableHeaderFooterViewWithIdentifier:[NSLoginPageHeaderBanner headerReuseId]];
            return header;
        } SetViewForFooter:^UIView *(UITableView *tableView, NSUInteger section) {
            NSLoginPageFooterBanner *footer = [(UITableView*)tableView dequeueReusableHeaderFooterViewWithIdentifier:[NSLoginPageFooterBanner footerReuseId]];
            [footer.loginBtn action:^(UIButton *sendor) {
                if ([self checkInput]) {
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    parameters[@"userName"] = self.userNameTF.text;
                    parameters[@"password"] = self.passwordTF.text;
                    parameters[@"deviceType"] = @(2);
                    NSString *deviceId = [NSRTCChatManager shareManager].deviceToken;
                    parameters[@"deviceId"] = !deviceId?@"waitForNextTimeUpload":deviceId;
                    [self.viewModel.loginHandlerSbj sendNext:parameters];
                }
            }];
            [footer.registetBtn action:^(UIButton *sendor) {
                if ([self checkInput]) {
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    parameters[@"userName"] = self.userNameTF.text;
                    parameters[@"password"] = self.passwordTF.text;
                    [self.viewModel.registerHandlerSbj sendNext:parameters];
                }
            }];
            return footer;
        }];
        
        [delegate tb_SetSelectResponseForRow:^(UITableView *tableView, NSIndexPath *indexPath) {
            [(UITableView*)tableView deselectRowAtIndexPath:indexPath animated:NO];
        } didSelectForRow:^(UITableView *tableView, NSIndexPath *indexPath) {
        
        }];
    }];
    [self.tableView reloadData];
         
}




- (void)bindViewModel{
    self.viewModel  = [NSLoginViewModel modelWithViewCtrl:self];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"finishAPNSRegisterAndSyncDeviceId" object:nil]subscribeNext:^(NSNotification *notice) {
        NSDictionary *accountInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginAccountInfo"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"userName"] = accountInfo[@"userName"];
        parameters[@"password"] = accountInfo[@"password"];
//        parameters[@"deviceType"] = @(2);
//        NSString *deviceId = [NSRTCChatManager shareManager].deviceToken;
//        parameters[@"deviceId"] = !deviceId?@"waitForNextTimeUpload":deviceId;
        [self.viewModel.syncDeviceIdReLoginHandlerSbj sendNext:parameters];
    }];
}
#pragma mark - Private
- (BOOL)checkInput {
    if (!self.userNameTF.hasText) {
        [NSLoginPageController showWithTitle:@"请输入用户名" message:@"用户名为空" cancelButtonTitle:@"确定" otherButtonTitles:nil andAction:nil andParentView:nil];
        return NO;
    }
    else if (!self.passwordTF.hasText) {
        [NSLoginPageController showWithTitle:@"请输入密码" message:@"密码为空" cancelButtonTitle:@"确定" otherButtonTitles:nil andAction:nil andParentView:nil];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.userNameTF==textField) {
        [self.passwordTF becomeFirstResponder];
    }else if (self.passwordTF == textField){
        [self.view endEditing:YES];
    }
    return YES;
}



@end
