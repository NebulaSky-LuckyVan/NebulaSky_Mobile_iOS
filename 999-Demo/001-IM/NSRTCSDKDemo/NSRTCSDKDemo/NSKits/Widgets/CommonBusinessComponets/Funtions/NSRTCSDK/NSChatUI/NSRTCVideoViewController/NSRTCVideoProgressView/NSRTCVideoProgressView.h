//
//  NSRTCVideoProgressView.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/4.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface NSRTCVideoProgressView : UIView

@property (nonatomic, assign) NSInteger timeMax;

- (void)clearProgress;
@end
