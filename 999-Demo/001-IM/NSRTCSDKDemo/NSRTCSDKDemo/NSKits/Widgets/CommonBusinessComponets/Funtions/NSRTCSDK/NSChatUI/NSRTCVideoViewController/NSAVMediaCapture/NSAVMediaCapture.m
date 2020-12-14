//
//  NSAVMediaCapture.m
//  CustomeCamera
//
//  Created by VanZhang on 2019/11/21.
//  Copyright © 2019 ios2chen. All rights reserved.
//

#import "NSAVMediaCapture.h"
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface NSAVMediaCapture () <AVCaptureFileOutputRecordingDelegate>

/*
 *  AVCaptureSession:它从物理设备得到数据流（比如摄像头和麦克风），输出到一个或
 *  多个目的地，它可以通过
 *  会话预设值(session preset)，来控制捕捉数据的格式和质量
 */
@property (nonatomic, strong) AVCaptureSession *captureSession;
//设备
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
 //输入
@property (nonatomic, strong) AVCaptureDeviceInput *caputreInput;

//照片输出
@property (nonatomic, strong) AVCaptureStillImageOutput *captureOutput;
//视频输出
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieOutput;
//预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *capturePreviewLayer;

@end


@interface NSAVMediaCapture ()
//Desc:
//@property (assign, nonatomic) NSMediaCaptureType capType;
//@property (assign, nonatomic) NSVideoCaptureStatus videoCapStatus;

@property (strong, nonatomic) NSString *cacheName;

@property (copy, nonatomic) NSAVMediaCaptureComplectionHandler complection;

//Desc:
@property (weak, nonatomic) UIView *captureBannerView;
/**
 聚焦光标
 */
@property (weak, nonatomic)  UIImageView *focusCurson;


/**
 是否在对焦
 */
@property (assign, nonatomic) BOOL isFocus;
@end
@implementation NSAVMediaCapture

//===============SingleTon====================//
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopy{
    return _instance;
}
- (id)copy{
    return _instance;
}
+ (instancetype)sharedInstance{
    return [[self alloc]init];
}
//===================================//



//===================================//

