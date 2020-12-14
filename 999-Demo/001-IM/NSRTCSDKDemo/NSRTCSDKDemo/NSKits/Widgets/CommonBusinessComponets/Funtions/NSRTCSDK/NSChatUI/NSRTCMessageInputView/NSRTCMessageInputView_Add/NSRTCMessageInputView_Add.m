//
//  NSRTCMessageInputView_Add.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCMessageInputView_Add.h"

//#import <NSRTC/NSRTCConversation.h>
//#import "NSRTCConversation.h"
@implementation NSRTCMessageInputView_Add
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHex:0xefefef];
        UIButton *photoItem = [self buttonWithImageName:@"icon_zp" title:@"照片" index:0];
        UIButton *cameraItem = [self buttonWithImageName:@"icon_ps" title:@"拍摄" index:1];
        UIButton *locationItem = [self buttonWithImageName:@"icon_wz" title:@"位置" index:2];
        UIButton *liveItem = [self buttonWithImageName:@"icon_zb" title:@"直播" index:3];
        UIButton *videoItem = [self buttonWithImageName:@"icon_spth" title:@"视频通话" index:4];
        UIButton *audioItem = [self buttonWithImageName:@"icon_yyth" title:@"语音通话" index:5];
        UIButton *shareScreenItem = [self buttonWithImageName:@"icon_pmfx" title:@"屏幕分享" index:6];
        [self addSubview:photoItem];
        [self addSubview:cameraItem];
        [self addSubview:locationItem];
        [self addSubview:liveItem];
        [self addSubview:videoItem];
        [self addSubview:audioItem];
        [self addSubview:shareScreenItem];
    }
    return self;
}

- (UIButton *)buttonWithImageName:(NSString *)imageName title:(NSString *)title index:(NSInteger)index{
    CGFloat itemWidth = (kScreenWidth- 2*kMargin)/4;
    CGFloat itemHeight = 90;
    CGFloat iconWidth = 57;
    CGFloat leftX = kMargin, topY = 10;
    NSUInteger idx = 0;
    idx  += index;
    if (idx>=4) {
        idx-=4;
        topY = 10 * 2 + itemHeight;
    }
    UIButton *addItem = [[UIButton alloc] initWithFrame:CGRectMake(leftX +idx*itemWidth +(itemWidth -iconWidth)/2, topY, iconWidth, itemHeight)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHex:0x666666];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((iconWidth - titleLabel.width)/2.0, itemHeight - 20, titleLabel.width, 20);
    [addItem addSubview:titleLabel];
    
    [addItem setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 15, 0)];
    [addItem setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    addItem.tag = 2000+index;
    [addItem addTarget:self action:@selector(clickedItem:) forControlEvents:UIControlEventTouchUpInside];
    return addItem;
}

- (void)clickedItem:(UIButton *)sender{
    NSInteger index = sender.tag - 2000;
    if (_addIndexBlock) {
        _addIndexBlock(index);
    }
}
@end
