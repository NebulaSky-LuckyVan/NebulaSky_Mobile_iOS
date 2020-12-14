//
//  UIViewController+Common.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <UIKit/UIKit.h>
 

@interface UIViewController (Common)

- (void)showMessage:(NSString *)message;
- (void)showHint:(NSString *)hint;
- (void)hideHud;
- (void)showError:(NSString *)error;
- (void)showSuccess:(NSString *)success;
@end
 

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


#define ColorFromHexA(hexValue, a)     [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:a]

#define ColorFromHex(hexValue)        ColorFromHexA(hexValue, 1.0f)
/*---------App属性设置-------------*/
#define AppBackgroundColor     ColorFromHex(0xF5F3F2)//页面背景颜色
/*------导航栏------*/
#define NavBarBackgroundColor  ColorFromHexA(0xFFFFFF,1)//[UIColor colorWithRGBHexString:@"b40000"]//导航栏背景色
#define NavBarTextColor ColorFromHex(0x333333) //导航栏文字颜色
typedef NS_ENUM(NSUInteger,MediaType) {
    MediaType_Image = 0,
    MediaType_Movie
};
typedef void(^CompressionVideoSuccessBlock)(NSString*,CGFloat);
typedef void(^CompressionImageSuccessBlock)(UIImage*);
typedef void(^CallActionComplectionBlock)(MediaType,id object);
@interface UIViewController (CameraOrAlbum)<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UIImagePickerController * imgPickerCtrl ;
@property (copy, nonatomic) CallActionComplectionBlock  handlerComplectionBlock;
/**
 *  调用相册
 */
- (BOOL)isCameraAvailable;

- (void)showMediaActionSheetWithCameraCapability:(MediaType)mediaType;


- (void)showMediaActionSheetWithCameraCapability:(MediaType)mediaType complectionHandler:(CallActionComplectionBlock)block;

// get  Media files from camera
- (void)useCameraForMedia:(MediaType)type;
// get album Media files
- (void)showAlbum;
//getThumbnailImageWithAVAssetUrl
- (UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond withUrl:(NSURL *)url;

- (void)compressedVideoOtherMethodWithURL:(NSURL *)url compressionType:(NSString *)compressionType compressionResultPath:(CompressionVideoSuccessBlock)resultPathBlock;
- (void)compressedImage:(UIImage *)image  compressionResultPath:(CompressionImageSuccessBlock)resultPathBlock;
@end
