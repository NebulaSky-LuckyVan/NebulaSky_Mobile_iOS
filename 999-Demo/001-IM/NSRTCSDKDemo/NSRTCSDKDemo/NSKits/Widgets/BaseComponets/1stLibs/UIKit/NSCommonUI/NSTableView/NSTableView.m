//
//  NSTableView.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import "NSTableView.h"

@implementation NSTableView

- (NSDataSource *)ns_dataSource{
    if (!_ns_dataSource) {
        _ns_dataSource = [NSDataSource sharedInstance];
    }
    return _ns_dataSource;
}
- (NSDelegate *)ns_delegate{
    if (!_ns_delegate) {
        _ns_delegate = [NSDelegate sharedInstance];
    }
    return _ns_delegate;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.tableHeaderView = [[UIView alloc]init];
        self.tableFooterView = [[UIView alloc]init];
        
        self.showsVerticalScrollIndicator  = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        self.estimatedRowHeight = UITableViewAutomaticDimension;
        
        self.ns_dataSource
        .registTableViewCellWithClass([UITableViewCell class],self)
        .registTableViewCellWithClass([UITableViewHeaderFooterView class],self);
        self.dataSource = self.ns_dataSource;
        self.delegate = self.ns_delegate;
        
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // Remove touch delay (since iOS 8)
        UIView *wrapView = self.subviews.firstObject;
        // UITableViewWrapperView
        if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
            for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
                // UIScrollViewDelayedTouchesBeganGestureRecognizer
                if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                    gesture.enabled = NO;
                    break;
                }
            }
        }
        
    }
    return self;
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

//    self.tableView.ns_dataSource
//    .registTableViewCellWithClass([UITableViewCell class],self.tableView);
//
//    [self.tableView.ns_dataSource tb_SetNumberOfSections:^NSUInteger(UITableView *tableView) {
//        return 1;
//    } setNumberOfRows:^NSUInteger(UITableView *tableView, NSUInteger section) {
//        return 5;
//    } setCellForRow:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//        TempTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TempTableViewCell  reuseIdentifier]];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        return cell;
//    }];
//
//
//    [self.tableView.ns_delegate tb_SetHeightForHeader:^CGFloat(UITableView *tableView, NSUInteger section) {
//        return 0;
//    } SetHeightForFooter:^CGFloat(UITableView *tableView, NSUInteger section) {
//        return 0;
//    } SetHeightForRow:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
//        CGFloat rowHeight = 425;
//        return rowHeight;
//    }];
//    [self.tableView.ns_delegate tb_SetViewForHeader:^UIView *(UITableView *tableView, NSUInteger section) {
//        return nil;
//    } SetViewForFooter:^UIView *(UITableView *tableView, NSUInteger section) {
//        return nil;
//    }];
//
//    [self.tableView.ns_delegate tb_SetSelectResponseForRow:^(UITableView *tableView, NSIndexPath *indexPath) {
//        NSLog(@"%s",__func__);
//    }];
@end
