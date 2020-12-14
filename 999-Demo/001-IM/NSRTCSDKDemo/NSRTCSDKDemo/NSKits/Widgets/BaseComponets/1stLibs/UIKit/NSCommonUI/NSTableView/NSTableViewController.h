//
//  NSTableViewController.h
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/27.
//

#import "NSViewController.h"
#import "NSTableView.h"

@interface NSTableViewController : NSViewController
//Desc:
@property (strong, nonatomic) NSTableView *tableView;

- (void)dataSouece:(void(^)(NSTableView *tableView,NSDataSource*datasource))datasourceHandlerBlock delegate:(void(^)(NSTableView *tableView,NSDelegate*delegate))delegateHandlerBlock;

@end
