//
//  NSRTCMessageInputView.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCMessageInputView.h"

#import "AGEmojiKeyBoardView.h"


#import "NSRTCPlaceholderTextView.h"


#import "NSRTCMessageInputView_Voice.h"
#import "NSRTCMessageInputView_Add.h"

#define kKeyboardView_Height 216.0
#define kMessageInputView_Height 50.0
#define kMessageInputView_HeightMax 120.0
#define kMessageInputView_PadingHeight 7.0
#define kMessageInputView_Width_Tool 35.0
#define kMessageInputView_MediaPadding 1.0

@interface NSRTCMessageInputView()<AGEmojiKeyboardViewDelegate, AGEmojiKeyboardViewDataSource>

@property (strong, nonatomic) AGEmojiKeyboardView *emojiKeyboardView;
@property (strong, nonatomic) NSRTCMessageInputView_Voice *voiceKeyboardView;
@property (strong, nonatomic) NSRTCMessageInputView_Add *addKeyboardView;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *arrowKeyboardButton;
@property (nonatomic, strong) UIButton *emotionButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSRTCPlaceholderTextView *inputTextView;
@property (nonatomic, assign) CGFloat viewHeightOld;
@property (nonatomic, assign) NSRTCMessageInputViewState inputState;

@end

@implementation NSRTCMessageInputView

#pragma mark - LifeCircle
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.inputTextView removeObserver:self forKeyPath:@"contentSize"];
}
- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, kScreenHeight - kMessageInputView_Height - HOME_INDICATOR_HEIGHT, kScreenWidth, kMessageInputView_Height)]) {
        
        [self setupUI];
        _viewHeightOld = self.height;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [self.inputTextView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
    
    // topLine
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    line.backgroundColor = [UIColor colorWithHex:0xD8DDE4];
    [self addSubview:line];
    
    // voiceButton
    _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(7, (kMessageInputView_Height - kMessageInputView_Width_Tool)/2, kMessageInputView_Width_Tool, kMessageInputView_Width_Tool)];
    
    [_voiceButton setImage:[UIImage imageNamed:@"icon_yy"] forState:UIControlStateNormal];
    [_voiceButton addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voiceButton];
    
    // emotionButton
    _emotionButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 15.0/2 - 2 * kMessageInputView_Width_Tool, (kMessageInputView_Height - kMessageInputView_Width_Tool)/2, kMessageInputView_Width_Tool, kMessageInputView_Width_Tool)];
    [_emotionButton setImage:[UIImage imageNamed:@"icon_bq"] forState:UIControlStateNormal];
    [_emotionButton addTarget:self action:@selector(emotionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_emotionButton];
    
    // addButton
    _addButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 15.0/2 -kMessageInputView_Width_Tool, (kMessageInputView_Height - kMessageInputView_Width_Tool)/2, kMessageInputView_Width_Tool, kMessageInputView_Width_Tool)];
    [_addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addButton];
    
    // arrowKeyboardButton
    _arrowKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _arrowKeyboardButton.frame = CGRectMake(0, 0, kMessageInputView_Width_Tool, kMessageInputView_Width_Tool);
    [_arrowKeyboardButton setImage:[UIImage imageNamed:@"keyboard_arrow_down"] forState:UIControlStateNormal];
    [_arrowKeyboardButton addTarget:self action:@selector(arrowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_arrowKeyboardButton];
    _arrowKeyboardButton.hidden = YES;
    
    
    _voiceKeyboardView = [[NSRTCMessageInputView_Voice alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kKeyboardView_Height)];
    __weak typeof(self) weakSelf = self;
    _voiceKeyboardView.recordSuccessfully = ^(NSString *file, NSTimeInterval duration){
        
        NSLog(@"%@", file);
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(messageInputView:sendVoice:duration:)]) {
            [weakSelf.delegate messageInputView:weakSelf sendVoice:file duration:duration];
        }
    };
    
    _emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kKeyboardView_Height) dataSource:self showBigEmotion:YES];
    _emojiKeyboardView.delegate = self;
    [_emojiKeyboardView setY:kScreenHeight];
    
    
    _addKeyboardView = [[NSRTCMessageInputView_Add alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kKeyboardView_Height)];
    _addKeyboardView.addIndexBlock = ^(NSInteger index){
        if ([weakSelf.delegate respondsToSelector:@selector(messageInputView:addIndexClicked:)]) {
            [weakSelf.delegate messageInputView:weakSelf addIndexClicked:index];
        }
    };
    // contentView
    CGFloat contentViewHeight = kMessageInputView_Height -2*kMessageInputView_PadingHeight;
    _contentView = [[UIScrollView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _contentView.layer.cornerRadius = contentViewHeight/2;
    _contentView.layer.masksToBounds = YES;
    _contentView.alwaysBounceVertical = YES;
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat left = 7+kMessageInputView_Width_Tool+7;
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(kMessageInputView_PadingHeight, left, kMessageInputView_PadingHeight, 15 + 2 *kMessageInputView_Width_Tool));
    }];
    // inputTextView
    _inputTextView = [[NSRTCPlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 15 - 2 *kMessageInputView_Width_Tool - (7+kMessageInputView_Width_Tool+7), contentViewHeight)];
    _inputTextView.font = [UIFont systemFontOfSize:16];
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.scrollsToTop = NO;
    _inputTextView.delegate = self;
    
    //输入框缩进
    UIEdgeInsets insets = _inputTextView.textContainerInset;
    insets.left += 8.0;
    insets.right += 8.0;
    _inputTextView.textContainerInset = insets;
    
    [self.contentView addSubview:_inputTextView];
}
#pragma mark - Public

