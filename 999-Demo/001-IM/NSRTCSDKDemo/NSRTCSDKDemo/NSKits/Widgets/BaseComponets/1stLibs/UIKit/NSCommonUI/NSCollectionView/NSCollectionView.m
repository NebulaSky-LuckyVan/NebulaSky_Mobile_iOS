//
//  NSCollectionView.m
//  NSCommonUI
//
//  Created by VanZhang on 2020/11/26.
//

#import "NSCollectionView.h" 
@implementation NSCollectionView
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
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.showsVerticalScrollIndicator  = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.ns_dataSource
        .registCollectionViewItemWithClass([UICollectionViewCell class],self,@"");

        self.dataSource = self.ns_dataSource;
        self.delegate = self.ns_delegate;
        
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = YES;
        
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
@end
