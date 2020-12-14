//
//  NSVideoPlayer.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface NSVideoPlayer : UIView

@property (nonatomic, copy) NSURL *videoUrl;
- (instancetype)initWithFrame:(CGRect)frame showInView:(UIView *)bgView url:(NSURL *)url;
- (void)stopPlayer;
@end
  
