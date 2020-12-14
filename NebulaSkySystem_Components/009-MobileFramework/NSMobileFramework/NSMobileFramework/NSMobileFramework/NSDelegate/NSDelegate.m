//
//  NSDelegate.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import "NSDelegate.h"


typedef CGFloat(^NS_Request_HeightWithIndxPath_Handler)(UITableView*view,NSIndexPath *indexPath);

typedef CGFloat(^NS_Request_HeaderFooterHeightWithSection_Handler)(UITableView*view,NSUInteger section);

typedef UIView*(^NS_Request_HeaderFooterViewWithSection_Handler)(UITableView*view,NSUInteger section);

typedef  void  (^NS_Request_tb_SelectResponseWithIndxPath_Handler)(UITableView*view,NSIndexPath *indexPath);
typedef  void  (^NS_Request_col_SelectResponseWithIndxPath_Handler)(UICollectionView*view,NSIndexPath *indexPath);

typedef  void  (^NS_Request_ScrollViewDidScroll_Handler)(UIScrollView*scrollView,CGPoint contentOffset,CGSize contentSize,UIEdgeInsets contentInset);

typedef CGSize(^NS_Request_col_SizeForItem_Handler)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSIndexPath *indexPath);
typedef UIEdgeInsets(^NS_Request_col_InsetForSection_Handler)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSUInteger section);
typedef CGSize(^NS_Request_col_SizeForHeaderFooterOfSection_Handler)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSUInteger section);
typedef CGFloat(^NS_Request_col_MinimumLineInteritemSpacingOfSection_Handler)(UICollectionView*collectionView,UICollectionViewLayout*layout,NSUInteger section);


@interface NSDelegate ()
//- (void)tb_SetViewForHeader:(UIView*(^)(UITableView*tableView,NSUInteger section))headerView
//           SetViewForFooter:(UIView*(^)(UITableView*tableView,NSUInteger section))footerView;
//
//- (void)tb_SetHeightForHeader:(CGFloat(^)(UITableView*tableView,NSUInteger section))headerHeight
//           SetHeightForFooter:(CGFloat(^)(UITableView*tableView,NSUInteger section))footerHeight
//              SetHeightForRow:(CGFloat(^)(UITableView*tableView,NSIndexPath *indexPath))height;
//
//- (void)tb_SetSelectResponseForRow:(void(^)(UITableView*tableView,NSIndexPath *indexPath))selectResponse;
@end
@interface NSDelegate () <UITableViewDelegate>
@property (copy, nonatomic) NS_Request_HeightWithIndxPath_Handler tb_requestHeightForRow;
@property (copy, nonatomic) NS_Request_tb_SelectResponseWithIndxPath_Handler tb_selectResponseForRow;
@property (copy, nonatomic) NS_Request_tb_SelectResponseWithIndxPath_Handler tb_didSelectResponseForRow;

@property (copy, nonatomic) NS_Request_HeaderFooterHeightWithSection_Handler tb_requestHeightForHeader;
@property (copy, nonatomic) NS_Request_HeaderFooterHeightWithSection_Handler tb_requestHeightForFooter;

@property (copy, nonatomic) NS_Request_HeaderFooterViewWithSection_Handler tb_requestViewForHeader;
@property (copy, nonatomic) NS_Request_HeaderFooterViewWithSection_Handler tb_requestViewForFooter;

@end
@interface NSDelegate ()<UICollectionViewDelegate>
@property (copy, nonatomic) NS_Request_col_SelectResponseWithIndxPath_Handler col_selectResponseForRow;
@property (copy, nonatomic) NS_Request_col_SelectResponseWithIndxPath_Handler col_didSelectResponseForRow;
@end

