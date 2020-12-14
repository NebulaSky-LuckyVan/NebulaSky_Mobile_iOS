//
//  NSRTCMessageCellContentView.m
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSRTCMessageCellContentView.h"
#import "NSRTCMessageBubbleView.h"
#import "NSRTCDemoMessage.h"

//#import <NSRTC/NSAudioHandlerKit.h>
//#import <NSRTC/NSAudioFileProcesser.h>
#import "NSAudioHandlerKit.h"
#import "NSAudioFileProcesser.h"
#import "NSRTCChatImageBrowserModel.h"

 
//#import <NSRTC/NSRTCURLRequestOperation.h>

#import "NSRTCURLRequestOperation.h"
@interface NSRTCMessageCellContentView ()

@property (nonatomic, strong) CAShapeLayer *selectedMaskLayer;
@property (nonatomic, strong) UIView *seletedView;
@end
@implementation NSRTCMessageCellContentView


#pragma mark - Lazy
- (CAShapeLayer *)selectedMaskLayer {
    if (!_selectedMaskLayer) {
        
        _selectedMaskLayer = [CAShapeLayer layer];
        UIImage *image = [UIImage imageNamed:self.isSender ? @"video_send_bubble" : @"video_recive_bubble"];
        _selectedMaskLayer.contents = (id)(image.CGImage);
        CGRect rect = self.isSender?CGRectMake(0.35, 0.6, 0, 0) : CGRectMake(0.55, 0.6, 0, 0);
        _selectedMaskLayer.contentsCenter = rect;
        _selectedMaskLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _selectedMaskLayer;
}

- (UIView *)seletedView {
    if (!_seletedView) {
        _seletedView = [[UIView alloc] init];
        _seletedView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        _seletedView.layer.mask = self.selectedMaskLayer;
    }
    return _seletedView;
}

#pragma mark - FactoryInit
- (instancetype)initWithCellType:(NSRTCMessageCellType)cellType isSender:(BOOL)isSender{
    NSRTCMessageCellContentView *contentView;
    switch (cellType) {
        case NSRTCTextMessageCell:{
            contentView = [[NSRTCTextMessageContentView alloc] initWithIsSender:isSender];
        } break;
        case NSRTCImgMessageCell:{
            contentView = [[NSRTCImageMessageContentView alloc] initWithIsSender:isSender];
        } break;
        case NSRTCLocMessageCell:{
            contentView = [[NSRTCLocMessageContentView alloc] initWithIsSender:isSender];
        } break;
        case NSRTCAudioMessageCell: {
            contentView = [[NSRTCAudioMessageContentView alloc] initWithIsSender:isSender];
        } break;
        default:
            contentView = [[NSRTCTextMessageContentView alloc] initWithIsSender:isSender];
            break;
    }
    return contentView;
}

#pragma mark - Init
- (instancetype)initWithIsSender:(BOOL)isSender {
    if (self = [super init]) {
        self.isSender = isSender;
        [self creatUI];
        [self addTarget:self action:@selector(tapViewAction) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - OverWride
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:) || action == @selector(transmit:)) {
        return YES;
    }
    return NO;
}

- (void)copy:(id)sender {
    NSLog(@"%s",__func__);
}

#pragma mark - Private


/**
 转发
 
 @param sender 触发者
 */
- (void)transmit:(id)sender {
    NSLog(@"%s",__func__);
}

/**
 长按事件
 */
- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController* menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:self.frame inView:self.superview];
        UIMenuItem *transmit = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transmit:)];
        menuController.menuItems = @[transmit];
        [menuController setMenuVisible:YES animated:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDismiss) name:UIMenuControllerWillHideMenuNotification object:nil];
        
        NSLog(@"长按手势");
    }
}

/**
 隐藏menu
 */
- (void)menuDismiss {
    [self touchesEnded];
}


#pragma mark - Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self touchesBegan];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self touchesEnded];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    
    //    NSLog(@"view=======%@", view);
    // 不将点击事件往下传递
    return view?self:view;
}

