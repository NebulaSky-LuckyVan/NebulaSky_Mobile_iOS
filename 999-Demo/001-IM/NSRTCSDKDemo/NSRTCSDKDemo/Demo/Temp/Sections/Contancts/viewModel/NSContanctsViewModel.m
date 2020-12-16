//
//  NSContanctsViewModel.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSContanctsViewModel.h"
#import "NSContanctsViewController.h"


#import "NSRTCChatViewController.h"
#import "NSRTCGroupChatViewController.h"
 

#import "NSRTCChatManager.h"
#import "NSRTCClient.h"
#import "NSContanctsUser.h"

#import "NSRTCFriendModel.h"
#import "NSRTCURLRequestOperation.h"

#import "NSMenuOperation.h"
 
#import "NSContanctsHeader.h"
 
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface NSContanctsViewModel ()<CNContactPickerDelegate>
//Desc:
@property (strong, nonatomic) NSMenuOperation *menu;
@end
@implementation NSContanctsViewModel


-(NSMenuOperation *)menu{
    if (!_menu) {
        @weakify(self);
        CommonMenuItemHandler CallMenuHandler1 = ^(NSMenuItem*item){
            self_weak_.IsEditing = YES;
            [self_weak_.currTableViewCtrl.tableView reloadData];
            void (^CallCommonAddRightHandler)(void) = ^(void){
                self_weak_.viewController.navigationItem.leftBarButtonItem = nil;
                self_weak_.viewController.navigationItem.rightBarButtonItem = nil;
                UIButton *startNewServiceBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
                [startNewServiceBtn action:^(UIButton *sendor) {
                    [self_weak_.requestOpenDrodownMenuHandlerSbj sendNext:nil];
                }];
                self_weak_.viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:startNewServiceBtn];
                NSContanctsViewController *superPage  = (NSContanctsViewController*)self_weak_.viewController;
                for (NSArray *sectionList in superPage.dataSource) {
                    for (NSViewItem *itm in sectionList) {
                        itm.IsSelected = NO;
                    }
                }
                self_weak_.IsEditing = NO;
                [self_weak_.currTableViewCtrl.tableView reloadData];
            };
            
            UIButton *cancelSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelSelectedBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            cancelSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [cancelSelectedBtn action:^(UIButton *sendor) {
                CallCommonAddRightHandler();
            }];
            self_weak_.viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelSelectedBtn];
            
            
            UIButton *confirmSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [confirmSelectedBtn setTitle:@"确定" forState:UIControlStateNormal];
            [confirmSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            confirmSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [confirmSelectedBtn action:^(UIButton *sendor) {
                NSMutableArray *selecedItem = [NSMutableArray array];
                NSContanctsViewController *superPage  = (NSContanctsViewController*)self_weak_.viewController;
                for (NSArray *sectionList in superPage.dataSource) {
                    for (NSViewItem *itm in sectionList) {
                        if (itm.IsSelected == YES) {
                            [selecedItem addObject:itm];
                        }
                    }
                }
                CallCommonAddRightHandler();
                //发起群聊
                NSLog(@"选中了:%@",selecedItem);
                
                __block NSMutableArray *selecedItemsUserName = [NSMutableArray array];
                [selecedItem enumerateObjectsUsingBlock:^(NSViewItem *itm, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSRTCFriendModel *friendModel = itm.Model;
                    [selecedItemsUserName addObject:friendModel.name];
                }];
                NSRTCGroupChatViewController*chatVC = [NSRTCGroupChatViewController groupChatWithUsers:selecedItemsUserName];
                chatVC.hidesBottomBarWhenPushed = YES;
                [self.viewController.navigationController pushViewController:chatVC animated:YES];;
            }];
            self_weak_.viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:confirmSelectedBtn];
        };
        _menu = [NSCommonUIFactory menuWithItemTitles:@[@"发起群聊"] itemActionHandler:@[
            CallMenuHandler1
        ]];
    }
    return _menu;
}
+ (instancetype)modelWithViewCtrl:(NSViewController *)viewCtrl{
    NSContanctsViewModel *vmd  = [super modelWithViewCtrl:viewCtrl];
    [vmd setup];
    return vmd;
}
-(void)actionAtIndex:(NSIndexPath *)index withItem:(NSViewItem *)itm{
    if (self.IsEditing) {
        itm.IsSelected = !itm.IsSelected;
        [self.currTableViewCtrl.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        NSRTCFriendModel *model = itm.Model;
        NSRTCChatViewController *chatVC = [[NSRTCChatViewController alloc] initWithToUser:model.name];
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:chatVC animated:YES];
    }
    
}
- (void)setup{
    NSContanctsViewController *superPage = (NSContanctsViewController*)self.viewController;
    [NSRTCClient shareClient].onUserOnline(^(NSString* userName){
        [superPage.dataSource enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = 0;
            for (NSViewItem *itm in obj) {
                NSRTCFriendModel *friends = itm.Model;
                if ([friends.name isEqualToString:userName]) {
                    friends.isOnline = YES;
                    [superPage showHint:[NSString stringWithFormat:@"%@上线了", userName]];
                    [superPage.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:idx+1]] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                }
                index ++;
            }
        }];
    }).onUserOffline(^(NSString* userName){
        
        [superPage.dataSource enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = 0;
            for (NSViewItem *itm in obj) {
                NSRTCFriendModel *friends = itm.Model;
                if ([friends.name isEqualToString:userName]) {
                    friends.isOnline = YES;
                    [superPage showHint:[NSString stringWithFormat:@"%@下线了", userName]];
                    [superPage.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:idx+1]] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                }
                index ++;
            }
        }];
    });

}
- (RACSubject *)requestContanctsListHandlerSbj{
    if (!_requestContanctsListHandlerSbj) {
        _requestContanctsListHandlerSbj = [RACSubject subject];
        [_requestContanctsListHandlerSbj subscribeNext:^(id x) {
            __weak typeof(self) weakSelf = self;
            [NSRTCURLRequestOperation request:GetRequest withUrlString:[BaseURL stringByAppendingPathComponent:allUserURL] parameters:nil success:^(id response) {
                DLog(@"%@", response);
                NSArray *allFriends = [NSArray yy_modelArrayWithClass:[NSRTCFriendModel class] json:response[@"data"][@"allUser"]];
                for (NSString *onlineUser in response[@"data"][@"onLineUsers"]) {
                    if ([onlineUser isKindOfClass:[NSNull class]]) {
                        break;
                    }
                    for (NSRTCFriendModel *friend in allFriends) {
                        if ([friend.name isEqualToString:onlineUser]) {
                            friend.isOnline = YES;
                            break;
                        }
                    }
                }
//                NSContanctsViewController *superPage = (NSContanctsViewController*)weakSelf.viewController;
//                [self sortPinYing:allFriends complection:^(NSArray *datas, NSArray *keys) {
//                    [superPage.dataSource addObjectsFromArray:datas];
//                    [superPage.sectionTitles addObjectsFromArray:keys];
//                }];
//                if (superPage.dataSource.count) {
//                    [superPage.tableView reloadData];
//                }
                
                //收进NSViewItem
                NSMutableArray *itms = [NSMutableArray arrayWithCapacity:allFriends.count];
                for (NSRTCFriendModel *friend in allFriends) {
                    NSViewItem *itm = [NSViewItem itemWithView:nil model:friend];
                    [friend.name isEqualToString:[NSRTCChatManager shareManager].user.currentUserID]?:[itms addObject:itm];
                }
                
                NSContanctsViewController *superPage = (NSContanctsViewController*)weakSelf.viewController;
                [self sortViewItmModelPinYing:itms complection:^(NSArray *datas, NSArray *keys) {
                    [superPage.dataSource addObjectsFromArray:datas];
                    [superPage.sectionTitles addObjectsFromArray:keys];
                }];
                if (superPage.dataSource.count) {
                    [superPage.tableView reloadData];
                }
                
            } fail:^(id error) {
                [weakSelf.viewController showError:@"加载好友失败"];
            }];
        }];
    }
    return _requestContanctsListHandlerSbj;
}
 