- (BOOL)isAndResignFirstResponder{
    if (self.inputState == NSRTCMessageInputViewStateAdd || self.inputState == NSRTCMessageInputViewStateEmotion || self.inputState == NSRTCMessageInputViewStateVoice) {
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [_emojiKeyboardView setY:kScreenHeight];
            [_addKeyboardView setY:kScreenHeight];
            [_voiceKeyboardView setY:kScreenHeight];
            
            [self setY:kScreenHeight - CGRectGetHeight(self.frame) - HOME_INDICATOR_HEIGHT];
            
        } completion:^(BOOL finished) {
            self.inputState = NSRTCMessageInputViewStateSystem;
        }];
        return YES;
    }else{
        if ([_inputTextView isFirstResponder]) {
            [_inputTextView resignFirstResponder];
            return YES;
        }else{
            return NO;
        }
    }
}
- (void)prepareToShow {
    
    [kKeyWindow addSubview:_voiceKeyboardView];
    [kKeyWindow addSubview:_emojiKeyboardView];
    [kKeyWindow addSubview:_addKeyboardView];
}

- (void)prepareToDissmiss {
    
    [_voiceKeyboardView removeFromSuperview];
    [_emojiKeyboardView removeFromSuperview];
    [_addKeyboardView removeFromSuperview];
}

