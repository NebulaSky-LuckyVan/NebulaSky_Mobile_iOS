//
//  NSCommonUIFactory.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import "NSCommonUIFactory.h" 
typedef void(^CallTbDataSourceSettingHandler)(NSTableView *tableView,NSDataSource*datasource);
typedef void(^CallTbDelegateSettingHandler)(NSTableView *tableView,NSDelegate*delegate);


typedef void(^CallColDataSourceSettingHandler)(NSCollectionView *collectionView,NSDataSource*datasource);
typedef void(^CallColDelegateSettingHandler)(NSCollectionView *collectionView,NSDelegate*delegate);

@interface NSCommonUIFactory ()
//Desc:
@property (strong, nonatomic) NSCollectionView *collectionView;
@end
@implementation NSCommonUIFactory
+ (NSTableView*)tableViewWithSuperView:(UIView*)superView datasource:(CallTbDataSourceSettingHandler)datasourceHandlerBlock delegate:(CallTbDelegateSettingHandler)delegateHandlerBlock{
    NSTableView *tableView =  [[NSTableView alloc]initWithFrame:superView.bounds style:UITableViewStyleGrouped];
    [superView addSubview:tableView];
    !datasourceHandlerBlock?:datasourceHandlerBlock(tableView,tableView.ns_dataSource);
    !delegateHandlerBlock?:delegateHandlerBlock(tableView,tableView.ns_delegate); 
    return  tableView;
}
+ (void)tableView:(NSTableView*)tableView datasource:(CallTbDataSourceSettingHandler)datasourceHandlerBlock delegate:(CallTbDelegateSettingHandler)delegateHandlerBlock{
    !datasourceHandlerBlock?:datasourceHandlerBlock(tableView,tableView.ns_dataSource);
    !delegateHandlerBlock?:delegateHandlerBlock(tableView,tableView.ns_delegate);
}


+ (NSCollectionView*)collectionViewWithSuperView:(UIView*)superView collectionViewLayout:(UICollectionViewLayout*)layout datasource:(CallColDataSourceSettingHandler)datasourceHandlerBlock delegate:(CallColDelegateSettingHandler)delegateHandlerBlock{ 
    NSCollectionView *collectionView =  [[NSCollectionView alloc]initWithFrame:superView.bounds collectionViewLayout:layout];
    [superView addSubview:collectionView];
    !datasourceHandlerBlock?:datasourceHandlerBlock(collectionView,collectionView.ns_dataSource);
    !delegateHandlerBlock?:delegateHandlerBlock(collectionView,collectionView.ns_delegate);
    return  collectionView;
}

+ (void)collectionView:(NSCollectionView*)collectionView datasource:(CallColDataSourceSettingHandler)datasourceHandlerBlock delegate:(CallColDelegateSettingHandler)delegateHandlerBlock{
    !datasourceHandlerBlock?:datasourceHandlerBlock(collectionView,collectionView.ns_dataSource);
    !delegateHandlerBlock?:delegateHandlerBlock(collectionView,collectionView.ns_delegate);
}
  
// 设置手势
+ (void)configItemMoveWithCollectionView:(NSCollectionView*)collectionView{
    [NSCommonUIFactory sharedInstance].collectionView = collectionView;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:[NSCommonUIFactory sharedInstance] action:@selector(handlelongGesture:)];

    [[NSCommonUIFactory sharedInstance].collectionView addGestureRecognizer:longPress];
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
     
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [[NSCommonUIFactory sharedInstance].collectionView indexPathForItemAtPoint:[longGesture locationInView:[NSCommonUIFactory sharedInstance].collectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [[NSCommonUIFactory sharedInstance].collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [[NSCommonUIFactory sharedInstance].collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:[NSCommonUIFactory sharedInstance].collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [[NSCommonUIFactory sharedInstance].collectionView endInteractiveMovement];
            break;
        default:
            [[NSCommonUIFactory sharedInstance].collectionView cancelInteractiveMovement];
            break;
    }
}


//===============SingleTon====================//
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopy{
    return _instance;
}
- (id)copy{
    return _instance;
}
+ (instancetype)sharedInstance{
    return [[self alloc]init];
}
//===================================//
@end
