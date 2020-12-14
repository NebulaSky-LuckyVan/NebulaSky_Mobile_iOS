//
//  NSRTCChatLocationController.h
//  NSRTCSDK_Example
//
//  Created by VanZhang on 2019/11/2.
//  Copyright © 2019 VanZhang. All rights reserved.
//


//#import <NSRTC/NSRTCMessage.h>
//#import <NSRTC/NSRTCBaseViewController.h>

//#import <NSRTCSDK/NSRTCBaseViewController.h>
//#import "NSRTCBaseViewController.h"

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSRTCChatLocationController : NSRTCBaseViewController
@property (nonatomic, copy) void(^sendLocationBlock)(CLLocationCoordinate2D location, NSString *locationName, NSString *detailLocName);

@end



typedef NS_ENUM(NSInteger, NSRTCLocationCellStyle) {
    
    NSRTCOnlyName,
    NSRTCNameAndAddress
};
@interface NSRTCLocationCell : UITableViewCell

@property (nonatomic, assign) NSRTCLocationCellStyle style;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *selectedImage;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(NSRTCLocationCellStyle)cellStyle;

@end

NS_ASSUME_NONNULL_END
