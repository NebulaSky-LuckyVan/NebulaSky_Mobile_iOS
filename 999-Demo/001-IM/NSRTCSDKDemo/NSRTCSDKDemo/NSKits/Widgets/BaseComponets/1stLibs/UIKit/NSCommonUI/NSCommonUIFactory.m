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
+ (NSMenuOperation*)menuWithItemTitles:(NSArray<NSString*>*)titles itemActionHandler:(NSArray<CommonMenuItemHandler>*)actions{
    return [NSCommonUIFactory menuWithItemTitles:titles itemImages:nil itemActionHandler:actions];
}
+ (NSMenuOperation*)menuWithItemImages:(NSArray<UIImage*>*)imgs itemActionHandler:(NSArray<CommonMenuItemHandler>*)actions{
    return [NSCommonUIFactory menuWithItemTitles:nil itemImages:imgs itemActionHandler:actions];
}
+ (NSMenuOperation*)menuWithItemTitles:(NSArray<NSString*>*)titles itemImages:(NSArray<UIImage*>*)imgs itemActionHandler:(NSArray<CommonMenuItemHandler>*)actions{
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    if (titles.count==actions.count) {
        for (int i = 0; i<titles.count; i++) {
            NSMenuItem*itm = [NSMenuItem itemWithImage:!imgs?nil:imgs[i]
                                                 title:!titles?@"":titles[i]
                                                action:!actions?NULL:actions[i]];
            [menuItems addObject:itm];
        }
    }
    NSMenuOperation *menu = [[NSMenuOperation alloc] initWithItems:menuItems];
    menu.minMenuItemHeight = 45;
    menu.menuCornerRadiu = 3;
    menu.showShadow = YES;
    menu.menuBackGroundColor = ColorFromHex(0xFFFFFF);
    menu.segmenteLineColor = ColorFromHexA(0x333333, 0.3);
    menu.menuBackgroundStyle = NSMenuBackgroundStyleLight;
    menu.menuSegmenteLineStyle = NSMenuSegmenteLineStylefollowContent;
    return menu;
}
+ (void)showNavigationMenu:(NSMenuOperation*)menu withMenuBarPoisition:(NSMenuBarPosition)position{
    CGRect rect = CGRectZero;
    switch (position) {
        case NSMenuBarPosition_Left:{
            rect = CGRectMake(10, 0, 60, 100);
        }break;
        case NSMenuBarPosition_Center:{
            rect = CGRectMake((kScreenWidth-60)/2.0, 0, 60, 100);
        }break;
        case NSMenuBarPosition_Right:{
            rect = CGRectMake(kScreenWidth-70, 0, 60, 100);
        }break;
        default:
            break;
    } 
    
    [menu showFromRect:rect inView:kKeyWindow];
}
+ (void)showTabBarMenu:(NSMenuOperation*)menu withMenuBarPoisition:(NSMenuBarPosition)position{
    CGRect rect = CGRectZero;
    switch (position) {
        case NSMenuBarPosition_Left:{
            rect = CGRectMake(10, kScreenHeight-85, 60, 100);
        }break;
        case NSMenuBarPosition_Center:{
            rect = CGRectMake((kScreenWidth-60)/2.0, kScreenHeight-85, 60, 100);
        }break;
        case NSMenuBarPosition_Right:{
            rect = CGRectMake(kScreenWidth-70, kScreenHeight-85, 60, 100);
        }break;
        default:
            break;
    }
    [menu showFromRect:rect inView:kKeyWindow];
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
