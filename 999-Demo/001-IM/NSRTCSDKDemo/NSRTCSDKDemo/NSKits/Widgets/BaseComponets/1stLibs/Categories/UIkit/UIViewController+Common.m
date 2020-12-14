//
//  UIViewController+Common.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "UIViewController+Common.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <objc/runtime.h>

static char tHud;
@implementation UIViewController (Common)
- (void)showMessage:(NSString *)message {
    
    
    MBProgressHUD *hud = [self getHUD];
    if (hud) {
        
//        hud.label.text = message;
        hud.labelText = message;
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hud.label.text = message;
                hud.labelText = message;
        hud.removeFromSuperViewOnHide = YES;
//        hud.backgroundView.hidden = YES;
//        hud.backgroundView.hidden = YES;
        hud.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, &tHud, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (MBProgressHUD *)getHUD {
    
    return (MBProgressHUD *)objc_getAssociatedObject(self, &tHud);
}

- (void)hideHud {
    MBProgressHUD *hud = [self getHUD];
//    [hud hideAnimated:YES];
    [hud hide:YES];
    objc_setAssociatedObject(self, &tHud, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showError:(NSString *)error {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text = error;
    hud.labelText = error;
    //    hud.contentColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    //    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //    hud.label.text = text;
    //    hud.label.numberOfLines = 0;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"error"]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    // 2秒之后再消失
//    [hud hideAnimated:YES afterDelay:2];
    [hud hide:YES afterDelay:2];
}

- (void)showSuccess:(NSString *)success {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text = success;
    hud.labelText = success;
    //    hud.contentColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    //    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //    hud.label.text = text;
    //    hud.label.numberOfLines = 0;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"success"]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    // 1秒之后再消失
//    [hud hideAnimated:YES afterDelay:0.7];
    
    [hud hide:YES afterDelay:0.7];
}

- (void)showHint:(NSString *)hint {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text = hint;
    hud.labelText = hint;
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    hud.userInteractionEnabled = NO;
    // 2秒之后再消失
//    [hud hideAnimated:YES afterDelay:1.5];
    [hud hide:YES afterDelay:1.5];
}


@end

#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>


#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


#import "NSRTCImageCompressorKit.h"
 
#import "NSObject+Common.h"

#define CompressionVideoPaht [NSHomeDirectory() stringByAppendingFormat:@"/Documents/CompressionVideoField"]

@implementation UIViewController (CameraOrAlbum)

-(void)setImgPickerCtrl:(UIImagePickerController *)imgPickerCtrl{
    objc_setAssociatedObject(self, @selector(imgPickerCtrl), imgPickerCtrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImagePickerController *)imgPickerCtrl{
    
    UIImagePickerController *imgPicker = objc_getAssociatedObject(self, _cmd);
    if (!imgPicker) {
        imgPicker = [[UIImagePickerController alloc]init];
        //setNavigationBar to adaptive curr App's NavigationBar
        [imgPicker.navigationBar setBarTintColor:[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f]];// navigation bar background.
        [imgPicker.navigationBar setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f]];// setBtnTitleColor
        [imgPicker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];//specify the color of the text during rendering. If you do not specify this attribute, the text is rendered in black.
        [self setImgPickerCtrl:imgPicker];
        imgPicker.delegate = self;
        imgPicker.navigationBar.translucent = NO;
        
//        if (@available(iOS 11.0, *)){
//            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//        }
    }
    [imgPicker.navigationBar.backItem setHidesBackButton:YES];
    
    return imgPicker;
}


-(void)setHandlerComplectionBlock:(CallActionComplectionBlock)HandlerComplectionBlock{
    objc_setAssociatedObject(self, @selector(handlerComplectionBlock), HandlerComplectionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(CallActionComplectionBlock)handlerComplectionBlock{
    CallActionComplectionBlock complection = objc_getAssociatedObject(self, _cmd);
    return complection;
}
/*
 使用UIImagePickerController 的工作流程:
 「在iOS8之后,为了更好的保护用户隐私,苹果要求进行摄像头操作或者对相册进行访问时,需要让用户选择是否同意当前操作」
 //0.构造并且配置UIImagePickerController对象
 //1.选择资源格式
 //2.判断选中的资源格式是否可操作
 //3.获取资源
 */
//检查摄像头是否可用
-(BOOL)isCameraAvailable{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    return ([UIImagePickerController isSourceTypeAvailable:sourceType]);
}

-(void)showMediaActionSheetWithCameraCapability:(MediaType)mediaType{
    CGFloat sysVersion  = [[UIDevice currentDevice].systemVersion floatValue];
    if (sysVersion>8.0f) {
 
        UIAlertController *alertCtrl  = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if (mediaType==MediaType_Image) {
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self useCameraForMedia:MediaType_Image];
            }]];
        }else if (mediaType==MediaType_Movie){
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"录制视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self useCameraForMedia:MediaType_Movie];
                if (self.imgPickerCtrl.sourceType==UIImagePickerControllerSourceTypeCamera) {
                    [NSObject perform:^(id weakSelf) {
                        NSLog(@"startVideoCapture");
                        [self.imgPickerCtrl startVideoCapture];
                    } after:0.7];
                    
                    [NSObject perform:^(id weakSelf) {
                        NSLog(@"stopVideoCapture");
                        [self.imgPickerCtrl stopVideoCapture];
                    } after:15];
                }//录制视频
            }]];
        }
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showAlbum];
        }]];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.imgPickerCtrl dismissViewControllerAnimated:YES completion:NULL];
        }]];
        [self presentViewController:alertCtrl animated:YES completion:NULL];
    }else{
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        UIActionSheet *actionSheet  = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [actionSheet showInView:self.view];
#pragma clang diagnostic pop
    }
}

