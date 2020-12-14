//
//  NSTableView.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import <UIKit/UIKit.h>

#import "NSDataSource.h"
#import "NSDelegate.h"
#import "NSTableViewCell.h"
@interface NSTableView : UITableView
@property (strong, nonatomic) NSDataSource <UITableViewDataSource>*ns_dataSource;
@property (strong, nonatomic) NSDelegate <UITableViewDelegate>*ns_delegate;

@end
 
