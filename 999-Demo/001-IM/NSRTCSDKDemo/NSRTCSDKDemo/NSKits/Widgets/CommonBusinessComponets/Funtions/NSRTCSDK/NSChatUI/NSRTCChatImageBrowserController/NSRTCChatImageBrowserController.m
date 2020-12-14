//
//  NSRTCChatImageBrowserController.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCChatImageBrowserController.h"


#import "NSRTCChatImageBrowserCell.h"
#import "NSRTCChatViewController.h"

#import "NSRTCChatManager.h"
#import "NSRTCChatViewModel.h"
//#import <NSRTC/NSRTCChatManager.h>
//#import <NSRTC/NSRTCChatViewModel.h>

#import "NSRTCChatImageBrowserModel.h"

@interface NSRTCChatImageBrowserController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL firstLoad;


@end

@implementation NSRTCChatImageBrowserController

- (instancetype)initWithImageModels:(NSArray *)imageModels selectedIndex:(NSInteger)selectedIndex{
    if (self = [super init]) {
        self.firstLoad = YES;
        self.dataArray = [imageModels copy];
        self.selectedIndex = selectedIndex;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.firstLoad) {
        self.firstLoad = NO;
        NSRTCChatImageBrowserModel *model = self.dataArray[self.selectedIndex];
        NSRTCChatImageBrowserCell *cell = (NSRTCChatImageBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
        NSRTCChatViewController *chatVC = (NSRTCChatViewController*)[NSRTCChatManager shareManager].currChatPageViewModel.viewController;
        CGRect rect = [chatVC getImageRectInWindowAtIndex:model.messageIndex];
        [cell showAnimationWithStartRect:rect];
    }
    
}


#pragma mark - UI
- (void)creatUI {
    
    // self
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    [layout setSectionInset:UIEdgeInsetsZero];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setShowsVerticalScrollIndicator:NO];
    [_collectionView setPagingEnabled:YES];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[NSRTCChatImageBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([NSRTCChatImageBrowserCell class])];
    [_collectionView setContentOffset:CGPointMake(self.selectedIndex * kScreenWidth, 0)];
    [self.view addSubview:_collectionView];
    
    
}
#pragma mark - Private
- (void)closeAnimation {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.collectionView.contentOffset.x/kScreenWidth inSection:0];
    NSRTCChatImageBrowserCell *cell = (NSRTCChatImageBrowserCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    NSRTCChatViewController *chatVC = (NSRTCChatViewController*)[NSRTCChatManager shareManager].currChatPageViewModel.viewController;
    NSRTCChatImageBrowserModel *model = self.dataArray[indexPath.row];
    CGRect rect = [chatVC getImageRectInWindowAtIndex:model.messageIndex];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [cell hideAnimationWithEndRect:rect complete:^{
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Public
- (void)show {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    
    
}
#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSRTCChatImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NSRTCChatImageBrowserCell class]) forIndexPath:indexPath];
    NSRTCChatImageBrowserModel *imageModel = self.dataArray[indexPath.item];
    cell.imageModel = imageModel;
    
    __weak typeof(self) weakSelf = self;
    [cell setCloseBrowserBlock:^{
        
        [weakSelf closeAnimation];
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}


@end
