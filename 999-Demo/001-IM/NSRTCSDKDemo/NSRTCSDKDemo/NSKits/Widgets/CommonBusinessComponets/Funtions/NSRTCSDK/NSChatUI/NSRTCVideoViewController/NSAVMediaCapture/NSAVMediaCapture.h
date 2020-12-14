//
//  NSAVMediaCapture.h
//  CustomeCamera
//
//  Created by VanZhang on 2019/11/21.
//  Copyright © 2019 ios2chen. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^NSAVMediaCaptureComplectionHandler)(id fileOrFilePathURL);
typedef NS_ENUM(NSUInteger,NSMediaCaptureType){
    NSAVMedia_VideoCapturor = 0,
    NSAVMedia_ImageCapturor,
};
typedef NS_ENUM(NSUInteger,NSVideoCaptureStatus){
    NSVideoCaptureStart = 0,
    NSVideoCaptureConnectiong,
    NSVideoCaptureEnd,
};

@interface NSAVMediaCapture : NSObject



+ (instancetype)captureWithBaseView:(UIView*)baseView  focusCurson:(UIImageView*)focus captureMediaType:(NSMediaCaptureType)type complection:(NSAVMediaCaptureComplectionHandler)comp;

//前后摄像头置换
- (AVCaptureDevicePosition)changeCameraPosition;

- (NSMediaCaptureType)changeCaptureType;


@property (assign, nonatomic) NSMediaCaptureType capType;
@property (assign, nonatomic) NSVideoCaptureStatus videoCapStatus;


//闪光灯
- (BOOL)flashEnable:(BOOL)enable;

- (void)takePicture;

- (void)takeVideo;

- (void)startRuning;

- (void)stopRuning;

- (void)removeNotification;
 


@end

