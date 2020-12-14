//
//  NSCheetahRPCHeaderInfo.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSCheetahRPCHeaderInfo.h"
#import <MPDataCenter/MPDataCenter.h>

#import <UTDID/UTDevice.h>
#import <MPPushSDK/MPPushSDK.h>
#import <APMobileNetwork/APMobileNetwork.h>
  
#import "ServiceConstant.h"


#import "sys/utsname.h"

//#import <AdSupport/AdSupport.h>
//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UTDID/UTDevice.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation NSCheetahRPCHeaderInfo

+ (NSDictionary *)headerInfo
{
    // 存入公共参数
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *netWorkType = [NSCheetahRPCHeaderInfo getNetworkStatus]?:@"";
    NSString *ipAddress = [NSCheetahRPCHeaderInfo getIPAddressIPv4:YES]?:@"";
    NSString *mobileType = [NSCheetahRPCHeaderInfo deviceName]?: @"";
    NSString *deviceId = [NSCheetahRPCHeaderInfo deviceID]?: @"";
    NSString *resolution = [NSCheetahRPCHeaderInfo resolution]?: @"";
    NSString *sysVersion = [NSCheetahRPCHeaderInfo OSVersion]?: @"";
    NSString *platFormstr = [NSCheetahRPCHeaderInfo devicePlatForm]?:@"";
    NSString *macValue = [NSCheetahRPCHeaderInfo macaddress];
#if TARGET_IPHONE_SIMULATOR  //模拟器
    platFormstr = @"simulator";
#endif
    // 城市信息
    NSDictionary *locationInfo = [NSCheetahRPCHeaderInfo getDiskCacheForKey:KEY_LocationCityInfo business:BUSINESS_CommonStorageCache extension:APDefaultEncrypt()]?:[NSDictionary dictionary];
    //运营商
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *carrierName;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        carrierName = @"无运营商";
    }else{
        carrierName = [carrier carrierName];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyyMMdd"];
    NSString *transDate = [fm stringFromDate:date];
    [fm setDateFormat:@"HHmmssSSS"];
    NSString *transTime = [fm stringFromDate:date];
    return @{
             @"version":@"1.0,0",
             @"transCode":@"",
             @"srcIP":ipAddress,
             @"srcDeviceID":deviceId,
             @"deviceId":deviceId,
             @"appVersion":appVersion,
             @"globalReqSerialNO":@"",
             @"reqSerialNO":@"",
             @"srcSystemID":@"MB", //源渠道或系统ID，猎豹上送渠道信息：PB：网银、MB：手机银行、WXB：微信银行、DSB：直销银行、内管：IM、商城：SM、支付网关：PG、开放平台：OP
             @"channelScene":@"MB",
             @"bizChannel":@"MB",
             @"channelSort":@"MB",
             @"systemID":@"MB", //手机银行
             @"productCode":@"",
             @"eventCode":@"",
             @"transDate":transDate,
             @"transTime":transTime,
             @"macValue":macValue,
             @"locationInfo":locationInfo,
             @"resolution":resolution,
             @"mobileType":mobileType,
             @"netWorkType":netWorkType,
             @"networkType":netWorkType,
             @"platform":platFormstr,
             @"osVersion":sysVersion,
             @"deviceName":platFormstr,
             @"deviceBrand":@"iOS",
             @"deviceModel":mobileType,
             @"screenSize":resolution,
             @"deviceSystem":@"iOS",
             @"systemVersion":sysVersion,
             @"clientMac":macValue,
             @"carrierName":carrierName,
             @"deviceSystem":@"iOS",
             @"operationSystem":@"iOS",
             @"isCrack" : [NSCheetahRPCHeaderInfo checkDeviceJailBreakState]?@"1":@"0",
             @"mp_sId":[NSCheetahRPCHeaderInfo mpSessionID]?:@"",
             };
}


//===================================//
+ (NSString*)mpSessionID{
    return @"";
}

+ (BOOL)checkDeviceJailBreakState
{
#if TARGET_IPHONE_SIMULATOR  //模拟器
    return NO;
#elif TARGET_OS_IPHONE
    // 常见越狱文件
    NSArray *jailbreakFilePaths = @[
                                    @"/Applications/Cydia.app",
                                    @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                    @"/bin/bash",
                                    @"/usr/sbin/sshd",
                                    @"/etc/apt",
                                    @"/private/var/lib/apt/",
                                    @"/private/var/lib/cydia",
                                    @"/private/var/stash"
                                    ];
    for (NSString *jailbreakFilePath in jailbreakFilePaths)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreakFilePath])
        {
            return YES;
        }
    }
    
    // 读取系统所有的应用名称
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"])
    {
        //        NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
        return YES;
    }
    
    // 读取环境变量
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if(env)
    {
        return YES;
    }
    
    return NO;
#endif
}
/**
 *  获取Mac地址
 *
 *  @return NSString *
 */
+ (NSString *)macaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