- (void)showMediaActionSheetWithCameraCapability:(MediaType)mediaType complectionHandler:(CallActionComplectionBlock)block;{
    [self showMediaActionSheetWithCameraCapability:mediaType];
    self.handlerComplectionBlock = block;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //调用相机
    if (buttonIndex == 0) {
        [self useCameraForMedia:MediaType_Image];
    }else if (buttonIndex == 1){
        [self showAlbum];
    }
}
#pragma clang diagnostic pop

-(void)useCameraForMedia:(MediaType)type{
    switch (type) {
        case MediaType_Image:{
            [self photo];
        }break;
        case MediaType_Movie:{
            [self movie];
        }break;
        default:
            break;
    }
}
-(void)movie{
    if ([self isCameraAvailable]) {
        NSArray *avariahleSourceTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        BOOL isCouldGetCaptureVideo = NO;
        NSString *mediaType = (NSString*)kUTTypeMovie;
        for (NSString *type in avariahleSourceTypes) {
            if ([type isEqualToString:mediaType]) {
                isCouldGetCaptureVideo = YES;
                break;
            }
        }
        if (!isCouldGetCaptureVideo) {
            NSLog(@"sorry, capturing video is not supported.!!!");
            [self showAlbum];
            [self showMessage:@"无法使用摄像头"];
            return;
        }
        self.imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置图像选取控制器的类型为动态图像
        self.imgPickerCtrl.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, nil];
        //设置摄像图像品质
        self.imgPickerCtrl.videoQuality = UIImagePickerControllerQualityTypeHigh;
        //设置最长摄像时间
        self.imgPickerCtrl.videoMaximumDuration = 30;
        //允许用户进行编辑
        self.imgPickerCtrl.allowsEditing = YES;
        [self resetImgPickerCtrlAppearanceWithCurrProjMainColor];
        [self presentViewController:self.imgPickerCtrl animated:YES completion:NULL];
       
    }else{
        NSLog(@"sorry, no camera or camera is unavailable.");
        [self showAlbum];
        [self showMessage:@"无法使用摄像头"];
        return;
    }
}
-(void)resetImgPickerCtrlAppearanceWithCurrProjMainColor{
    [self.imgPickerCtrl.navigationBar setBarTintColor:NavBarBackgroundColor];// navigation bar background.
    [self.imgPickerCtrl.navigationBar setTintColor:NavBarTextColor];// setBtnTitleColor
    [self.imgPickerCtrl.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:NavBarTextColor}];//specify the
}
-(void)photo{
    if ([self isCameraAvailable]) {
        // UIImagePickerControllerSourceTypeCamera-->通过摄像头可获取的 资源类型
        NSArray *avariahleSourceTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        BOOL isCouldGetImage = NO;
        NSString *mediaType = (NSString*)kUTTypeImage;
        for (NSString *type in avariahleSourceTypes) {
            if ([type isEqualToString:mediaType]) {
                isCouldGetImage = YES;
                break;
            }
        }
        if (!isCouldGetImage) {
            NSLog(@"sorry, taking picture is not supported.");
            return;
        }
        //允许用户进行编辑
        self.imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imgPickerCtrl.allowsEditing = YES;
        self.imgPickerCtrl.mediaTypes = [NSArray arrayWithObjects:mediaType, nil];
        
        [self resetImgPickerCtrlAppearanceWithCurrProjMainColor];
        [self presentViewController:self.imgPickerCtrl animated:YES completion:NULL];
    }else{
        NSLog(@"sorry, no camera or camera is unavailable.");
        
        [self showMessage:@"无法使用摄像头"];
        [self showAlbum];
        return;
    }
}
-(void)showAlbum{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imgPickerCtrl.sourceType = sourceType;
    if (!self.imgPickerCtrl.mediaTypes) {
        self.imgPickerCtrl.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie,(NSString*)kUTTypeImage, nil];
    }
    [self resetImgPickerCtrlAppearanceWithCurrProjMainColor];
    [self presentViewController:self.imgPickerCtrl animated:YES completion:NULL];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