#pragma mark - Public
- (void)touchesBegan {
    
    self.selectedMaskLayer.frame = self.bounds;
    self.seletedView.frame = self.bounds;
    [self addSubview:self.seletedView];
}

- (void)touchesEnded {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.seletedView removeFromSuperview];
    });
}
- (void)tapViewAction {
    
    if (self.contentViewTapBlock) {
        self.contentViewTapBlock();
    }
}
- (void)updateFrame {
    
}
- (void)setMessage:(NSRTCDemoMessage *)message {
    _message = message;
    [self updateFrame];
}

- (void)creatUI {
    
}
@end



@interface NSRTCTextMessageContentView ()


@property (nonatomic, strong) NSRTCMessageBubbleView *bubbleView;      // 文字气泡

@end
@implementation NSRTCTextMessageContentView


- (void)creatUI {
    _bubbleView = [[NSRTCMessageBubbleView alloc] initWithIsSender:self.isSender];
    _bubbleView.frame = self.bounds;
    [_bubbleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:_bubbleView];
}


- (void)updateFrame {
    UIEdgeInsets insets = self.isSender?[NSRTCMessageBubbleView appearance].textSendInsets:[NSRTCMessageBubbleView appearance].textRecInsets;
    if ([self.message isKindOfClass:[NSRTCMessage class]]) {
        NSRTCDemoMessage *demoMsg = [NSRTCDemoMessage yy_modelWithDictionary:[self.message yy_modelToJSONObject]];
        
        CGFloat width = demoMsg.textMessageLabelSize.width + insets.left + insets.right;
        CGFloat height = demoMsg.textMessageLabelSize.height + insets.top + insets.bottom;
        self.frame = CGRectMake(self.isSender?kScreenWidth - self.horizontalOffset - width:self.horizontalOffset, self.verticalOffset, width, height);
    }else{
        CGFloat width = self.message.textMessageLabelSize.width + insets.left + insets.right;
        CGFloat height = self.message.textMessageLabelSize.height + insets.top + insets.bottom;
        self.frame = CGRectMake(self.isSender?kScreenWidth - self.horizontalOffset - width:self.horizontalOffset, self.verticalOffset, width, height);
    }
   
    
}

- (void)setHorizontalOffset:(CGFloat)horizontalOffset {
    super.horizontalOffset = horizontalOffset;
    _bubbleView.horizontalOffset = horizontalOffset;
}

- (void)setMessage:(NSRTCDemoMessage *)message {
    super.message = message;
    _bubbleView.message = message;
}
- (void)setTextFont:(UIFont *)textFont {
    super.textFont = textFont;
    _bubbleView.textFont = textFont;
}



@end


@interface NSRTCImageMessageContentView ()

@property (nonatomic, strong) UIImageView *messageImage;            // 消息图片
@property (nonatomic, strong) CAShapeLayer *maskLayer;


@end
@implementation NSRTCImageMessageContentView


- (CAShapeLayer *)selectedMaskLayer {
    return nil;
}
- (void)creatUI {
    
    
    
    
    _maskLayer = [CAShapeLayer layer];
    CGRect rect = self.isSender?CGRectMake(0.35, 0.6, 0, 0) : CGRectMake(0.55, 0.6, 0, 0);
    _maskLayer.contentsCenter = rect;
    
    
    UIImage *image = [UIImage imageNamed:self.isSender ? @"video_send_bubble" : @"video_recive_bubble"];;
    _maskLayer.contents = (id)image.CGImage;
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    
    _messageImage = [[UIImageView alloc] init];
    _messageImage.contentMode = UIViewContentModeScaleAspectFill;
    _messageImage.clipsToBounds = YES;
    _messageImage.layer.mask = _maskLayer;
    [self addSubview:_messageImage];
}

