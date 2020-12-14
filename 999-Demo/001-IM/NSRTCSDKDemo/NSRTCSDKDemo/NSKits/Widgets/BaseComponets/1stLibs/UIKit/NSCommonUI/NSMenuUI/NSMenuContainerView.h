//
//  NSMenuContainerView.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/9.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
 

/*BackgroundCoverColor*/
typedef NS_ENUM(NSUInteger,NSMenuContainerCoverStyle) {
    MenuCoverColor_Clear  = 0,
    MenuCoverColor_Gray ,
    
};
@interface NSMenuContainerView : UIView
+ (instancetype)menuWithFrame:(CGRect)frame coverStyle:(NSMenuContainerCoverStyle)style;

@end
 