- (void)showMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
    });
}

/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */
-(UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond withUrl:(NSURL *)url{
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    CGImageRelease(cgImage);
    return image;
}
#pragma clang diagnostic pop
///**
// Call
// @param picker 管理者对象
// @param info 获取到的资源的所有信息
// */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //对获取的资源进行类型判断,然后进入下一步操作(使用图片资源进行展示(视频资源进行播放)？)
    //打印出字典中的内容
    NSLog(@"get the media info: %@", info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {//对不同类型 媒体文件  进行处理//kUTTypeImage 抽象图片对象
        if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//通过摄像头获取到的media 文件
            //获取用户编辑之后的图像
            UIImage *edictImage = [info objectForKey:UIImagePickerControllerEditedImage];
            //将该图像保存到媒体库中
            UIImageWriteToSavedPhotosAlbum(edictImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            NSString *noticeName  = @"capatureSuccess";
            [[NSNotificationCenter defaultCenter]postNotificationName:noticeName object:edictImage];
            !self.handlerComplectionBlock?:self.handlerComplectionBlock(MediaType_Image,edictImage);
        }else{//通过相册 得到的media文件
            UIImage *img = info[UIImagePickerControllerOriginalImage];//获取图片
            //对图片进行处理:
            //1.显示
            //        self.imgV.image = img;//显示
            //2.包装成NSData
            NSData *imgData  = UIImageJPEGRepresentation(img, 1.0);
            //上传处理或者。。。。
//            self.imgV.image = [UIImage imageWithData:imgData];

            NSString *noticeName  = @"capatureSuccess";
            [[NSNotificationCenter defaultCenter]postNotificationName:noticeName object:img];
            !self.handlerComplectionBlock?:self.handlerComplectionBlock(MediaType_Image,img);
        }
    }else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]){//kUTTypeMovie 抽象 视频、音频对象
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"mediaURL:%@",mediaURL);
        NSData *data = nil;
        NSLog(@"dataLength:%zd",data.length);
        data = [NSData dataWithContentsOfURL:mediaURL];
        NSLog(@"dataLength:%zd",data.length);
