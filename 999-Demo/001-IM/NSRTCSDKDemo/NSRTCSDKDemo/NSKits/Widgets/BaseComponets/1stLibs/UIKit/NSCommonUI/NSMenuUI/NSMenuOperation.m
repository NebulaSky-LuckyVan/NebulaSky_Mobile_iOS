//
//  NSMenuOperation.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/9.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSMenuOperation.h"
#import "NSMenuView.h"

@interface NSMenuOperation ()
@property (nonatomic, strong) NSMutableArray<NSMenuItem *> *menuItems;
@property (nonatomic, weak) NSMenuView *menuView;
@property (nonatomic, assign) BOOL observing;

@end
@implementation NSMenuOperation

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.menuItems = [NSMutableArray array];
        self.titleFont = [UIFont boldSystemFontOfSize:16];
        self.arrowHight = 8.f;
        self.menuCornerRadiu = 5.f;
        self.edgeInsets = UIEdgeInsetsMake(1, 10, 1, 10);
        self.minMenuItemHeight = 35.f; //item的最小高度
        self.minMenuItemWidth = 32.f; //item的最小宽度
        self.gapBetweenImageTitle = 5.f;
        self.menuSegmenteLineStyle = NSMenuSegmenteLineStylefollowContent;
        self.menuBackgroundStyle = NSMenuBackgroundStyleDark;
        self.showShadow = YES;
    }
    return self;
}

- (instancetype)initWithItems:(NSArray<NSMenuItem *> *)items{
    self = [self init];
    if (self) {
        [self.menuItems addObjectsFromArray:items];
    }
    return self;
}
- (instancetype)initWithItems:(NSArray<NSMenuItem *> *)items BackgroundStyle:(NSMenuBackgroundStyle)backgroundStyle{
    self = [self init];
    if (self) {
        [self.menuItems addObjectsFromArray:items];
        self.menuBackgroundStyle = backgroundStyle;
    }
    return self;
}

- (void) dealloc
{
    if (_observing) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)addMenuItem:(NSMenuItem *)menuItem{
    [self.menuItems addObject:menuItem];
}

- (void) orientationWillChange: (NSNotification *)note
{
    [self dismissMenu];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view{
    NSParameterAssert(view);
    NSParameterAssert(self.menuItems.count);
    
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        _observing = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    
    NSMenuView *menuView = [[NSMenuView alloc] init];
    [view addSubview:menuView];
    _menuView = menuView;
    [menuView showMenuInView:view fromRect:rect menu:self menuItems:self.menuItems];
}

- (void)showFromNavigationController:(UINavigationController *)navigationController WithX:(CGFloat)x{
    CGRect rect = CGRectMake(x, 64, 1, 1);
    [self showFromRect:rect inView:navigationController.view];
}
- (void)showFromTabBarController:(UITabBarController *)tabBarController WithX:(CGFloat)x{
    CGRect rect = CGRectMake(x, [UIScreen mainScreen].bounds.size.height-49, 1, 1);
    [self showFromRect:rect inView:tabBarController.view];
}

- (void) dismissMenu
{
    if (_menuView) {
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    if (_observing) {
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
@end