@interface NSDelegate ()
@property (copy, nonatomic) NS_Request_ScrollViewDidScroll_Handler didScrollUpdate;
@end
@interface NSDelegate ()<UICollectionViewDelegateFlowLayout>
@property (copy, nonatomic) NS_Request_col_SizeForItem_Handler itemSize;
@property (copy, nonatomic) NS_Request_col_InsetForSection_Handler sectionInset;
@property (copy, nonatomic) NS_Request_col_SizeForHeaderFooterOfSection_Handler headerSize;
@property (copy, nonatomic) NS_Request_col_SizeForHeaderFooterOfSection_Handler footerSize;
@property (copy, nonatomic) NS_Request_col_MinimumLineInteritemSpacingOfSection_Handler minLineSpacing;
@property (copy, nonatomic) NS_Request_col_MinimumLineInteritemSpacingOfSection_Handler minInteritemSpacing;
@end
@implementation NSDelegate
- (NSDelegate*(^)(CGFloat(^)(UITableView*,NSUInteger ),CGFloat(^)(UITableView*,NSUInteger ),CGFloat(^)(UITableView*,NSIndexPath *)))Set_tb_Height_For_CellHeaderFooter{
    return ^(CGFloat(^HeaderHeight)(UITableView*tableView,NSUInteger section),
             CGFloat(^FooterHeight)(UITableView*tableView,NSUInteger section),
             CGFloat(^CellHeight)(UITableView*tableView,NSIndexPath *indexPath)){
        self.tb_requestHeightForRow = [CellHeight copy];
        self.tb_requestHeightForHeader = [HeaderHeight copy];
        self.tb_requestHeightForFooter = [FooterHeight copy];
        return self;
    };
}
- (NSDelegate*(^)(UIView*(^)(UITableView*,NSUInteger ),UIView*(^)(UITableView*,NSUInteger )))Set_tb_HeaderFooterView{
    return ^(UIView*(^HeaderView)(UITableView*tableView,NSUInteger section),UIView*(^FooterView)(UITableView*tableView,NSUInteger section)){
        self.tb_requestViewForHeader = [HeaderView copy];
        self.tb_requestViewForFooter = [FooterView copy];
        return self;
    };
}
- (NSDelegate*(^)(void(^)(UITableView*,NSIndexPath *)))Set_Tb_SelectResponseHandlerForRow{
    return ^(void(^SetSelectResponseHandler)(UITableView*,NSIndexPath *)){
        self.tb_selectResponseForRow = [SetSelectResponseHandler copy];
        return self;
    }; 
}
- (NSDelegate*(^)(void(^)(UICollectionView*collectionView,NSIndexPath *indexPath)))Set_Col_SelectResponseHandlerForRow{
    return ^(void(^SetSelectResponseHandler)(UICollectionView*collectionView,NSIndexPath *indexPath)){
        self.col_selectResponseForRow = [SetSelectResponseHandler copy];
        return self;
    };
}
- (void)tb_SetViewForHeader:(NS_Request_HeaderFooterViewWithSection_Handler)headerView
             SetViewForFooter:(NS_Request_HeaderFooterViewWithSection_Handler)footerView{
    
    self.tb_requestViewForHeader = [headerView copy];
    self.tb_requestViewForFooter = [footerView copy];
}

- (void)tb_SetHeightForHeader:(NS_Request_HeaderFooterHeightWithSection_Handler)headerHeight
           SetHeightForFooter:(NS_Request_HeaderFooterHeightWithSection_Handler)footerHeight
              SetHeightForRow:(NS_Request_HeightWithIndxPath_Handler)height{
    self.tb_requestHeightForRow = [height copy];
    self.tb_requestHeightForHeader = [headerHeight copy];
    self.tb_requestHeightForFooter = [footerHeight copy];
}

