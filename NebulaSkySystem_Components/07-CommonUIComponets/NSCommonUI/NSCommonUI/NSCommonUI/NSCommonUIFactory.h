//
//  NSCommonUIFactory.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import <Foundation/Foundation.h>
#import "NSTableView.h"
#import "NSCollectionView.h"


@interface NSCommonUIFactory : NSObject


+ (NSTableView*)tableViewWithSuperView:(UIView*)superView
                            datasource:(void(^)(NSTableView *tableView,NSDataSource*datasource))datasourceHandlerBlock
                              delegate:(void(^)(NSTableView *tableView,NSDelegate*delegate))delegateHandlerBlock;

+ (NSCollectionView*)collectionViewWithSuperView:(UIView*)superView
                            collectionViewLayout:(UICollectionViewLayout*)layout
                                      datasource:(void(^)(NSCollectionView *collectionView,NSDataSource*datasource))datasourceHandlerBlock
                                        delegate:(void(^)(NSCollectionView *collectionView,NSDelegate*delegate))delegateHandlerBlock;



+ (void)tableView:(NSTableView*)tableView
       datasource:(void(^)(NSTableView *tableView,NSDataSource*datasource))datasourceHandlerBlock
         delegate:(void(^)(NSTableView *tableView,NSDelegate*delegate))delegateHandlerBlock;

+ (void)collectionView:(NSCollectionView*)collectionView
            datasource:(void(^)(NSCollectionView *collectionView,NSDataSource*datasource))datasourceHandlerBlock
              delegate:(void(^)(NSCollectionView *collectionView,NSDelegate*delegate))delegateHandlerBlock;


+ (void)configItemMoveWithCollectionView:(NSCollectionView*)collectionView;
@end
 