- (void)updateFrame {
    
    NSDictionary *size = self.message.bodies.size;
    CGFloat width = [size[@"width"] floatValue];
    CGFloat height = [size[@"height"] floatValue];
    CGRect frame = self.isSender?CGRectMake(kScreenWidth - self.horizontalOffset - width, self.verticalOffset, width, height):CGRectMake(self.horizontalOffset, self.verticalOffset, width, height);
    self.frame = frame;
    _maskLayer.frame = self.bounds;
    _messageImage.frame = self.bounds;
}

- (void)setMessage:(NSRTCDemoMessage *)message {
    super.message = message;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image;
        if (message.bodies.fileName.length) { // 从本地读取图片
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSData *imageData = [fileManager contentsAtPath:[[NSString getFielSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"s_%@", message.bodies.fileName]]];
            image = [UIImage imageWithData:imageData];
            
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (image) { // 本地有图片
                
                NSLog(@"本地有图片");
                [self.messageImage setImage:image];
            }
            else { // 网络加载图片
                
                NSLog(@"网络加载图片");
                
                [self.messageImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BaseURL, message.bodies.thumbnailRemotePath]] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                }];
//                [self.messageImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", baseURL, message.bodies.thumbnailRemotePath]]];
            }
        });
    });
}


- (void)touchesBegan {
    [super touchesBegan];
    [self.messageImage addSubview:self.seletedView];
}


@end

@interface NSRTCLocMessageContentView ()

@property (nonatomic, strong) UIView *locationBackView;             // 位置背景视图
@property (nonatomic, strong) UILabel *locationNameLabel;           // 位置名称label
@property (nonatomic, strong) UILabel *detailLocationNameLabel;     // 位置详情
@property (nonatomic, strong) UIImageView *locationImageView;       // 定位地图图片
@property (nonatomic, strong) UIView *sepLine;

@end

@implementation NSRTCLocMessageContentView

- (CAShapeLayer *)selectedMaskLayer {
    return nil;
}

- (UIView *)seletedView {
    UIView *view = [super seletedView];
    
    [view setCornerRadius:5];
    return view;
}

- (void)creatUI {
    
    
    
    _locationBackView = [[UIView alloc] init];
    [self addSubview:_locationBackView];
    _locationBackView.backgroundColor = [UIColor whiteColor];
    [_locationBackView setCornerRadius:5];
    [_locationBackView setBorderWidth:0.5 color:[UIColor colorWithHex:0xdfdfdf]];
    
    
    _locationNameLabel = [[UILabel alloc] init];
    _locationNameLabel.font = [UIFont systemFontOfSize:14];
    [_locationBackView addSubview:_locationNameLabel];
    
    _detailLocationNameLabel = [[UILabel alloc] init];
    _detailLocationNameLabel.font = [UIFont systemFontOfSize:12];
    _detailLocationNameLabel.textColor = [UIColor colorWithHex:0x989898];
    [_locationBackView addSubview:_detailLocationNameLabel];
    
    
    _locationImageView = [[UIImageView alloc] init];
    [_locationBackView addSubview:_locationImageView];
    
    
    
    _sepLine = [[UIView alloc] init];
    _sepLine.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [_locationBackView addSubview:_sepLine];
}

- (void)updateFrame {
    CGFloat width = 200;
    CGFloat imageHeight = width/2.0;
    CGFloat labelH = 30;
    CGFloat sLabelH = 15;
    
    CGRect frame = self.isSender ? CGRectMake(kScreenWidth - self.horizontalOffset - width, self.verticalOffset, width, imageHeight + labelH + sLabelH) : CGRectMake(self.horizontalOffset, self.verticalOffset, width, imageHeight + labelH + sLabelH);
    self.frame = frame;
    
    _locationBackView.frame = self.bounds;
    _locationNameLabel.frame = CGRectMake(5, 0, self.width - 5, labelH);
    _detailLocationNameLabel.frame = CGRectMake(5, labelH - 5, self.width - 5, sLabelH);
    _locationImageView.frame = CGRectMake(0, labelH + sLabelH, self.width, imageHeight);
    _sepLine.frame = CGRectMake(0, sLabelH+labelH - 0.5, self.width, 0.5);
}


