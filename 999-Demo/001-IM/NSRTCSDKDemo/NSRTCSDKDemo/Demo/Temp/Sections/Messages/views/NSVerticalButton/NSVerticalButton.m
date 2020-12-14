//
//  NSVerticalButton.m
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/12.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSVerticalButton.h"

@implementation NSVerticalButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat imgWH = self.width;
    CGFloat titleW = imgWH;
    CGFloat titleH = self.height - imgWH - 5;
    
    [self.imageView setFrame:CGRectMake(0,0,imgWH,imgWH)];
    [self.titleLabel setFrame:CGRectMake(0,imgWH+5,titleW,titleH)]; 
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
