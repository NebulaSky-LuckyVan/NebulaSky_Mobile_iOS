//
//  NSChatPageController.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSChatPageController.h"


#import "NSRTCChatManager.h"
#import "NSCategories.h"
#import "NSRTCMessage.h"
#import "NSRTCChatViewModel.h"

#import "NSRTCDemoMessage.h"
#import "NSRTCMessageCell.h"

#import "NSRTCChatImageBrowserController.h"
#import "NSRTCChatImageBrowserModel.h"
#import "NSRTCChatLocationDetailController.h"
#import "NSRTCVideoViewController.h"


#import "NSRTCMessageInputView.h"


#import <CoreLocation/CoreLocation.h>


#import "NSRTCAVLivePhoneCallViewController.h"

#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface NSChatPageController ()<UITableViewDelegate, UITableViewDataSource, NSRTCMessageInputViewDelegate, UIScrollViewDelegate, NSRTCMessageCellDelegate ,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *originalMessages;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSRTCMessageInputView *messageInputView;

@property (nonatomic, assign) BOOL isFirstLoad;

@property (strong, nonatomic) NSRTCChatViewModel *viewModel;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation NSChatPageController
- (instancetype)initWithToUser:(NSString *)toUser {
    self = [super init];
    if (self) {
        self.toUser = [toUser copy];
        
    }
    return self;
}

#pragma mark - LifeCircle
- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstLoad = YES;
}
- (void)bindViewModel{
    self.viewModel = [NSRTCChatViewModel modelWithViewCtrl:self];
    self.viewModel.toUser = [self.toUser copy];
    __weak typeof(self)weakSelf = self;
    self.viewModel.updateSendStatusWithMessageHandlerBlock = ^(NSRTCMessage *message) {
        NSInteger index = [weakSelf.originalMessages indexOfObject:message];
        if (index >= 0) {
            NSRTCMessageCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell updateSendStatus:message.sendStatus];
        }
    };
    self.viewModel.updateAfterReceivingMessageHandlerBlock = ^(NSMutableArray *dataSource) {
        if (dataSource.count>0) {
            weakSelf.originalMessages = [dataSource mutableCopy];
            [weakSelf.items removeAllObjects];
        }
        for (NSRTCMessage *msg in weakSelf.originalMessages) {
            NSRTCDemoMessage *message = [NSRTCDemoMessage yy_modelWithDictionary:[msg yy_modelToJSONObject]];
            [weakSelf.items addObject:message];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.items.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    };
    [self loadDataFromDB];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // 关闭时向消息列表添加当前会话(更新会话列表UI)
    [self.viewModel addCurrentConversationToChatList];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = self.toUser;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.messageInputView prepareToShow];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.messageInputView prepareToDissmiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.messageInputView endEditing:YES];
}

#pragma mark - UI
- (void)setupUI {
    
    self.title = self.viewModel.toUser;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xefefef];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, self.messageInputView.height, 0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadDataFromDB];
        
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    weakSelf.tableView.mj_header = header;
}