#pragma mark - overrideSet
- (void)setInputState:(NSRTCMessageInputViewState)inputState {
    if (_inputState != inputState) {
        
        _inputState = inputState;
        switch (_inputState) {
            case NSRTCMessageInputViewStateSystem:
            {
                [self.addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
                [self.emotionButton setImage:[UIImage imageNamed:@"icon_bq"] forState:UIControlStateNormal];
                [self.voiceButton setImage:[UIImage imageNamed:@"icon_yy"] forState:UIControlStateNormal];
            }
                break;
            case NSRTCMessageInputViewStateEmotion:
            {
                [self.addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
                [self.emotionButton setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
                [self.voiceButton setImage:[UIImage imageNamed:@"icon_yy"] forState:UIControlStateNormal];
            }
                break;
            case NSRTCMessageInputViewStateAdd:
            {
                [self.addButton setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
                [self.emotionButton setImage:[UIImage imageNamed:@"icon_bq"] forState:UIControlStateNormal];
                [self.voiceButton setImage:[UIImage imageNamed:@"icon_yy"] forState:UIControlStateNormal];
            }
                break;
            case NSRTCMessageInputViewStateVoice:
            {
                [self.addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
                [self.emotionButton setImage:[UIImage imageNamed:@"icon_bq"] forState:UIControlStateNormal];
                [self.voiceButton setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        
        _contentView.hidden = _inputState == NSRTCMessageInputViewStateVoice;
        _arrowKeyboardButton.hidden = !_contentView.hidden;
        _arrowKeyboardButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
}
#pragma mark - Private

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isEqual:self.inputTextView]) {
        [self changContentViewHeight];
    }
    
}
- (void)setFrame:(CGRect)frame {
    
    CGFloat oldHeightToBottom = kScreenHeight - self.y;
    CGFloat newHeightToBottom = kScreenHeight - frame.origin.y;
    [super setFrame:frame];
    if (fabs(oldHeightToBottom - newHeightToBottom) > 0.1) {
        
    }
    if (self.delegate && [_delegate respondsToSelector:@selector(messageInputView:heightToBottomChange:)]) {
        
        [_delegate messageInputView:self heightToBottomChange:newHeightToBottom];
    }
}

- (void)sendText {
    
    NSString *sendText = _inputTextView.text;
    _inputTextView.text = @"";
    //    [self changContentViewHeight];
    if (_delegate && [_delegate respondsToSelector:@selector(messageInputView:sendText:)] && sendText.length) {
        [_delegate messageInputView:self sendText:sendText];
    }
}

- (void)changContentViewHeight {
    
    CGSize textSize = _inputTextView.contentSize;
    if (ABS(_inputTextView.height - textSize.height) > 0.5) {
        
        _inputTextView.height = textSize.height;
    }
    else {
        return;
    }
    CGSize contentSize = textSize;
    CGFloat selfHeight = MAX(kMessageInputView_Height, contentSize.height + 2 * kMessageInputView_PadingHeight);
    
    CGFloat maxSelfHeight = kScreenHeight/3.0f;
    selfHeight = MIN(maxSelfHeight, selfHeight);
    CGFloat diffHeight = selfHeight - _viewHeightOld;
    if (ABS(diffHeight) > 0.5) {
        CGRect selfFrame = self.frame;
        selfFrame.size.height += diffHeight;
        selfFrame.origin.y -= diffHeight;
        self.frame = selfFrame;
        _viewHeightOld = selfHeight;
    }
    self.contentView.contentSize = contentSize;
    CGFloat bottomY = textSize.height;
    CGFloat offsetY = MAX(0, bottomY - self.height - 2 * kMessageInputView_PadingHeight);
    [self.contentView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}
#pragma mark - ButtonAction

- (void)arrowButtonClicked:(id)sender {
    [self isAndResignFirstResponder];
}
- (void)emotionButtonClicked:(UIButton *)sender {
    
    CGFloat endY = kScreenHeight;
    if (self.inputState == NSRTCMessageInputViewStateEmotion) {
        self.inputState = NSRTCMessageInputViewStateSystem;
        [_inputTextView becomeFirstResponder];
    }else{
        self.inputState = NSRTCMessageInputViewStateEmotion;
        [_inputTextView resignFirstResponder];
        endY = kScreenHeight - kKeyboardView_Height - HOME_INDICATOR_HEIGHT;
    }
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [_emojiKeyboardView setY:endY];
        [_addKeyboardView setY:kScreenHeight];
        [_voiceKeyboardView setY:kScreenHeight];
        if (ABS(kScreenHeight - endY) > 0.1) {
            [self setY:endY- CGRectGetHeight(self.frame)];
        }
    } completion:^(BOOL finished) {
    }];
}
- (void)voiceButtonClicked:(UIButton *)sender {
    
    CGFloat endY = kScreenHeight;
    if (self.inputState == NSRTCMessageInputViewStateVoice) {
        self.inputState = NSRTCMessageInputViewStateSystem;
        [_inputTextView becomeFirstResponder];
    } else {
        self.inputState = NSRTCMessageInputViewStateVoice;
        [_inputTextView resignFirstResponder];
        endY = kScreenHeight - kKeyboardView_Height - HOME_INDICATOR_HEIGHT;
    }
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self->_voiceKeyboardView setY:endY];
        [self->_emojiKeyboardView setY:kScreenHeight];
        [self->_addKeyboardView setY:kScreenHeight];
        if (ABS(kScreenHeight - endY) > 0.1) {
            [self setY:endY- CGRectGetHeight(self.frame)];
        }
    } completion:^(BOOL finished) {
    }];
}
- (void)addButtonClicked:(UIButton *)sender {
    CGFloat endY = kScreenHeight;
    if (self.inputState == NSRTCMessageInputViewStateAdd) {
        self.inputState = NSRTCMessageInputViewStateSystem;
        [_inputTextView becomeFirstResponder];
    }else{
        self.inputState = NSRTCMessageInputViewStateAdd;
        [_inputTextView resignFirstResponder];
        endY = kScreenHeight - kKeyboardView_Height;
    }
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self->_addKeyboardView setY:endY];
        [self->_emojiKeyboardView setY:kScreenHeight];
        [self->_voiceKeyboardView setY:kScreenHeight];
        if (ABS(kScreenHeight - endY) > 0.1) {
            [self setY:endY- CGRectGetHeight(self.frame)];
        }
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - KeyBoard Notification Handle
- (void)keyboardChange:(NSNotification*)aNotification {
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyBoardEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyBoardEndFrame.origin.y;
    CGFloat selfOriginY = keyboardY - self.height;
    if (selfOriginY == self.y) {
        return;
    }
    
    
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve anmationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    [UIView animateWithDuration:animationDuration delay:0 options:[UIView animationOptionsForCurve:anmationCurve] animations:^{
        
        self.y = selfOriginY;
    } completion:nil];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendText];
        return NO;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    
    //    [self changContentViewHeight];
}

#pragma mark - AGEmojiKeyboardView
- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    NSString *emotion_monkey = [emoji emotionSpecailName];
    if (emotion_monkey) {
        if (_delegate && [_delegate respondsToSelector:@selector(messageInputView:sendBigEmotion:)]) {
            //            [self.delegate messageInputView:self sendBigEmotion:emotion_monkey];
            [self.inputTextView insertText:emotion_monkey];
        }
    }else{
        [self.inputTextView insertText:emoji];
    }
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
    [self.inputTextView deleteBackward];
}

- (void)emojiKeyBoardViewDidPressSendButton:(AGEmojiKeyboardView *)emojiKeyBoardView {
    
    
    [self sendText];
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [UIImage imageNamed:(category == AGEmojiKeyboardViewCategoryImageEmoji? @"icon_bq_emoji":
                                        category == AGEmojiKeyboardViewCategoryImageMonkey? @"icon_bq_monkey":
                                        category == AGEmojiKeyboardViewCategoryImageMonkey_Gif? @"icon_bq_monkey_gif":
                                        @"icon_bq_emoji_code")] ?: [UIImage new];
    return img;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    return [self emojiKeyboardView:emojiKeyboardView imageForSelectedCategory:category];
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    UIImage *img = [UIImage imageNamed:@"icon_bq_delete"];
    return img;
}


@end