- (void)tb_SetSelectResponseForRow:(NS_Request_tb_SelectResponseWithIndxPath_Handler)selectResponse didSelectForRow:(NS_Request_tb_SelectResponseWithIndxPath_Handler)didSelectResponse{
    self.tb_selectResponseForRow = [selectResponse copy];
    self.tb_didSelectResponseForRow = [didSelectResponse copy];
}
- (void)SetDidScroll:(NS_Request_ScrollViewDidScroll_Handler)scrollUpdate{
    self.didScrollUpdate = [scrollUpdate copy];
}
#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.tb_selectResponseForRow?:self.tb_selectResponseForRow(tableView,indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.tb_didSelectResponseForRow?:self.tb_didSelectResponseForRow(tableView,indexPath);
}
// Variable height support
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return !self.tb_requestHeightForRow?0:self.tb_requestHeightForRow(tableView,indexPath);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return !self.tb_requestHeightForHeader?0:self.tb_requestHeightForHeader(tableView,section);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return !self.tb_requestHeightForFooter?0:self.tb_requestHeightForFooter(tableView,section);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return !self.tb_requestViewForHeader?nil:self.tb_requestViewForHeader(tableView,section);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return !self.tb_requestViewForFooter?nil:self.tb_requestViewForFooter(tableView,section);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    CGSize contentSize = scrollView.contentSize;
    UIEdgeInsets contentInset = scrollView.contentInset;
    !self.didScrollUpdate?:self.didScrollUpdate(scrollView,contentOffset,contentSize,contentInset);
}

#pragma UICollectionViewDelegate
- (void)col_SetSelectResponseForRow:(NS_Request_col_SelectResponseWithIndxPath_Handler)selectResponse didSelectResponseForRow:(NS_Request_col_SelectResponseWithIndxPath_Handler)didSelectResponse {
    self.col_selectResponseForRow = [selectResponse copy];
    self.col_didSelectResponseForRow  = [didSelectResponse copy];
}
- (void)col_SetSizeForItemAtIndexPath:(NS_Request_col_SizeForItem_Handler)ItemSize
            setInsetForSectionAtIndex:(NS_Request_col_InsetForSection_Handler)SectionInset
   setReferenceSizeForHeaderInSection:(NS_Request_col_SizeForHeaderFooterOfSection_Handler)headerSize
   setReferenceSizeForFooterInSection:(NS_Request_col_SizeForHeaderFooterOfSection_Handler)footerSize{
    self.itemSize = [ItemSize copy];
    self.sectionInset = [SectionInset copy];
    self.headerSize = [headerSize copy];
    self.footerSize = [footerSize copy];
}

- (void)col_SetMinimumLineSpacingForSectionAtIndex:(NS_Request_col_MinimumLineInteritemSpacingOfSection_Handler)minLineItemSpacing
       setMinimumInteritemSpacingForSectionAtIndex:(NS_Request_col_MinimumLineInteritemSpacingOfSection_Handler)minInterItemSpacing{
    self.minLineSpacing = [minLineItemSpacing copy];
    self.minInteritemSpacing = [minInterItemSpacing copy];
}
 

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    !self.col_selectResponseForRow?:self.col_selectResponseForRow(collectionView,indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    !self.col_didSelectResponseForRow?:self.col_didSelectResponseForRow(collectionView,indexPath);
}


 
//  UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return !self.itemSize?CGSizeZero:self.itemSize(collectionView,collectionViewLayout,indexPath);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return !self.sectionInset?UIEdgeInsetsZero:self.sectionInset(collectionView,collectionViewLayout,section);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return !self.minLineSpacing?0:self.minLineSpacing(collectionView,collectionViewLayout,section);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return !self.minLineSpacing?0:self.minLineSpacing(collectionView,collectionViewLayout,section);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return !self.headerSize?CGSizeZero:self.headerSize(collectionView,collectionViewLayout,section);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return !self.footerSize?CGSizeZero:self.footerSize(collectionView,collectionViewLayout,section);
}

  





/*
 [[NSDelegate sharedInstance]tb_HeightForRow:^CGFloat(UIView *view, NSIndexPath *indexPath) {
    return 0;
 } SelectRespomseForRow:^(UIView *view, NSIndexPath *indexPath) {
    return nil;
 }];
 [[NSDelegate sharedInstance]tb_HeightForHeader:^CGFloat(UIView *view, NSUInteger section) {
    return 0;
 } heightForFooter:^CGFloat(UIView *view, NSUInteger section) {
    return 0;
 } viewForHeader:^UIView *(UIView *view, NSUInteger section) {
    return nil;
 } viewForFooter:^UIView *(UIView *view, NSUInteger section) {
    return nil;
 }];
 */



+ (instancetype)sharedInstance{
    return [[self alloc]init];
}

@end