- (void)loadDataFromDB{
    __weak typeof(self)weakSelf = self;
    [self.viewModel queryDataFromDB:^(NSArray *  datasource) {
        if (datasource.count>0) {
            weakSelf.originalMessages = [datasource mutableCopy];
            [weakSelf.items removeAllObjects];
        }
        for (NSRTCMessage *msg in weakSelf.originalMessages) {
            NSRTCDemoMessage *message = [NSRTCDemoMessage yy_modelWithDictionary:[msg yy_modelToJSONObject]];
            [weakSelf.items addObject:message];
        }
        
        CGSize oldContentSize = weakSelf.tableView.contentSize;
        [weakSelf.tableView reloadData];
        if (weakSelf.isFirstLoad) {    // 第一次加载，滚动到底部
            weakSelf.isFirstLoad = NO;
            
            
            CGPoint tableOffset = weakSelf.tableView.contentOffset;
            UIEdgeInsets insets = weakSelf.tableView.contentInset;
            CGFloat addOffset = (weakSelf.tableView.contentSize.height - weakSelf.tableView.height + insets.bottom + 64);
            if (addOffset > 0) {
                tableOffset.y += addOffset;
                [weakSelf.tableView setContentOffset:tableOffset animated:NO];
            }
            
        }
        else {
            CGSize newContentSize = weakSelf.tableView.contentSize;
            CGFloat addHeight = newContentSize.height - oldContentSize.height;
            CGPoint tableOffset = weakSelf.tableView.contentOffset;
            tableOffset.y += addHeight;//(addHeight - _tableView.height/2);
            [weakSelf.tableView setContentOffset:tableOffset animated:NO];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
}
#pragma mark - Public
- (CGRect)getImageRectInWindowAtIndex:(NSInteger)index {
    
    NSRTCMessageCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    if (cell) { // cell存在
        
        if ([cell.contentBackView isKindOfClass:[NSRTCImageMessageContentView class]]) { // 图片类型
            UIView *view = cell.contentBackView;
            CGRect rect = [kKeyWindow convertRect:view.bounds fromView:view];
            return rect;
        }
    }
    return CGRectZero;
}







/**
 从相册选取照片
 */
- (void)chooseImagesFormAlbum{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:100 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.photoWidth = 320;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.maxImagesCount = 5;
    //    imagePickerVc.photoWidth = 500;
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSInteger index = 0;
        for (UIImage *image in photos) {
            id asset = assets[index];
            BOOL isOriginalPhoto = isSelectOriginalPhoto;
            NSDictionary *size = @{@"width" : @([asset pixelWidth]), @"height" : @([asset pixelHeight])};
            
            if (isOriginalPhoto) {
                __weak typeof(self) weakSelf = self;
                if (iOS8Later) {    // 系统版本
                    PHImageRequestOptions *request = [[PHImageRequestOptions alloc] init];
                    request.resizeMode = UIScrollViewDecelerationRateFast;
                    request.synchronous = YES;
                    [[PHImageManager defaultManager] requestImageDataForAsset:asset options: request resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                        
                        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                        if (downloadFinined && imageData) {// 图片数据不为空才传递
                            [weakSelf.viewModel sendImageMessageWithImgData:imageData image:image size:size];
                        }
                    }];
                }
                else {  // iOS8之前
                    dispatch_async(dispatch_get_global_queue(0,0), ^{
                        ALAsset *alsset = asset;
                        UIImage *image = [UIImage imageWithCGImage:[alsset thumbnail]];
                        NSData *imgData = UIImageJPEGRepresentation(image, 1);
                        [weakSelf.viewModel sendImageMessageWithImgData:imgData image:image size:size];
                    });
                }
            }else {
                @autoreleasepool {
                    NSData *imageData = UIImageJPEGRepresentation(image, 1);
                    [self.viewModel sendImageMessageWithImgData:imageData image:image size:size];
                }
                
            }
            index++;
        }
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


/**
 拍摄照片或短视频
 */
- (void)takePhoto {
    
    NSRTCVideoViewController *takeVC = [[NSRTCVideoViewController alloc] init];
    [self presentViewController:takeVC animated:YES completion:nil];
    
    __weak typeof(self) weakSelf = self;
    [takeVC setTakePhotoOrVideo:^(NSData *data, BOOL isPhoto){
        
        if (isPhoto) { // 照片
            
            [weakSelf.viewModel sendImageMessageWithImgData:data image:[UIImage imageWithData:data] size:@{@"width" : @(kScreenWidth * 2), @"height" : @(kScreenHeight * 2)}];
        }
        else {  // 视频
            
        }
    }];
}


/**
 发送位置
 */
- (void)sendLocation {
    
    NSRTCChatLocationController *locationVC = [[NSRTCChatLocationController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:locationVC];
    [self presentViewController:nav animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [locationVC setSendLocationBlock:^(CLLocationCoordinate2D coordinate, NSString *locationName, NSString *detailLocationName){
        
        locationName = locationName.length ? locationName : @"位置";
        NSLog(@"发送位置坐标:%lf===%lf", coordinate.latitude, coordinate.longitude);
        [weakSelf.viewModel sendLocationMessageWithLocation:coordinate locationName:locationName detailLocationName:detailLocationName];
    }];
}

/**
 进入视频聊天
 */
- (void)goToVideoChatRoom {
    NSRTCAVLivePhoneCallViewController *phoneCallPage = [NSRTCAVLivePhoneCallViewController takePhoneCall:NSRTCAVLivePhoneCallVideoCall toUser:self.toUser];
    [self presentViewController:phoneCallPage animated:YES completion:nil];
    
}
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSRTCDemoMessage *message = self.items[indexPath.row];
    NSString *cellIndentifier = [NSRTCMessageCell cellReuseIndetifierWithMessageModel:message];
    NSRTCMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[NSRTCMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier messageModel:message];
    }
    cell.delegate = self;
    cell.message = message;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSRTCDemoMessage *model = self.items[indexPath.row];
    return model.messageCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
}


#pragma mark - NSRTCMessageInputViewDelegate
- (void)messageInputView:(NSRTCMessageInputView *)inputView heightToBottomChange:(CGFloat)heightToBottom {
    
    
    //    DLog(@"\n\n=========%lf=======%ld\n=====\n====%@====\n======%lf\n\n\n", heightToBottom, self.dataSource.count, _tableView, _tableView.contentInset.top);
    CGFloat insetsTop = self.tableView.contentInset.top;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(insetsTop, 0, MAX(inputView.height, heightToBottom), 0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    static BOOL keyBoardIsDown = YES;
    static CGPoint keyboard_down_ContenOffset;
    static CGFloat keyboard_down_InputViewHeight;
    if (heightToBottom > inputView.height) {
        if (keyBoardIsDown) {
            keyboard_down_ContenOffset = self.tableView.contentOffset;
            keyboard_down_InputViewHeight = inputView.height;
        }
        keyBoardIsDown = NO;
        CGPoint contentOffset = keyboard_down_ContenOffset;
        CGFloat spaceHeight = MAX(0, self.tableView.height - self.tableView.contentSize.height - keyboard_down_InputViewHeight - insetsTop);
        contentOffset.y += MAX(0, heightToBottom - keyboard_down_InputViewHeight - spaceHeight);
        self.tableView.contentOffset = contentOffset;
    }
    else {
        keyBoardIsDown = YES;
    }
}

- (void)messageInputView:(NSRTCMessageInputView *)inputView sendBigEmotion:(NSString *)emotionName {
    
    
}

- (void)messageInputView:(NSRTCMessageInputView *)inputView sendText:(NSString *)text {
    
    [self.viewModel sendTextMessageWithText:text];
    
    
}
// 发送语音
- (void)messageInputView:(NSRTCMessageInputView *)inputView sendVoice:(NSString *)saveFile duration:(CGFloat)duration {
    
    [self.viewModel sendAudioMessageWithAudioSavePath:saveFile duration:duration];
}

- (void)messageInputView:(NSRTCMessageInputView *)inputView addIndexClicked:(NSInteger)index {
    
    [_messageInputView isAndResignFirstResponder];
    switch (index) {
        case 0: { // 相册选择照片
            [self chooseImagesFormAlbum];
            break;
        }
            
        case 1:{ // 拍摄
            [self takePhoto];
            break;
        }
        case 2: { // 位置
            [self sendLocation];
            break;
        }
        case 3: { // 直播
            NSLog(@"%s",__func__);
            break;
        }
        case 4: { // 视频通话
            [self goToVideoChatRoom];
            break;
        }
        case 5: { // 语音通话
//            [self goToVideoChatRoom];
            NSLog(@"%s",__func__);
            break;
        }
        case 6: { // 屏幕共享
            
            break;
        }
        default:
            break;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [_messageInputView isAndResignFirstResponder];
}

#pragma mark - NSRTCMessageCellDelegate
- (void)messageCell:(NSRTCMessageCell *)cell resendMessage:(NSRTCDemoMessage *)message {
    DLog(@"%@", [message yy_modelToJSONString]);
    message.sendStatus = NSRTCMessageSending;
    [self.viewModel updateSendStatusUIWithMessage:message];
    __weak typeof(self) weakSelf = self;
    [NSRTCMessageSender reSendMessage:message success:^{
        [weakSelf.viewModel updateSendStatusUIWithMessage:message];
    } fail:^{
        NSLog(@"消息重发失败:%s",__func__);
    }];
}

- (void)didTapContentOfMessageCell:(NSRTCMessageCell *)cell meesage:(NSRTCDemoMessage *)message{
    
    switch (message.type) {
        case NSRTCMessageImage:{
            
            NSMutableArray *array = [NSMutableArray array];
            NSInteger index = 0;
            NSInteger index1 = 0;
            NSInteger selectedIndex = 0;
            for (NSRTCDemoMessage *oneMessage in self.items) {
                if (oneMessage.type == NSRTCMessageImage) {
                    
                    
                    NSRTCChatImageBrowserModel *model = [[NSRTCChatImageBrowserModel alloc] init];
                    model.imageRemotePath = oneMessage.bodies.fileRemotePath;
                    model.imageName = oneMessage.bodies.fileName;
                    model.thumRemotePath = oneMessage.bodies.thumbnailRemotePath;
                    model.imageSize = CGSizeMake([oneMessage.bodies.size[@"width"] floatValue], [oneMessage.bodies.size[@"height"] floatValue]);
                    model.messageIndex = index;
                    [array addObject:model];
                    
                    
                    if ([oneMessage isEqual:message]) {
                        selectedIndex = index1;
                    }
                    index1++;
                }
                
                index ++;
            }
            
            NSRTCChatImageBrowserController *imageBrowseVC = [[NSRTCChatImageBrowserController alloc] initWithImageModels:array selectedIndex:selectedIndex];
            imageBrowseVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:imageBrowseVC animated:NO completion:nil];
            break;
        }
        case NSRTCMessageLoc:{
            
            NSRTCChatLocationDetailController *locDetailVC = [[NSRTCChatLocationDetailController alloc] initWithMessage:message];
            [self.navigationController pushViewController:locDetailVC animated:YES];
            
            break;
        }
            
        default:
            break;
    }
}


- (NSRTCMessageInputView*)messageInputView{
    if (!_messageInputView) {
        _messageInputView = [[NSRTCMessageInputView alloc] init];
        _messageInputView.delegate = self;
        [self.view addSubview:_messageInputView];
        
    }
    return _messageInputView;
}
@end
