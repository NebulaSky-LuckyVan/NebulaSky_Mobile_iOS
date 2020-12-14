//
//  NSCollectionViewController.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//

#import "NSCollectionViewController.h"

#import "NSCommonUIFactory.h"
#import <Masonry/Masonry.h>
@interface NSCollectionViewController ()

@end

@implementation NSCollectionViewController

-(NSCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [NSCommonUIFactory collectionViewWithSuperView:self.view collectionViewLayout:[[UICollectionViewFlowLayout alloc]init] datasource:NULL delegate:NULL];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setupUI{
    @weakify(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self_weak_.view);
        make.top.equalTo(@(-35));
    }];
    [self.collectionView reloadData];
}
- (void)bindViewModel{
    
}
- (void)setupNoticeMonitors{
    
}
- (void)dataSouece:(void(^)(NSCollectionView *collectionView,NSDataSource*datasource))datasourceHandlerBlock delegate:(void(^)(NSCollectionView *collectionView,NSDelegate*delegate))delegateHandlerBlock{
    [NSCommonUIFactory collectionView:self.collectionView datasource:datasourceHandlerBlock delegate:delegateHandlerBlock];
}

@end
