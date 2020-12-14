//
//  NSCollectionView.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import <UIKit/UIKit.h>

#import "NSDataSource.h"
#import "NSDelegate.h"
#import "NSCollectionViewFlowLayout.h"
#import "NSCollectionViewCell.h"
@interface NSCollectionView : UICollectionView
@property (strong, nonatomic) NSDataSource <UICollectionViewDataSource>*ns_dataSource;
@property (strong, nonatomic) NSDelegate <UICollectionViewDelegate>*ns_delegate;

 



@end
 
