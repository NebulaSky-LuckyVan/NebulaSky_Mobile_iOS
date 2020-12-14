//
//  NSDelegate.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import <UIKit/UIKit.h>
@class NSDelegate;
@protocol NSDelegateProtocol <NSObject>
 
@optional
- (void)tb_SetViewForHeader:(UIView*(^)(UITableView*tableView,NSUInteger section))headerView
           SetViewForFooter:(UIView*(^)(UITableView*tableView,NSUInteger section))footerView;

- (void)tb_SetHeightForHeader:(CGFloat(^)(UITableView*tableView,NSUInteger section))headerHeight
           SetHeightForFooter:(CGFloat(^)(UITableView*tableView,NSUInteger section))footerHeight
              SetHeightForRow:(CGFloat(^)(UITableView*tableView,NSIndexPath *indexPath))height;

- (void)tb_SetSelectResponseForRow:(void(^)(UITableView*tableView,NSIndexPath *indexPath))selectResponse
                   didSelectForRow:(void(^)(UITableView*tableView,NSIndexPath *indexPath))didSelectResponse;

- (void)col_SetSelectResponseForRow:(void(^)(UICollectionView*collectionView,NSIndexPath *indexPath))selectResponse
            didSelectResponseForRow:(void(^)(UICollectionView*collectionView,NSIndexPath *indexPath))didSelectResponse;
 
- (void)col_SetSizeForItemAtIndexPath:(CGSize(^)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSIndexPath *indexPath))ItemSize
            setInsetForSectionAtIndex:(UIEdgeInsets(^)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSUInteger section))SectionInset
   setReferenceSizeForHeaderInSection:(CGSize(^)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSUInteger section))headerSize
   setReferenceSizeForFooterInSection:(CGSize(^)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSUInteger section))footerSize;

- (void)col_SetMinimumLineSpacingForSectionAtIndex:(CGFloat(^)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSUInteger section))minLineItemSpacing
       setMinimumInteritemSpacingForSectionAtIndex:(CGFloat(^)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSUInteger section))minInterItemSpacing;

- (void)SetDidScroll:(void(^)(UIScrollView*scrollView,CGPoint contentOffset,CGSize contentSize,UIEdgeInsets contentInset))scrollUpdate;


@end
@interface NSDelegate : NSObject<NSDelegateProtocol,UICollectionViewDelegate,UITableViewDelegate,UICollectionViewDelegateFlowLayout>
+ (instancetype)sharedInstance;

@end
 