- (RACSubject *)requestOpenDrodownMenuHandlerSbj{
    if (!_requestOpenDrodownMenuHandlerSbj) {
        @weakify(self);
        _requestOpenDrodownMenuHandlerSbj = [RACSubject subject];
        [_requestOpenDrodownMenuHandlerSbj subscribeNext:^(id x) {
            [NSCommonUIFactory showNavigationMenu:self_weak_.menu withMenuBarPoisition:NSMenuBarPosition_Right]; 
        }];
    }
    return _requestOpenDrodownMenuHandlerSbj;
}
/*按照拼音首字母排序*/
-(void)sortViewItmModelPinYing:(NSArray*)pFriendListArray complection:(void(^)(NSArray *datas,NSArray*keys))complection{
    NSMutableArray *finalArr = [NSMutableArray array];
    NSMutableArray *finalKeys = [NSMutableArray array];
    NSMutableDictionary *sortList = [NSMutableDictionary dictionary];
    NSMutableArray* pArray = nil;
    for(int i = 0;i < pFriendListArray.count; i++){
        NSViewItem *pItem = (NSViewItem*)[pFriendListArray objectAtIndex:i];
        NSContanctsUser *pItemModel =    pItem.Model;
        NSString* pPinYin = [self firstCharactor:pItemModel.name];
        for(char sz = 'A'; sz <= 'Z'; sz++){
            if(NSOrderedSame == [[NSString stringWithFormat:@"%c", sz] compare:pPinYin]){
                pArray =  sortList[pPinYin];
                if (!pArray) {
                    pArray  = [NSMutableArray array];
                }
                [pArray addObject:pItem];
                sortList[pPinYin] = pArray;
            }
            continue;
        }
    }
    
    for(char sz = 'A'; sz <= 'Z'; sz++){
        for (NSString *key in sortList.allKeys) {
            if(NSOrderedSame == [[NSString stringWithFormat:@"%c", sz] compare:key])
            {
                [finalArr addObject:sortList[key]];
                [finalKeys addObject:key];
                continue;
            }
        }
    }
    
    !complection?:complection(finalArr,finalKeys);
}
/*按照拼音首字母排序*/
-(void)sortPinYing:(NSArray*)pFriendListArray complection:(void(^)(NSArray *datas,NSArray*keys))complection{
    NSMutableArray *finalArr = [NSMutableArray array];
    NSMutableArray *finalKeys = [NSMutableArray array];
    NSMutableDictionary *sortList = [NSMutableDictionary dictionary];
    NSMutableArray* pArray = nil;
    for(int i = 0;i < pFriendListArray.count; i++){
        NSContanctsUser* pItem = (NSContanctsUser*)[pFriendListArray objectAtIndex:i];
        NSString* pPinYin = [self firstCharactor:pItem.name];
        for(char sz = 'A'; sz <= 'Z'; sz++){
            if(NSOrderedSame == [[NSString stringWithFormat:@"%c", sz] compare:pPinYin]){
                pArray =  sortList[pPinYin];
                if (!pArray) {
                    pArray  = [NSMutableArray array];
                }
                [pArray addObject:pItem];
                sortList[pPinYin] = pArray;
            }
            continue;
        }
    }
    
    for(char sz = 'A'; sz <= 'Z'; sz++){
        for (NSString *key in sortList.allKeys) {
            if(NSOrderedSame == [[NSString stringWithFormat:@"%c", sz] compare:key])
            {
                [finalArr addObject:sortList[key]];
                [finalKeys addObject:key];
                continue;
            }
        }
    }
    
    !complection?:complection(finalArr,finalKeys);
}

