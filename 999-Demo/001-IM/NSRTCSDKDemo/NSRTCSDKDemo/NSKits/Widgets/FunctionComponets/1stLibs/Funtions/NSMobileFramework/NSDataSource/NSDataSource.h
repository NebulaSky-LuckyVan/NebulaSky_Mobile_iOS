//
//  NSDataSource.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import <UIKit/UIKit.h>
 

typedef enum{
    NSC_SupplementaryElement_Header = 0,
    NSC_SupplementaryElement_Footer
}NSCollectionViewSupplementaryElementKind;
@protocol NSDataSourceProtocol <NSObject>

@optional
/**
 * WorkFor:UITableView Instance
 * NumberOfSections
 * NumberOfRows
 * ItemForRow
 */
- (void)tb_SetNumberOfSections:(NSUInteger(^)(UITableView*tableView))SectionsConfigBlock
               setNumberOfRows:(NSUInteger(^)(UITableView*tableView,NSUInteger section))RowConfigBlock
                 setCellForRow:(UITableViewCell*(^)(UITableView*tableView,NSIndexPath *indexPath))CellConfigBlock;
/**
 * WorkFor:UICollectionView Instance
 * NumberOfSections
 * NumberOfRows
 * ItemForRow
*/
- (void)col_SetNumberOfSections:(NSUInteger(^)(UICollectionView*collecitonView))SectionsConfigBlock
                setNumberOfRows:(NSUInteger(^)(UICollectionView*collecitonView,NSUInteger section))RowConfigBlock
                  setItemForRow:(UICollectionViewCell*(^)(UICollectionView*collecitonView,NSIndexPath *indexPath))CellConfigBlock;

/**
 * WorkFor:UICollectionView Instance
 * canMoveItemAtIndexPath
 * moveItemAtIndexPath toIndexPath
*/
- (void)col_SetItemMoveSwitchOfIndexPath:(BOOL(^)(UICollectionView*collecitonView,NSIndexPath *indexPath))CanMoveItemConfigBlock
     setItemMoveFromIndexPathToIndexPath:(void(^)(UICollectionView*collecitonView,NSIndexPath *sourceIndexPath,NSIndexPath *destinationIndexPath))RowConfigBlock;




/**
 * WorkFor:UICollectionView Instance
 * SetSupplementaryElementView
*/
- (void)col_SetSupplementaryElementViewAtIndexPath:(UICollectionReusableView *(^)(UICollectionView*collecitonView,NSCollectionViewSupplementaryElementKind kind,NSIndexPath *indexPath))SetSupplementaryElementViewConfigBlock;


@end

@interface NSDataSource : NSObject<NSDataSourceProtocol,UITableViewDataSource,UICollectionViewDataSource>
+ (instancetype)sharedInstance;
- (NSDataSource*(^)(Class registingItemClass,UITableView*tableView))registTableViewCellWithClass;
- (NSDataSource*(^)(Class registingItemClass,UICollectionView*collectionView,NSString*kind))registCollectionViewItemWithClass;

@end
 
