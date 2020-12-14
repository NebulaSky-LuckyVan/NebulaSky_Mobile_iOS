//
//  NSCommonUIFactory.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import <Foundation/Foundation.h>
#import "NSTableView.h"
#import "NSCollectionView.h"
#import "NSMenuOperation.h"
typedef NS_ENUM(NSUInteger,NSMenuBarPosition) {
    NSMenuBarPosition_Left = 0,
    NSMenuBarPosition_Center,
    NSMenuBarPosition_Right,
};
typedef void(^CommonMenuItemHandler)(NSMenuItem *item); 
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

//

+ (NSMenuOperation*)menuWithItemTitles:(NSArray<NSString*>*)titles itemActionHandler:(NSArray<CommonMenuItemHandler>*)actions;

+ (NSMenuOperation*)menuWithItemImages:(NSArray<UIImage*>*)imgs itemActionHandler:(NSArray<CommonMenuItemHandler>*)actions;

+ (NSMenuOperation*)menuWithItemTitles:(NSArray<NSString*>*)titles itemImages:(NSArray<UIImage*>*)imgs itemActionHandler:(NSArray<CommonMenuItemHandler>*)actions;

+ (void)showNavigationMenu:(NSMenuOperation*)menu withMenuBarPoisition:(NSMenuBarPosition)position;
+ (void)showTabBarMenu:(NSMenuOperation*)menu withMenuBarPoisition:(NSMenuBarPosition)position;
@end
 