//CommonUtil里面的类方法：
//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)pString
{
    //转成了可变字符串
    NSMutableString *pStr = [NSMutableString stringWithString:pString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pPinYin = [pStr capitalizedString];
    //获取并返回首字母
    return [pPinYin substringToIndex:1];
}

- (NSArray*)firstCharactors:(NSArray*)pFriendListArray{
    
    NSMutableDictionary *sortList = [NSMutableDictionary dictionary];
    NSMutableArray* pArray = nil;
    for(int i = 0;i < pFriendListArray.count; i++){
        NSContanctsUser* pItem = (NSContanctsUser*)[pFriendListArray objectAtIndex:i];
        NSString* pPinYin = [self firstCharactor:pItem.name];
        for(char sz = 'A'; sz <= 'Z'; sz++){
            if(NSOrderedSame == [[NSString stringWithFormat:@"%c", sz] compare:pPinYin]){
                pArray =  sortList[pPinYin];
                if (!pArray) {
                    pArray  = [NSMutableArray array];
                }
                [pArray addObject:pItem];
                sortList[pPinYin] = pArray;
            }
            continue;
        }
    }
    return [sortList.allKeys copy];
}


- (RACSubject *)requestExcuteContactFilterHandlerSbj{
    if (!_requestExcuteContactFilterHandlerSbj) {
        @weakify(self);
        _requestExcuteContactFilterHandlerSbj = [RACSubject subject];
        [_requestExcuteContactFilterHandlerSbj subscribeNext:^(id x) {
            BOOL gotoStop = NO;
            NSContanctsUser *selectedUser = nil;
            NSContanctsViewController *superPage  = (NSContanctsViewController*)self_weak_.viewController;
            for ( NSArray*users in superPage.dataSource) {
                if (gotoStop == YES) {
                    break;
                }
                for (int i = 0; i<users.count; i++) {
                    NSViewItem *itm = users[i];
                    NSContanctsUser *user = itm.Model;
                    if ([user.name isEqualToString:x]) {
                        selectedUser = user;
                        if (![user.name isEqualToString:[NSRTCChatManager shareManager].user.currentUserID]) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                NSRTCChatViewController *chatVC = [[NSRTCChatViewController alloc] initWithToUser:selectedUser.name];
                                chatVC.hidesBottomBarWhenPushed = YES;
                                [self_weak_.viewController.navigationController pushViewController:chatVC animated:YES];
                            });
                        }
                        gotoStop = YES;
                        break ;
                    }
                }
            }
        }];
    }
    return _requestExcuteContactFilterHandlerSbj;
}

