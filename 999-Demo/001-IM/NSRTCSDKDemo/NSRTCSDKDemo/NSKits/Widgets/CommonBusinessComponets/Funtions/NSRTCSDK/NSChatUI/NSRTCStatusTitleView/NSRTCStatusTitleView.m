//
//  NSRTCStatusTitleView.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCStatusTitleView.h"
 
@interface NSRTCStatusTitleView ()

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end
@implementation NSRTCStatusTitleView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = [UIColor blackColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_statusLabel];
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    _indicator.x = 0;
    _indicator.y = (self.height - _indicator.height) / 2.0;
    [self addSubview:_indicator];
    
    [self updateWithLinkStatus:[NSRTCClient status]];
}

- (void)updateWithLinkStatus:(ClientStatus)status {
    
    switch (status) {
        case NSRTCClientStatus_NotConnected:{
            
            [_indicator stopAnimating];
            _statusLabel.text = @"YNETChat(未连接)";
            break;
        }
            
        case NSRTCClientStatus_Disconnected:{
            
            [_indicator stopAnimating];
            _statusLabel.text = @"YNETChat(连接断开)";
            break;
        }
            
        case NSRTCClientStatus_Connecting:{
            
            [_indicator startAnimating];
            _statusLabel.text = @"YNETChat(连接中...)";
            break;
        }
            
        case NSRTCClientStatus_Connected:{
            
            [_indicator stopAnimating];
            _statusLabel.text = @"YNETChat";
            break;
        }
            
        default:
            break;
    }
    
    [_statusLabel sizeToFit];
    _statusLabel.height = self.height;
    
    if (_indicator.isAnimating) {
        CGFloat offset = (self.width - _statusLabel.width - _indicator.width)/2.0;
        _indicator.x = offset;
        _statusLabel.x = _indicator.maxX;
    }
    else {
        _statusLabel.x = (self.width - _statusLabel.width)/2.0;
    }
    
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    NSLog(@"????????????????===%lf", self.width);
    
}


@end