+ (instancetype)captureWithBaseView:(UIView*)baseView  focusCurson:(UIImageView*)focus captureMediaType:(NSMediaCaptureType)type complection:(NSAVMediaCaptureComplectionHandler)comp{
    NSAVMediaCapture *caputreor = [NSAVMediaCapture sharedInstance];
    caputreor.capType = type;
    [caputreor setupWithBaseView:baseView];
    caputreor.complection = [comp copy];
    caputreor.focusCurson = focus;
    return caputreor;
}
- (void)setCapType:(NSMediaCaptureType)capType{
    _capType = capType;
    if (capType==NSAVMedia_VideoCapturor) {
        self.videoCapStatus  = NSVideoCaptureStart;
    }
}
-(AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc]init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _captureSession;
}
- (void)setupWithBaseView:(UIView*)captureBannerView{
    
    if (!captureBannerView) {
        NSLog(@"Please set up with a base view for capture layer");
        return;
    }else{
        self.captureBannerView = captureBannerView;
        NSArray *deviceArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in deviceArray) {
            if (device.position == AVCaptureDevicePositionBack) {
                self.captureDevice = device;
            }
        }
        //添加摄像头设备
        //对设备进行设置时需上锁，设置完再打开锁
        [self.captureDevice lockForConfiguration:nil];
        if ([self.captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([self.captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [self.captureDevice unlockForConfiguration];
        
        
        //添加音频设备
        AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
        self.caputreInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.captureDevice error:nil];
        self.captureOutput = [[AVCaptureStillImageOutput alloc]init];
        NSDictionary *setDic = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        self.captureOutput.outputSettings = setDic;
        self.movieOutput = [[AVCaptureMovieFileOutput alloc]init];
        if ([self.captureSession canAddInput:self.caputreInput]) {
            [self.captureSession addInput:self.caputreInput];
        }
        if ([self.captureSession canAddOutput:self.captureOutput]) {
            [self.captureSession addOutput:self.captureOutput];
        }
        if ([self.captureSession canAddInput:audioInput]) {
            [self.captureSession addInput:audioInput];
        }
        self.capturePreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
        [self.capturePreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        self.capturePreviewLayer.frame = [UIScreen mainScreen].bounds;
        [captureBannerView.layer insertSublayer:self.capturePreviewLayer atIndex:0];
        [self.captureSession startRunning];
        [self addGenstureRecognizer];
    }
}
- (void)startRuning{
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}
- (void)stopRuning{
    
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

#pragma mark - Private
//闪光灯
- (BOOL)flashEnable:(BOOL)enable{
    [self.captureDevice lockForConfiguration:nil];
    if (!enable) {
        if ([self.captureDevice isFlashModeSupported:AVCaptureFlashModeOff]) {
            [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
            NSLog(@"闪光灯已关闭");
//            [[CustomeAlertView shareView] showCustomeAlertViewWithMessage:@"闪光灯已关闭"];
        }
    }else {
        if ([self.captureDevice isFlashModeSupported:AVCaptureFlashModeOn]) {
            [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
//            [[CustomeAlertView shareView] showCustomeAlertViewWithMessage:@"闪光灯已开启"];
            NSLog(@"闪光灯已开启");
        }
    }
    [self.captureDevice unlockForConfiguration];
    return enable;
}
//前后摄像头置换
- (AVCaptureDevicePosition)changeCameraPosition{
    NSArray *deviceArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *newDevice;
    AVCaptureDeviceInput *newInput;
    if (self.captureDevice.position == AVCaptureDevicePositionBack) {
        for (AVCaptureDevice *device in deviceArray) {
            if (device.position == AVCaptureDevicePositionFront) {
                newDevice = device;
                break;
            }
        }
    } else {
        for (AVCaptureDevice *device in deviceArray) {
            if (device.position == AVCaptureDevicePositionBack) {
                newDevice = device;
                break;
            }
        }
    }
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:nil];
    if (newInput!=nil) {
        [self.captureSession beginConfiguration];
        [self.captureSession removeInput:self.caputreInput];
        if ([self.captureSession canAddInput:newInput]) {
            [self.captureSession addInput:newInput];
            self.captureDevice = newDevice;
            self.caputreInput = newInput;
        } else{
            [self.captureSession addInput:self.caputreInput];
        }
        [self.captureSession commitConfiguration];
    }
    return self.captureDevice.position;
}

- (NSMediaCaptureType)changeCaptureType{
    self.capType = (self.capType==NSAVMedia_VideoCapturor)?NSAVMedia_ImageCapturor:NSAVMedia_VideoCapturor;
    if (self.capType == NSAVMedia_VideoCapturor) {
        
        [self.captureSession beginConfiguration];
        [self.captureSession removeOutput:self.captureOutput];
        if ([self.captureSession canAddOutput:self.movieOutput]) {
            [self.captureSession addOutput:self.movieOutput];
            
//            [self.takePhotoBtn setTitle:@"开始" forState:UIControlStateNormal];
            
            //设置视频防抖
            AVCaptureConnection *connection = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
            if ([connection isVideoStabilizationSupported]) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
            }
            
        } else{
            [self.captureSession addOutput:self.captureOutput];
        }
        
        [self.captureSession commitConfiguration];
        
    } else{
        [self.captureSession beginConfiguration];
        [self.captureSession removeOutput:self.movieOutput];
        if ([self.captureSession canAddOutput:self.captureOutput]) {
            [self.captureSession addOutput:self.captureOutput];
             
            
        } else{
            [self.captureSession addOutput:self.movieOutput];
        }
        
        [self.captureSession commitConfiguration];
    }
    return self.capType;
}
- (void)takePicture{
    if (self.capType ==NSAVMedia_ImageCapturor) {
        AVCaptureConnection *connection = [self.captureOutput connectionWithMediaType:AVMediaTypeVideo];
        if (!connection) {
            NSLog(@"caputre Picture Fail");
        } else{
            [self.captureOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                if (!imageDataSampleBuffer) {
                    NSLog(@"caputre Picture Fail");
                } else{
                    
                    NSLog(@"caputre Picture Success");
                    
                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

                    !self.complection?:self.complection(image);
                }
            }];
        }
    }
}

- (void)takeVideo{
    if (self.capType ==NSAVMedia_VideoCapturor) {
         if(self.videoCapStatus==NSVideoCaptureStart){
             AVCaptureConnection *connect = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
             NSString *cachePath = [NSTemporaryDirectory() stringByAppendingString:!self.cacheName?@"luckyVideo.mov":self.cacheName];
             NSURL *url = [NSURL fileURLWithPath:cachePath];
             if (![self.movieOutput isRecording]) {
                 [self.movieOutput startRecordingToOutputFileURL:url recordingDelegate:self];
             }
             self.videoCapStatus = NSVideoCaptureConnectiong;
            
         } else if (self.videoCapStatus==NSVideoCaptureEnd){
             self.videoCapStatus = NSVideoCaptureEnd;
             if ([self.movieOutput isRecording]) {
                 [self.movieOutput stopRecording];
             }
         }
    }
}

/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.captureBannerView addGestureRecognizer:tapGesture];
}

/**
 点击屏幕聚焦
 
 @param tapGesture 手势
 */
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    if ([self.captureSession isRunning]) {
        CGPoint point = [tapGesture locationInView:self.captureBannerView];
        // 将UI坐标转换为摄像头坐标
        CGPoint cameraPoint = [self.capturePreviewLayer captureDevicePointOfInterestForPoint:point];
        [self setFocusCursorWithPoint:point];
        [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
    }
}
/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    if (!self.isFocus&&self.focusCurson) {
        self.isFocus = YES;
        self.focusCurson.center = point;
        [self.focusCurson setTransform:CGAffineTransformMakeScale(1.25, 1.25)];
        self.focusCurson.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{ 
            self.focusCurson.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5];
        }];
    }
}

/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

/**
 隐藏聚焦
 */
- (void)onHiddenFocusCurSorAction {
    self.focusCurson.alpha=0;
    self.isFocus = NO;
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice = [self.caputreInput device];
    NSError *error = nil;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        //自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动根据环境条件开启闪光灯
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }
    else {
        NSLog(@"摄像头属性设置错误");
    }
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    !self.complection?:self.complection(outputFileURL);
    //保存视频到相册
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:nil];
    NSLog(@"capture video success");
}



@end