- (RACSubject *)requestExcuteContactHeaderClickHandlerSbj{
    if (!_requestExcuteContactHeaderClickHandlerSbj) {
        @weakify(self);
        _requestExcuteContactHeaderClickHandlerSbj = [RACSubject subject];
        NSContanctsViewController *superPage  = (NSContanctsViewController*)self_weak_.viewController;
        [_requestExcuteContactHeaderClickHandlerSbj subscribeNext:^(id x) {
            ContanctsHeaderMenuBtn menuBtn = [x integerValue];
            switch (menuBtn) {
                case ContanctsHeaderMenuBtn_SearchContacts:{
                    NSMutableArray *allUser = [NSMutableArray array];
                    for (NSArray*users in superPage.dataSource) {
                        for (int i = 0; i<users.count; i++) {
                            NSViewItem *itm = users[i];
                            NSContanctsUser *user = itm.Model;
                            [allUser addObject:user.name];
                        }
                    }
                    superPage.searchCtrlPage.searchOrinalItems = [allUser mutableCopy];
                    superPage.searchCtrlPage.modalPresentationStyle = UIModalPresentationFullScreen;
                    [superPage.navigationController presentViewController:superPage.searchCtrlPage animated:YES completion:NULL];
                }break;
                case ContanctsHeaderMenuBtn_PhoneContacts:{
                    CNContactPickerViewController *contactsPicker = [[CNContactPickerViewController alloc]init];
                    contactsPicker.delegate = self;
                    contactsPicker.modalPresentationStyle = UIModalPresentationFullScreen;
                    [superPage.navigationController presentViewController:contactsPicker animated:YES completion:NULL];
                }break;
                case ContanctsHeaderMenuBtn_CompanyContacts:{
                }break;
                case ContanctsHeaderMenuBtn_OriginazationStuctureContacts:{
                }break;
                case ContanctsHeaderMenuBtn_ZoneContacts:{
                }break;
                case ContanctsHeaderMenuBtn_RoleContacts:{
                }break;
                case ContanctsHeaderMenuBtn_OtherContacts:{
                }break;
                    
                default:
                    break;
            }
            NSLog(@"%s ---:%zd",__func__,menuBtn);
        }];
    }
    return _requestExcuteContactHeaderClickHandlerSbj;
}
/*!
 * @abstract    Invoked when the picker is closed.
 * @discussion  The picker will be dismissed automatically after a contact or property is picked.
 */
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    NSLog(@"%s",__func__);
}

/*!
 * @abstract    Singular delegate methods.
 * @discussion  These delegate methods will be invoked when the user selects a single contact or property.
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
   
    CNContact *selContact = contact;
    CNLabeledValue<CNPhoneNumber *>  *phoneNumberValue  =  [selContact.phoneNumbers firstObject];
    CNPhoneNumber * phoneNumber = phoneNumberValue.value;
    NSString *phoneStr = phoneNumber.stringValue;
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"手机号码:%@",phoneStr);
    [self.viewController showSuccess:[NSString stringWithFormat:@"你选中的号码为:%@",phoneStr]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewController showSuccess:[NSString stringWithFormat:@"此功能在开发中,敬请期待"]];
    });
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    NSLog(@"%s",__func__);
}

/*!
 * @abstract    Plural delegate methods.
 * @discussion  These delegate methods will be invoked when the user is done selecting multiple contacts or properties.
 *              Implementing one of these methods will configure the picker for multi-selection.
 */
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts{
//    NSLog(@"contacts:%@",contacts);
//
//    CNContact *selContact = [contacts firstObject];
//    CNLabeledValue<CNPhoneNumber *>  *phoneNumberValue  =  [selContact.phoneNumbers firstObject];
//    CNPhoneNumber * phoneNumber = phoneNumberValue.value;
//    NSString *phoneStr = phoneNumber.stringValue;
//    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSLog(@"手机号码:%@",phoneStr);
//}
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty*> *)contactProperties{
//    NSLog(@"%s",__func__);
//}

@end
