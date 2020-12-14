//
//  FMWebKitConstant.h
//  H5Container
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 本地验证相关信息存储的key
#define KEY_LocalAuthenticationState @"YNETLocalAuthenticationState"
#define KEY_LocalAuthenticationState_Change @"YNETLocalAuthenticationStateChange"

@interface ServiceConstant : NSObject

#pragma mark - KV存储的key命名定义
//登录用户信息存储
extern NSString * const KEY_UserLoginTime;
extern NSString * const KEY_UserIconData;
extern NSString * const KEY_UserLoginInfo;
extern NSString * const BUSINESS_UserLoginInfo;
extern NSString * const KEventTrackSeedID_Login_success;
// 定位城市信息
/*
 cityName country longitude provinceName districtName latitude roadName fullAddress
 */
extern NSString * const KEY_LocationCityInfo;
//简易注册用户禁止跳转的地址
extern NSString * const KEY_SimpleRegistInterceptUrls;
//普通存储
extern NSString * const BUSINESS_CommonStorageCache;
//设备指纹信息存储
extern NSString * const KEY_UserAccountMobileInfo;
//设备屏幕亮度
extern NSString * const KEY_PhoneBrightness;
//浏览器拼接的UserAgent
extern NSString * const KEY_WebViewUserAgent;

#pragma mark - 版本信息 旧
//显示启动引导与新手引导的标识存储
//首页新手蒙版
extern NSString * const KEY_isShowHomePageUserGuide;
//我的新手蒙版
extern NSString * const KEY_isShowMineUserGuide;
// 引导页显示
extern NSString * const KEY_isShowAppGuide;
extern NSString * const BUSINESS_UserNormalInfo;

//手势相关信息存储
//存储则隐藏路径,移除则显示路径
extern NSString * const KEY_Gesture_Password;
extern NSString * const KEY_Gesture_Password_Path;
extern NSString * const KEY_Gesture_Password_Mobile;

//指纹识别信息存储
extern NSString *const KEY_DeviceMessage;
extern NSString *const BUSINESS_DeviceMessage;

//搜索相关信息
extern NSString * const KEY_Search_LabelDatas;
extern NSString * const KEY_Search_HistorywordsDic;
extern NSString * const KEY_Search_FunctionItems_Not_Login;

//理财产品数据存储
extern NSString * const KEY_FinancingProductData;
extern NSString * const BUSINESS_FinancingProductData;

#pragma mark - 楼层缓存数据 旧

//首页数据存储
extern NSString * const BUSINESS_FloorData;

extern NSString * const KEY_HomeFloorData;
// 首页 自定义菜单数据
extern NSString * const KEY_HomeGridData;
// 全部菜单 这个宫格的数据
extern NSString * const KEY_AllGridItemData;
// 理财数据存储
extern NSString * const KEY_FinanceFloorData;

// 首页理财话术列表
extern NSString * const KEY_HomeFinancingPactListData;
// 首页理财产品模板集合
extern NSString * const KEY_HomeiQueryProductListData;
// 投资理财 理财产品模板集合
extern NSString * const KEY_FinancingiQueryProductListData;
// 理财话术列表
extern NSString * const KEY_FinancingPactListData;

extern NSString * const BUSINESS_FinancingData;
//信用卡页面数据存储
extern NSString * const KEY_CreditCardData;

extern NSString * const BUSINESS_CreditCardData;

//生活服务页面数据存储

extern NSString * const KEY_LifeServeFloorData;
extern NSString * const KEY_MineFloorData;

// 更多页面

extern NSString * const KEY_MorePageFloorData ;

// 登录超时
extern NSString * const SESSION_TIMEOUT_NOTIFICITION_WJM;

// 开机广告图数据存储
extern NSString * const KEY_StarAdvertImageData;

extern NSString * const BUSINESS_StarAdvertData;
//积分白名单通知
extern NSString * const WHITE_LIST_DATA;

#pragma mark - 通知 旧
// 投资理财 -> 我的收藏 点击通知
extern NSString * const kNotificationFinancingMyCollectionCellClicked;
// 投资理财 -> 自研理财 点击通知
extern NSString * const kNotificationFinancingZiYanFundCellClicked;
// 投资理财 -> 代销理财 点击通知
extern NSString * const kNotificationFinancingDaiXiaoFundCellClicked;
// 投资理财 -> 基金 点击通知
extern NSString * const kNotificationFinancingFundCellClicked;
//通知增加会员积分蒙版
extern NSString * const kNotification_AddIntergalUserMask;
// 首页新手蒙版结束
extern NSString * const kNotificationHomeUserMaskDisappear;

