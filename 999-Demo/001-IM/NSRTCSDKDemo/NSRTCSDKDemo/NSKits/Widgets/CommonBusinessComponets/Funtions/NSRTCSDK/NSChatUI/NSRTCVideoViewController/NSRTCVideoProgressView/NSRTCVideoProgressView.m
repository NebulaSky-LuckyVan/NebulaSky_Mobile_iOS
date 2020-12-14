//
//  NSRTCVideoProgressView.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCVideoProgressView.h"


//#import <NSRTC/UIView+Common.h>


//#import "UIView+Common.h"

@interface NSRTCVideoProgressView ()
/**
 进度值0-1.0
 */
@property (nonatomic, assign) CGFloat progressValue;

@property (nonatomic, assign) CGFloat currentTime;

@end
@implementation NSRTCVideoProgressView



- (void)clearProgress {
    _currentTime = _timeMax;
    self.hidden = YES;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 中心
    CGPoint center = CGPointMake(self.width/2.0, self.width/2.0);
    // 半径
    CGFloat radius = self.width/2.0 - 5;
    // 起始半径
    CGFloat startA = -M_PI_2;
    // 终点半径
    CGFloat endA = -M_PI_2 + _progressValue*M_PI*2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineWidth(context, 10);
    [[UIColor whiteColor] setStroke];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}

- (void)setTimeMax:(NSInteger)timeMax {
    _timeMax = timeMax;
    _currentTime = 0;
    _progressValue = 0;
    NSLog(@"==========================");
    [self setNeedsDisplay];
    self.hidden = NO;
    [self performSelector:@selector(startProgress) withObject:nil afterDelay:0.1];
}

- (void)startProgress {
    
    _currentTime += 0.1;
    if (_timeMax > _currentTime) {
        _progressValue = _currentTime/_timeMax;
        [self setNeedsDisplay];
        NSLog(@"progressValue===%lf", _progressValue);
        [self performSelector:@selector(startProgress) withObject:nil afterDelay:0.1];
    }
    if (_timeMax < _currentTime) {
        
        [self clearProgress];
    }
}



@end
