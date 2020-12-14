//
//  NSCollectionViewController.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//

#import "NSViewController.h"
 
#import "NSCollectionView.h"

@interface NSCollectionViewController : NSViewController
//Desc:
@property (strong, nonatomic) NSCollectionView *collectionView;

- (void)dataSouece:(void(^)(NSCollectionView *collectionView,NSDataSource*datasource))datasourceHandlerBlock delegate:(void(^)(NSCollectionView *collectionView,NSDelegate*delegate))delegateHandlerBlock;
@end
 