#pragma mark - JSApi的错误码
// 入参格式错误
extern NSString * const JSApiParameterTypeErrorCodeString;
// 操作取消
extern NSString * const JSApiOperationCancelErrorCodeString;
// 代码异常
extern NSString * const JSApiExceptionErrorCodeString;
// 未知错误
extern NSString * const JSApiUnkonwErrorCodeString;

#pragma mark - 楼层风格存储
extern NSString * const KEY_CacheHomePageStyleType;
extern NSString * const KEY_CacheFinancePageStyleType;
extern NSString * const KEY_CacheLivePageStyleType;
extern NSString * const KEY_CacheMinePageStyleType;
#pragma mark - 版本号存储
// 最新图片服务器地址
extern NSString * const KEY_CacheImgServerUrl;
// 最新图片服务器地址
extern NSString * const KEY_CacheSplashVersion;
// 获取最新插屏版本号
extern NSString * const KEY_CacheAdVersion;
// 获取App版本号
extern NSString * const KEY_CacheAppVersion;
// 获取服务器时间
extern NSString * const KEY_CacheSysDate;
// 获取菜单总版本
extern NSString * const KEY_CacheMenuGroupVersion;
// 获取菜单版本集合
// index_tree:首页，cards_tree:信用卡页面，finance_tree:理财页面，live_tree:生活页面，own_tree:我的页面，all_tree:全部
extern NSString * const KEY_CacheMenuVersionList;
// 获取最新菜单版本
extern NSString * const KEY_CacheNewHomeMenuVersion;
extern NSString * const KEY_CacheNewFinanceMenuVersion;
extern NSString * const KEY_CacheNewLiveMenuVersion;
extern NSString * const KEY_CacheNewOwnMenuVersion;
extern NSString * const KEY_CacheNewAllMenuVersion;
// 获取楼层版本集合
extern NSString * const KEY_CachePageFloorVersionList;
extern NSString * const KEY_CacheNewHomePageFloorVersion;
extern NSString * const KEY_CacheNewFinancePageFloorVersion;
extern NSString * const KEY_CacheNewLivePageFloorVersion;
extern NSString * const KEY_CacheNewOwnPageFloorVersion;
extern NSString * const KEY_CacheNewMorePageFloorVersion;
// 获取当前业务菜单版本
extern NSString * const KEY_CacheCurrentHomeMenuVersion;
extern NSString * const KEY_CacheCurrentFinanceMenuVersion;
extern NSString * const KEY_CacheCurrentLiveMenuVersion;
extern NSString * const KEY_CacheCurrentOwnMenuVersion;
extern NSString * const KEY_CacheCurrentAllMenuVersion;
// 获取当前业务楼层版本
extern NSString * const KEY_CacheCurrentHomePageFloorVersion;
extern NSString * const KEY_CacheCurrentFinancePageFloorVersion;
extern NSString * const KEY_CacheCurrentLivePageFloorVersion;
extern NSString * const KEY_CacheCurrentOwnPageFloorVersion;
extern NSString * const KEY_CacheCurrentMorePageFloorVersion;
// 首页业务菜单
extern NSString * const KEY_CacheCurrentIndexMenuList;

#pragma mark - 闪屏广告存储
extern NSString * const KEY_CacheSplashStyleUIArray;
extern NSString * const KEY_CacheSplashStyleAllUrlkeyArray;
extern NSString * const KEY_CacheSplashStylePlayUrlkeyArray;

#pragma mark - 闪屏时间策略存储
extern NSString * const KEY_CacheStartSplashSkipTimeArray;
extern NSString * const KEY_CacheAPPBackSplashAfternoonDate;
extern NSString * const KEY_CacheAPPBackSplashMorningDate;

#pragma mark - 类名转换的宏定义
// 首页
#define YNETHomePageVC              @"YNETHomeViewController"
// 信用卡
#define YNETCreditPageVC            @"YNETCreditCard2ViewController"
// 去理财
#define YNETFinancingPageVC         @"YNETFinancingViewController"
// 生活服务
#define YNETLifeServePageVC         @"YNETLifeServe2ViewController"
// 我的
#define YNETMinePageVC              @"YNETMineViewController"
// 登录
#define YNETLoginPageVC             @"YNETLoginViewController"


@end