//        self.movieData = [NSData dataWithData:data];
        
//        self.movieMediaURL = mediaURL;
        UIImage *thmailImg = [self thumbnailImageRequest:1.0 withUrl:mediaURL];
        NSLog(@"thmailImg:%@",thmailImg);
//        [self.picArr addObject:thmailImg];
//        [self.refreshPicContainerCommand execute:self.picArr];
        
        if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //写入相册
            if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
                NSError *err = nil;

                [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:mediaURL];
                } error:&err];
                if (!err) {
                    NSLog(@"captured video saved with no error.");
                }else
                {
                    NSLog(@"error occured while saving the video:%@", err);
                }

            }else{
                // Adds a video to the saved photos album. The optional completionSelector should have the form:
                //  - (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
                //                UIKIT_EXTERN void UISaveVideoAtPathToSavedPhotosAlbum(NSString *videoPath, __nullable id completionTarget, __nullable SEL completionSelector, void * __nullable contextInfo) NS_AVAILABLE_IOS(3_1) __TVOS_PROHIBITED;

                ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc]init];
                [assetLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL completionBlock:^(NSURL *assetURL, NSError *error) {
                    if (!error) {
                        NSLog(@"captured video saved with no error.");
                    }else
                    {
                        NSLog(@"error occured while saving the video:%@", error);
                    }
                }];
            }
        }else{//播放
           
//            self.movieMediaURL = mediaURL;
            UIImage *thmailImg = [self thumbnailImageRequest:1.0 withUrl:mediaURL];
            NSLog(@"thmailImg:%@",thmailImg);
//            [self.picArr addObject:thmailImg];
//            [self.refreshPicContainerCommand execute:self.picArr]
        }
        !self.handlerComplectionBlock?:self.handlerComplectionBlock(MediaType_Movie,data);
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UIImagePickerControllerDelegate ， UINavigationControllerDelegate
-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)err contextInfo:(void *)context{
    if (!err) {
        NSLog(@"picture saved with no error.");
    }
    else{
        NSLog(@"error occured while saving the picture%@", err);
    }
}
+ (void)compressVideoWithSourceVideoPathString:(NSString *)sourceVideoPathString
                                  CompressType:(NSString *)compressType
                          CompressSuccessBlock:(void(^)(NSString*))compressSuccessBlock
                           CompressFailedBlock:(void(^)(void))compressFailedBlock
                       CompressNotSupportBlock:(void(^)(void))compressNotSupportBlock {
    
    // 源视频路径
    NSURL *sourceVideoPathUrl = [NSURL fileURLWithPath:sourceVideoPathString];
    // 利用源视频路径将源视频转化为 AVAsset 多媒体载体对象
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceVideoPathUrl options:nil];
    
    // 源视频载体对象支持的压缩格式
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    // 源视频载体对象支持的压缩格式中是否包含我们选择的压缩格式
    if ([compatiblePresets containsObject:compressType]) {
        
        // 存放压缩视频的文件夹
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *compressVideoFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/compressVideoFolder"];
        if (![fileManager fileExistsAtPath:compressVideoFolder]) {
            
            [fileManager createDirectoryAtPath:compressVideoFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        // 用当前系统时间给文件命名, 避免因名字重复而覆盖存储
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString *currentDateString = [formatter stringFromDate:[NSDate date]];
        
        /**
         *  第一个参数 : 要压缩的 AVAsset 对象
         第二个参数 : 我们选择的压缩方式
         */
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:compressType];
        // 压缩视频的输出路径
        NSString *compressVideoPathString = [compressVideoFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"compressVideo-%@.mp4", currentDateString]];
        NSURL *compressFilePathUrl = [NSURL fileURLWithPath:compressVideoPathString];
        exportSession.outputURL = compressFilePathUrl;
        // 压缩文件的输出格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        // 压缩文件应保证优化网络使用
        exportSession.shouldOptimizeForNetworkUse = YES;
        // 开始压缩
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                compressSuccessBlock(compressVideoPathString);
            }else {
                compressFailedBlock();
            }
        }];
    }else {
        compressNotSupportBlock();
    }
}
//删除压缩后视频的方法
+ (void)deleteCompressVideoFromPath:(NSString *)compressVideoPathString {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *compressVideoFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/compressVideoFolder"];
    if ([fileManager fileExistsAtPath:compressVideoFolder]) {
        [fileManager removeItemAtPath:compressVideoFolder error:nil];
    }
}
// 视频base64编码
+ (void)base64StringFromString:(NSString *)filePathString
                  SuccessBlock:(void(^)(NSString*))success
                   FailedBlock:(void(^)(void))failed {
    
    // 获取文件的二进制数据 data
    NSData *data = [NSData dataWithContentsOfFile:filePathString];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 转码 --> 码文
        NSString *base64String = [data base64EncodedStringWithOptions:0];
        
        if (base64String) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(base64String);
            });
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failed();
            });
        }
    });
}