- (void)setMessage:(NSRTCDemoMessage *)message {
    super.message = message;
    _locationNameLabel.text = message.bodies.locationName;
    _detailLocationNameLabel.text = message.bodies.detailLocationName;
}

- (void)resetLocImage {
    if (self.message.bodies.fileRemotePath.length) {
        [_locationImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BaseURL, self.message.bodies.fileRemotePath]]];
    }
}


@end


@interface NSRTCAudioMessageContentView () <NSAudioHandlerDelegate>

@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat minWidth;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;


@end

@implementation NSRTCAudioMessageContentView



- (void)creatUI {
    
    _maxWidth = kScreenWidth*2.0/3.0;
    _minWidth = 80;
    
    _bubbleImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bubbleImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_bubbleImageView];
    _bubbleImageView.image = [UIImage imageNamed:self.isSender ? @"video_send_bubble" : @"video_recive_bubble"];
    
    _playImageView = [[UIImageView alloc] init];
    _playImageView.image = self.isSender?[UIImage imageNamed:@"bubble_right_play_2"]:[UIImage imageNamed:@"bubble_left_play_2"];
    [_bubbleImageView addSubview:_playImageView];
    
    _durationLabel = [[UILabel alloc] init];
    _durationLabel.textColor = self.isSender?[UIColor whiteColor]:[UIColor colorWithHex:0x989898];
    _durationLabel.font = [UIFont systemFontOfSize:14];
    [_bubbleImageView addSubview:_durationLabel];
    
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _activityView.hidesWhenStopped = YES;
    [_activityView stopAnimating];
    [_bubbleImageView addSubview:_activityView];
    
}



- (void)updateFrame {
    CGFloat duration = self.message.bodies.duration;
    
    CGFloat maxShowValue = 60.0;
    CGFloat value = MIN(maxShowValue, duration);
    CGFloat width = _minWidth + (_maxWidth - _minWidth) * (value / maxShowValue);
    CGRect selfFrame = self.isSender?CGRectMake(kScreenWidth - self.horizontalOffset - width, self.verticalOffset, width, 40):CGRectMake(self.horizontalOffset, self.verticalOffset, width, 40);
    self.frame = selfFrame;
    
    CGFloat imageW = 20;
    CGRect playerImageFrame = self.isSender?CGRectMake(self.width - imageW -[NSRTCMessageBubbleView appearance].textSendInsets.right, (self.height - imageW)/2.0, imageW, imageW):CGRectMake([NSRTCMessageBubbleView appearance].textRecInsets.left, (self.height - imageW)/2.0, imageW, imageW);
    _playImageView.frame = playerImageFrame;
    
    
    
}


- (void)setMessage:(NSRTCDemoMessage *)message {
    super.message = message;
    CGFloat duration = message.bodies.duration;
    NSInteger minute = duration/60;
    NSInteger second = (NSInteger)duration%60;
    NSString *showDuration = minute > 0 ? [NSString stringWithFormat:@"%ld\'%ld\"", minute, second] : [NSString stringWithFormat:@"%ld\"", second];
    _durationLabel.text = showDuration;
    
    [_durationLabel sizeToFit];
    CGFloat width = _durationLabel.width;
    CGRect labelFrame = self.isSender?CGRectMake([NSRTCMessageBubbleView appearance].textSendInsets.left, 0, width, self.height):CGRectMake(self.width - width - [NSRTCMessageBubbleView appearance].textRecInsets.right, 0, width, self.height);
    _durationLabel.frame = labelFrame;
}

- (void)tapViewAction {
    
    if (self.playState == NSRTCAudioPlayViewStateNormal) {
        
        [self play];
    }
    else if (self.playState == NSRTCAudioPlayViewStatePlaying) {
        
        [self stop];
    }
}

- (void)stop {
    self.playState = NSRTCAudioPlayViewStateNormal;
    [[NSAudioHandlerKit shared] stopPlay];
}

