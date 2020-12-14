//
//  ViewController.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import "ViewController.h"

#import "NSCommonUIFactory.h"
@interface ViewController ()
@property (strong, nonatomic) NSCollectionView *collectionView;

@end

@implementation ViewController
 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView = [NSCommonUIFactory collectionViewWithSuperView:self.view collectionViewLayout:[[UICollectionViewFlowLayout alloc]init] datasource:^(NSCollectionView *collectionView, NSDataSource *datasource) {
        datasource.registCollectionViewItemWithClass([NSCollectionViewCell class],collectionView,@"")
        .registCollectionViewItemWithClass([UICollectionReusableView class],collectionView,UICollectionElementKindSectionHeader)
        .registCollectionViewItemWithClass([UICollectionReusableView class],collectionView,UICollectionElementKindSectionFooter);
        [datasource col_SetNumberOfSections:^NSUInteger(UICollectionView *collecitonView) {
            return 3;
        } setNumberOfRows:^NSUInteger(UICollectionView *collecitonView, NSUInteger section) {
            return 88 ;
        } setItemForRow:^UICollectionViewCell *(UICollectionView *collecitonView, NSIndexPath *indexPath) {
            NSCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:[NSCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
            item.contentView.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256)/255.0) green:(arc4random_uniform(256)/255.0) blue:(arc4random_uniform(256)/255.0) alpha:1.0];
            return item;
            
        }];
        [datasource col_SetSupplementaryElementViewAtIndexPath:^UICollectionReusableView *(UICollectionView *collecitonView, NSCollectionViewSupplementaryElementKind kind, NSIndexPath *indexPath) {
            UICollectionReusableView *reusableView = [collecitonView dequeueReusableSupplementaryViewOfKind:kind==NSC_SupplementaryElement_Header?UICollectionElementKindSectionHeader:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            reusableView.backgroundColor =  kind==NSC_SupplementaryElement_Header?[UIColor redColor]:[UIColor orangeColor];
            return reusableView;
        }];
        [datasource col_SetItemMoveSwitchOfIndexPath:^BOOL(UICollectionView *collecitonView, NSIndexPath *indexPath) {
            return YES;
        } setItemMoveFromIndexPathToIndexPath:^(UICollectionView *collecitonView, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath) {
            NSLog(@"from:%@,to:%@",sourceIndexPath,destinationIndexPath);
        }];
    } delegate:^(NSCollectionView *collectionView, NSDelegate *delegate) {
        [delegate col_SetSelectResponseForRow:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
            NSLog(@"%s",__func__);
        } didSelectResponseForRow:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
            NSLog(@"%s",__func__);
        }];
        [delegate SetDidScroll:^(UIScrollView *scrollView, CGPoint contentOffset, CGSize contentSize, UIEdgeInsets contentInset) {
            NSLog(@"%s",__func__);
        }];
        [delegate col_SetSizeForItemAtIndexPath:^CGSize(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath) {
            return CGSizeMake(50, 50);
        } setInsetForSectionAtIndex:^UIEdgeInsets(UICollectionView *collectionView, UICollectionViewLayout *layout, NSUInteger section) {
            return UIEdgeInsetsMake(10, 5, 10, 5);
        } setReferenceSizeForHeaderInSection:^CGSize(UICollectionView *collectionView, UICollectionViewLayout *layout, NSUInteger section) {
            return CGSizeMake(self.view.frame.size.width, 20);
        } setReferenceSizeForFooterInSection:^CGSize(UICollectionView *collectionView, UICollectionViewLayout *layout, NSUInteger section) {
            return CGSizeMake(self.view.frame.size.width, 40);
        }];
    }];
    [NSCommonUIFactory configItemMoveWithCollectionView:self.collectionView];
    
}

@end
