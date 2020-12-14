//
//  NSRTCChatImageBrowseCell.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSRTCChatImageBrowserModel;

@interface NSRTCChatImageBrowserCell : UICollectionViewCell

@property (nonatomic, strong) NSRTCChatImageBrowserModel *imageModel;

@property (nonatomic, copy) void(^closeBrowserBlock)();

- (void)showAnimationWithStartRect:(CGRect)rect;

- (void)hideAnimationWithEndRect:(CGRect)rect complete:(void(^)())complete;
@end