// 获取平台 iPhone iPad
+ (NSString *)devicePlatForm
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString containsString:@"iPad"])
    {
        return @"iPad";
    }
    else if ([deviceString containsString:@"iPhone"])
    {
        return @"iPhone";
    }
    return @"Unknown";
}
// 获取系统版本
+ (NSString *)OSVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)resolution
{
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    NSString *strW = [NSString stringWithFormat:@"%f",width];
    NSString *strH = [NSString stringWithFormat:@"%f",height];
    NSString *dot = @".";
    NSRange wdrang = [strW rangeOfString:dot];
    strW = [strW substringToIndex:wdrang.location];
    NSRange hdrang = [strH rangeOfString:dot];
    strH= [strH substringToIndex:hdrang.location];
    NSString *reso = [NSString stringWithFormat:@"%@*%@",strW,strH];
    return reso;
}

// 获取设备ID
+ (NSString *)deviceID
{
    return [UTDevice utdid];
}

// 获取设备型号
+ (NSString *)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([deviceString isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([deviceString isEqualToString:@"iPhone9,2"] ||
        [deviceString isEqualToString:@"iPhone9,4"]) return @"iPhone7Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] ||
        [deviceString isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] ||
        [deviceString isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] ||
        [deviceString isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"] ||
        [deviceString isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    //iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPodTouch";
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPodTouch2G";
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPodTouch3G";
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPodTouch4G";
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPodTouch5G";
    if ([deviceString isEqualToString:@"iPod7,1"])   return @"iPodTouch6G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad2";
    if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad2";
    if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad2";
    if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad2";
    if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad3";
    if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad3";
    if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad3";
    if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad4";
    if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad4";
    if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad4";
    
    //iPad Air
    if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad5,3"])   return @"iPadAir2";
    if ([deviceString isEqualToString:@"iPad5,4"])   return @"iPadAir2";
    
    //iPad pro
    if ([deviceString isEqualToString:@"iPad6,3"])   return @"iPadPro";
    if ([deviceString isEqualToString:@"iPad6,4"])   return @"iPadPro";
    if ([deviceString isEqualToString:@"iPad6,7"])   return @"iPadPro";
    if ([deviceString isEqualToString:@"iPad6,8"])   return @"iPadPro";
    if ([deviceString isEqualToString:@"iPad6,11"] ||
        [deviceString isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([deviceString isEqualToString:@"iPad7,1"] ||
        [deviceString isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([deviceString isEqualToString:@"iPad7,3"] ||
        [deviceString isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    
    //iPad mini
    if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPadmini1G";
    if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPadmini1G";
    if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPadmini1G";
    if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPadmini2";
    if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPadmini2";
    if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPadmini2";
    if ([deviceString isEqualToString:@"iPad4,7"])   return @"iPadmini3";
    if ([deviceString isEqualToString:@"iPad4,8"])   return @"iPadmini3";
    if ([deviceString isEqualToString:@"iPad4,9"])   return @"iPadmini3";
    if ([deviceString isEqualToString:@"iPad5,1"])   return @"iPadmini4";
    if ([deviceString isEqualToString:@"iPad5,2"])   return @"iPadmini4";
    
    if ([deviceString isEqualToString:@"i386"])      return @"iPhoneSimulator";
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhoneSimulator";
    return @"Unknown";
}

+ (NSString *)getIPAddressIPv4:(BOOL)preferIPv4
{
#if TARGET_IPHONE_SIMULATOR  //模拟器
    return @"0.0.0.0";
#elif TARGET_OS_IPHONE
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_CELLULAR @"/" IP_ADDR_IPv4,IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv4,  IOS_CELLULAR @"/" IP_ADDR_IPv4 ] :
    @[ IOS_CELLULAR @"/" IP_ADDR_IPv6,IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv6,  IOS_CELLULAR @"/" IP_ADDR_IPv6 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
#endif
}

+ (NSDictionary *)getIPAddresses{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
/**
 *  获取网络类型
 *
 *  @return NSString *
 */
+ (NSString *)getNetworkStatus
{
    DTReachability *reachability = [DTReachability sharedDTReachability];
//    SAReachability *reachability = [SAReachability reachabilityForInternetConnection];
    MPAASNetworkStatus status = reachability.networkStatus;

    NSString* network = @"NULL";
    if (status == MPAASReachableViaWiFi) {
        network = @"WIFI";
        return network;
    }
    else
    {
        CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];  //创建一个CTTelephonyNetworkInfo对象
        NSString *currentStatus  = networkStatus.currentRadioAccessTechnology; //获取当前网络描述
        
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
            //GPRS网络
            return @"2G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
            //2.75G的EDGE网络
            return @"2G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
            //3G WCDMA网络
            return @"3G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
            //3.5G网络
            return @"3G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
            //3.5G网络
            return @"3G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
            //CDMA2G网络
            return @"2G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
            //CDMA的EVDORev0(应该算3G吧?)
            return @"3G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
            //CDMA的EVDORevA(应该也算3G吧?)
            return @"3G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
            //CDMA的EVDORev0(应该还是算3G吧?)
            return @"3G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
            //eHRPD网络
            return @"3G";
        }
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
            //LTE4G网络
            return @"4G";
        }
    }
    return @"未知网络";
}
+ (id)getDiskCacheForKey:(NSString *)key business:(NSString*)business extension:(APDataCrypt*)extension
{
    NSDictionary *alldata;
    if (extension)
    {
        
        alldata = [[[APDataCenter defaultDataCenter]commonPreferences] objectForKey:key business:business extension:extension];
    }
    else
    {
        alldata = [[[APDataCenter defaultDataCenter]commonPreferences] objectForKey:key business:business];
    }
    return alldata;
}

@end
