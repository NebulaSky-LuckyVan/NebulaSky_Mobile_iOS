//
//  NSRTCPlaceholderTextView.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCPlaceholderTextView.h"



@interface NSRTCPlaceholderTextView ()
@property (nonatomic, strong) UILabel *placeHolderLabel;

@end
@implementation NSRTCPlaceholderTextView

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION_XHPT = 0.25;
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _placeholder = @"";
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}


- (void)textChanged:(NSNotification *)notification {
    if (self.placeholder.length == 0) {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION_XHPT animations:^{
        
        if([[self text] length] == 0)
        {
            [[self viewWithTag:999] setAlpha:1];
        }
        else
        {
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect {
    if (self.placeholder.length > 0) {
        
        UIEdgeInsets insets = self.textContainerInset;
        if (_placeHolderLabel == nil )
        {
            
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets.left+5,insets.top,self.bounds.size.width - (insets.left +insets.right+10),1.0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [_placeHolderLabel setFrame:CGRectMake(insets.left+5,insets.top,self.bounds.size.width - (insets.left +insets.right+10),CGRectGetHeight(_placeHolderLabel.frame))];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}
- (void)setPlaceholder:(NSString *)placeholder{
    if (_placeholder != placeholder) {
        _placeholder = placeholder;
        [self setNeedsDisplay];
    }
    
}

@end