- (void)play {
    [self stop];
    if (self.message.bodies.fileRemotePath == nil) {
        return;
    }
    
    if ([[NSAudioHandlerKit shared].delegate isKindOfClass:[self class]] && [NSAudioHandlerKit shared].delegate != self) {
        NSRTCAudioMessageContentView *view = (NSRTCAudioMessageContentView *)[NSAudioHandlerKit shared].delegate;
        if (view.playState == NSRTCAudioPlayViewStatePlaying) {
            view.playState = NSRTCAudioPlayViewStateNormal;
        }
    }
    
    [NSAudioHandlerKit shared].delegate = self;
    
    NSString *remotePath = [BaseURL stringByAppendingPathComponent:self.message.bodies.fileRemotePath];
    // 先去本地查找文件
    NSString *filePath = [[NSString getAudioSavePath] stringByAppendingPathComponent:self.message.bodies.fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self playFile:filePath];
    }  else { // 先下载，再播放
        [self downLoadAudioWithRemotepath:remotePath filePath:filePath];
    }
}

- (void)downLoadAudioWithRemotepath:(NSString *)remotepath filePath:(NSString *)filePath{
    __weak typeof(self) weakSelf = self;
    NSURL *cacheFileFolderURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    [NSRTCURLRequestOperation downLoadWithUrl:remotepath cacheFileFolderURL:cacheFileFolderURL progress:nil success:^(NSHTTPURLResponse* response) {
        
        //        NSData *audioData = response;
        
         
        NSData *audioData = [NSData dataWithContentsOfURL:[cacheFileFolderURL URLByAppendingPathComponent:[response suggestedFilename]]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }

        [audioData writeToFile:(NSString*)filePath atomically:YES];
        [weakSelf playFile:filePath];
    } fail:^(id error) {
        weakSelf.playState = NSRTCAudioPlayViewStateNormal;
    }];
    self.playState = NSRTCAudioPlayViewStateDownloading;
}

- (void)playFile:(NSString *)file {
    [self stop];
    if (file.length == 0) {
        return;
    }
    NSString *f = nil;
    if ([@"amr" isEqualToString:file.pathExtension]) {
        f = [NSAudioFileProcesser convertedWaveFromAmr:file];
        if (f == nil) {
            f = [NSAudioFileProcesser decodeAmrToWave:file];
        }
    }
    else {
        f = file;
    }
    self.playState = NSRTCAudioPlayViewStatePlaying;
    [[NSAudioHandlerKit shared] play:f validator:nil];
}

- (void)setPlayState:(NSRTCAudioPlayViewState)playState {
    _playState = playState;
    if (playState == NSRTCAudioPlayViewStatePlaying) {
        [_activityView stopAnimating];
        [self startPlayingAnimation];
    }
    else if (playState == NSRTCAudioPlayViewStateDownloading) {
        [_activityView startAnimating];
        [self stopPlayingAnimation];
    }
    else {
        [_activityView stopAnimating];
        [self stopPlayingAnimation];
    }
}

- (void)startPlayingAnimation {
    _playImageView.image = nil;
    if (self.isSender) {
        _playImageView.image = [UIImage animatedImageNamed:@"bubble_right_play_" duration:0.8];
    }
    else {
        _playImageView.image = [UIImage animatedImageNamed:@"bubble_left_play_" duration:0.8];
    }
    [_playImageView startAnimating];
}

- (void)stopPlayingAnimation {
    [_playImageView stopAnimating];
    if (self.isSender) {
        _playImageView.image = [UIImage imageNamed:@"bubble_right_play_2"];
    }
    else {
        _playImageView.image = [UIImage imageNamed:@"bubble_left_play_2"];
    }
}

#pragma mark - AudioManagerDelegate
- (void)didAudioPlayStoped:(NSAudioHandlerKit *)am successfully:(BOOL)successfully {
    self.playState = NSRTCAudioPlayViewStateNormal;
}

- (void)didAudioPlay:(NSAudioHandlerKit *)am err:(NSError *)err {
    NSLog(@"播放错误");
}


@end
