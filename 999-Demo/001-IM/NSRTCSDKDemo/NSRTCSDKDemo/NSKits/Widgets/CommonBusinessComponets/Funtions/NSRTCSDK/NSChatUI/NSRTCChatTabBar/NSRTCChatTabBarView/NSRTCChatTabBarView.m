//
//  NSRTCChatTabBarView.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/10/31.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCChatTabBarView.h"

#import "NSRTCChatTabBarMessageItemView.h"
#import "NSRTCChatTabBarContactsItemView.h"
#import "NSRTCChatTabBarDynamicItemView.h"

@interface NSRTCChatTabBarView ()

@property (nonatomic, strong) NSRTCChatTabBarMessageItemView *messageView;
@property (nonatomic, strong) NSRTCChatTabBarContactsItemView *contactsView;
@property (nonatomic, strong) NSRTCChatTabBarDynamicItemView *dynamicView;

@end
@implementation NSRTCChatTabBarView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupItem];
    }
    return self;
}

- (void)setupItem {
    
    self.messageView = [[NSRTCChatTabBarMessageItemView alloc] initWithOrientation:NSRTCChatTabBarSelected title:@"消息" type:NSRTCChatTabBarMessage];
    self.messageView.tag = 0;
    [self addSubview:self.messageView];
    
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.top.equalTo(self);
        //        make.width.greaterThanOrEqualTo(0);
        
    }];
    
    UITapGestureRecognizer *tapA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self.messageView addGestureRecognizer:tapA];
    
    self.contactsView = [[NSRTCChatTabBarContactsItemView alloc] initWithOrientation:NSRTCChatTabBarLeft title:@"联系人" type:NSRTCChatTabBarContacts];
    self.contactsView.tag = 1;
    [self addSubview:self.contactsView];
    [self.contactsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.messageView.mas_right);
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.messageView);
    }];
    
    UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self.contactsView addGestureRecognizer:tapB];
    
    self.dynamicView = [[NSRTCChatTabBarDynamicItemView alloc] initWithOrientation:NSRTCChatTabBarLeft title:@"我的" type:NSRTCChatTabBarDynamic];
    self.dynamicView.tag = 2;
    [self addSubview:self.dynamicView];
    [self.dynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contactsView.mas_right);
        make.top.bottom.right.equalTo(self);
        make.width.equalTo(self.contactsView);
    }];
    UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self.dynamicView addGestureRecognizer:tapC];
}

- (void)didTapView:(UITapGestureRecognizer *)tap {
    
    UIView *view = tap.view;
    NSRTCChatTabBarItemView *tapView;
    if ([view isKindOfClass:[NSRTCChatTabBarItemView class]]) {
        tapView = (NSRTCChatTabBarItemView *)view;
    }
    else {
        return;
    }
    if (tapView.orientation == NSRTCChatTabBarSelected) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:shoulSelectItemAtIndex:)]) {
        
        BOOL should = [_delegate tabBarView:self shoulSelectItemAtIndex:tapView.tag];
        if (!should) {
            return;
        }
    }
    
    if ([tapView isEqual:self.messageView]) {
        self.contactsView.orientation = NSRTCChatTabBarLeft;
        self.dynamicView.orientation = NSRTCChatTabBarLeft;
    }
    else if ([tapView isEqual:self.contactsView]) {
        self.messageView.orientation = NSRTCChatTabBarRight;
        self.dynamicView.orientation = NSRTCChatTabBarLeft;
    }
    else if ([tapView isEqual:self.dynamicView]) {
        self.messageView.orientation = NSRTCChatTabBarRight;
        self.contactsView.orientation = NSRTCChatTabBarRight;
    }
    
    tapView.orientation = NSRTCChatTabBarSelected;
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectItemAtIndex:)]) {
        [_delegate tabBarView:self didSelectItemAtIndex:tapView.tag];
    }
}




@end
