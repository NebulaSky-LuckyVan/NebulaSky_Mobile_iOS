//
//  NSRTCAVLiveChatView.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCAVLiveChatView.h"

@interface NSRTCAVLiveChatView ()
@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) CADisplayLink *display;

@end
@implementation NSRTCAVLiveChatView

+ (instancetype)chatViewWithFrame:(CGRect)rect{
    NSRTCAVLiveChatView *chatView = [[NSRTCAVLiveChatView alloc]initWithFrame:rect];
    if (chatView) {
//        [chatView setup];
    }
    return chatView;
}
- (CADisplayLink *)display{
    if (!_display) {
        _display = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotaion)];
    }
    return _display;
}
- (void)setup{
    CGRect rect = self.bounds;
    CGFloat wh = CGRectGetWidth(rect)*1.0/3;
    rect.size = CGSizeMake(wh, wh);
    _headImgView = [[UIImageView alloc]initWithFrame:rect];
    _headImgView.center = CGPointMake(self.center.x, CGRectGetHeight(self.bounds)*1.0/3);
    [self addSubview:_headImgView];
    //添加遮罩
    UIView *maskView = [[UIView alloc]init];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.frame = _headImgView.bounds;
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    CGPoint fCirclrCenter = maskView.center;
    circleLayer.path = ([UIBezierPath bezierPathWithArcCenter:fCirclrCenter radius:maskView.width/2 startAngle:0 endAngle:2*M_PI clockwise:YES]).CGPath;
    [maskView.layer addSublayer:circleLayer];
    maskView.superview.layer.mask = circleLayer;
    [_headImgView addSubview:maskView];
    
    [self beginHeaderRotationAnimation];
}
- (void)setHeadPhoto:(UIImage *)head{
    [_headImgView setImage:head];
}
- (void)beginHeaderRotationAnimation{
    [self.display setPaused:NO];
}
- (void)stopHeaderRotationAnimation{
    [self.display setPaused:YES];
}
- (void)rotaion{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        self->_headImgView.transform = CGAffineTransformMakeRotation(M_PI/180);
    }];
}
@end