//图片base64转码
+ (void)base64StringFromData:(NSData *)fileData
                SuccessBlock:(void(^)(NSString*))success
                 FailedBlock:(void(^)(void))failed {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 转码 --> 码文
        NSString *base64String = [fileData base64EncodedStringWithOptions:0];
        
        if (base64String) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                success(base64String);
            });
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failed();
            });
        }
    });
}

- (void)compressedVideoOtherMethodWithURL:(NSURL *)url compressionType:(NSString *)compressionType compressionResultPath:(CompressionVideoSuccessBlock)resultPathBlock {
    
    NSString *resultPath;
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    CGFloat totalSize = (float)data.length / 1024 / 1024;
    NSLog(@"视频压缩前大小 %f", totalSize);
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    // 所支持的压缩格式中是否有 所选的压缩格式
    if ([compatiblePresets containsObject:compressionType]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:compressionType];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];// 用时间, 给文件重新命名, 防止视频存储覆盖,
        
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        BOOL isExists = [manager fileExistsAtPath:CompressionVideoPaht];
        
        if (!isExists) {
            
            [manager createDirectoryAtPath:CompressionVideoPaht withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        resultPath = [CompressionVideoPaht stringByAppendingPathComponent:[NSString stringWithFormat:@"outputJFVideo-%@.mov", [formater stringFromDate:[NSDate date]]]];
        
        NSLog(@"resultPath = %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                 
                 NSData *data = [NSData dataWithContentsOfFile:resultPath];
                 
                 float memorySize = (float)data.length / 1024 / 1024;
                 NSLog(@"视频压缩后大小 %f", memorySize);
                 
                 resultPathBlock (resultPath, memorySize);
                 
             } else {
                 
                 NSLog(@"压缩失败");
             }
             
         }];
        
    } else {
        NSLog(@"不支持 %@ 格式的压缩", compressionType);
    }
}

- (void)compressedImage:(UIImage *)image compressionResultPath:(CompressionImageSuccessBlock)resultPathBlock{
    [NSRTCImageCompressorKit CompressToImageAtBackgroundWithImage:image ShowSize:image.size FileSize:200 block:^(UIImage *  resultImage) {
        !resultPathBlock?:resultPathBlock(resultImage);
    }];
}
/**
 
 *  清楚沙盒文件中, 压缩后的视频所有, 在使用过压缩文件后, 不进行再次使用时, 可调用该方法, 进行删除
 
 */

+ (void)removeCompressedVideoFromDocuments {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:CompressionVideoPaht]) {
        [[NSFileManager defaultManager] removeItemAtPath:CompressionVideoPaht error:nil];
    }
}
@end
