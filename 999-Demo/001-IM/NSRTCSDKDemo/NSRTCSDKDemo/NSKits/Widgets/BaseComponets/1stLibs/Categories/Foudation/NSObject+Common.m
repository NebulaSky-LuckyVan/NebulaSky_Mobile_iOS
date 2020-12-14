//
//  NSObject+Common.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSObject+Common.h"
#import "UIView+Common.h"


@implementation NSObject (Common)
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles andAction:(CallAlertButonClickBlock)block andParentView:(UIView *)view {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelButtonTitle) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            !block?:block(0);
        }];
        [alert addAction:action];
    }
    
    for (int i=0; i < otherButtonTitles.count; i++) {
        NSString *otherTitle = otherButtonTitles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            if (cancelButtonTitle) {
                !block?:block(i+1);
            } else {
                !block?:block(i);
            }
        }];
        [alert addAction:action];
    }
    if (view == nil) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    else {
        [[view viewController] presentViewController:alert animated:YES completion:nil];
    }
    
}
@end

@implementation NSObject (PerformBlock)
- (void)excuteBlock:(ExcuteHandlerBlock)block{
    __weak typeof(self) weakSelf = self;
    !block?:block(weakSelf);
}
- (void)perform:(ExcuteHandlerBlock)handler after:(NSTimeInterval)delay{
    !handler?:[self performSelector:@selector(excuteBlock:) withObject:handler afterDelay:delay];
}
- (void)perform:(ExcuteHandlerBlock)handler onThread:(NSThread *)thread after:(NSTimeInterval)delay{
    [self perform:^(id selfPtr) {
        !handler?:[self performSelector:@selector(excuteBlock:) onThread:thread withObject:handler waitUntilDone:NO];
    } after:delay];
    
}
- (void)perform:(ExcuteHandlerBlock)handler onMainThreadAfter:(NSTimeInterval)delay{
    [self perform:^(id selfPtr) {
        !handler?:[self performSelectorOnMainThread:@selector(excuteBlock:) withObject:handler waitUntilDone:NO];
    } after:delay];
}
- (void)perform:(ExcuteHandlerBlock)handler onBackgroundAfter:(NSTimeInterval)delay{
    [self perform:^(id selfPtr) {
        !handler?:[self performSelectorInBackground:@selector(excuteBlock:) withObject:handler];
    } after:delay];
}

@end

@implementation NSObject (Properties)

+(void)creatPropertyCodeWithDict:(NSDictionary *)dict{
    NSMutableString *codes = [NSMutableString string];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSLog(@"%@", [value class]);//先获取类型列表
        //属性类型
        NSString *PropertyType;
        //属性名
        NSString *PropertyName = [NSString stringWithFormat:@"%@",key];
        //内存管理策略
        NSString *Policy;
        //属性配置代码
        NSString *PropertyCode;
        
        if ([value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]) {
            PropertyType = @"NSDate*";
            Policy = @"strong";
        }else if([value isKindOfClass:NSClassFromString(@"__NSCFData")]){
            PropertyType = @"NSData*";
            Policy = @"strong";
        }else if([value isKindOfClass:NSClassFromString(@"__NSCFArray")]||[value isKindOfClass:NSClassFromString(@"__NSArray0")]||[value isKindOfClass:NSClassFromString(@"__NSArrayI")]||[value isKindOfClass:NSClassFromString(@"__NSSingleObjectArrayI")]||[value isKindOfClass:NSClassFromString(@"__NSArrayM")]){
            PropertyType = @"NSArray*";
            Policy = @"strong";
        }else if([value isKindOfClass:NSClassFromString(@"__NSCFDictionary")]||[value isKindOfClass:NSClassFromString(@"__NSDictionary0")]||[value isKindOfClass:NSClassFromString(@"__NSDictionaryM")]||[value isKindOfClass:NSClassFromString(@"__NSDictionaryI")]){
            PropertyType = @"NSDictionary*";
            Policy = @"strong";
        }else if([value isKindOfClass:NSClassFromString(@"__NSCFString")]||[value isKindOfClass:NSClassFromString(@"NSTaggedPointerString")]){
            PropertyType = @"NSString*";
            Policy = @"strong";
        }else if([value isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            PropertyType = @"NSNumber*";
            Policy = @"strong";
        }else if([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            PropertyType = @"BOOL";
            Policy = @"assign";
        }else if([value isKindOfClass:NSClassFromString(@"NSNull")]){
            PropertyType = @"NSString*";
            Policy = @"strong";
        }
        PropertyCode = [NSString stringWithFormat:@"/*<#desc#>*/\n@property (nonatomic,%@) %@ %@;",Policy,PropertyType,PropertyName];
        [codes appendFormat:@"\n%@\n",PropertyCode];
    }];
    NSLog(@"%@",codes);
    //然后把打印出来的拷贝,复制到对象的声明区域就可以了
}
@end
