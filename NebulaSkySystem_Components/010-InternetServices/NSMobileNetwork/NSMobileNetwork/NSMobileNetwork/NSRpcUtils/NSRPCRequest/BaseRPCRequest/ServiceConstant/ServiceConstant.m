//
//  FMWebKitConstant
//  H5Container
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "ServiceConstant.h"


@implementation ServiceConstant

// 定位城市信息
/*
 locality country longitude adminArea subLocality latitude thoroughfare fullAddress
 */
NSString *const KEY_LocationCityInfo = @"KEY_LocationCityInfo";

NSString *const KEventTrackSeedID_Login_success = @"login_success";
NSString *const KEY_UserLoginInfo = @"YNETUserLoginInfo";
NSString *const BUSINESS_UserLoginInfo = @"YNETLoginBusiness";
NSString *const KEY_SimpleRegistInterceptUrls = @"APP_SIMPLE_REGIST_INTERCEPT_URLS";
NSString *const BUSINESS_CommonStorageCache = @"YNETCommonStorageCache";
NSString *const KEY_UserAccountMobileInfo = @"YNETUserAccountMobileInfo";
#pragma mark - 版本信息 旧

NSString *const KEY_UserLoginTime = @"YNETUserLoginTime";
NSString *const KEY_UserIconData = @"YNETUserIconData";
NSString *const KEY_isShowHomePageUserGuide = @"YNETIsShowHomePageUserGuide";
NSString *const KEY_isShowMineUserGuide = @"YNETIsShowMineUserGuide";
NSString *const KEY_isShowAppGuide = @"YNETIsShowAppGuide";
NSString *const BUSINESS_UserNormalInfo = @"YNETUserNormalInfoBusiness";
NSString *const KEY_isFirstIntoAppStartAdView = @"YNETFirstIntoAppStartAdView";
NSString *const KEY_Gesture_Password_Path = @"YNETGesturePasswordPath";
NSString *const KEY_Gesture_Password_Mobile = @"YNETGesturePasswordMobile";
NSString *const KEY_Search_LabelDatas = @"YNETSearchLabelDatas";
NSString *const KEY_Search_HistorywordsDic = @"YNETSearchHistoryWordsDic";
NSString *const KEY_Search_FunctionItems_Not_Login = @"YNETSearchNotLoginFunctionItems";
NSString *const KEY_FinancingProductData = @"YNETFinancingProductData";
NSString *const BUSINESS_FinancingProductData = @"YNETFinancingProductDataBusiness";
NSString *const KEY_PhoneBrightness = @"YNETPhoneBrightness";
NSString *const KEY_WebViewUserAgent = @"YNETWebViewUserAgent";
NSString *const KEY_Gesture_Password = @"YNETGesturePassword";

#pragma mark - 楼层缓存数据
NSString *const BUSINESS_FloorData = @"BUSINESS_FloorData";
//首页数据存储
NSString *const KEY_HomeFloorData = @"KEY_HomeFloorData";
NSString *const KEY_HomeGridData = @"setCustomGridList";
// 全部菜单 这个宫格的数据
NSString *const KEY_AllGridItemData = @"KEY_AllGridItemData";
// 理财数据存储
NSString *const KEY_FinanceFloorData = @"KEY_FinanceFloorData";

NSString *const KEY_HomeFinancingPactListData = @"YNETHomeFinancingPactListData";
NSString *const KEY_HomeiQueryProductListData = @"YNETHomeiQueryProductListData";

NSString *const KEY_FinancingiQueryProductListData = @"YNETFinancingiQueryProductListData";
NSString *const KEY_FinancingPactListData = @"FinancingPactListData";
NSString *const BUSINESS_FinancingData = @"YNETFinancingDataBusiness";
NSString *const KEY_CreditCardData = @"YNETCreditCardData";
NSString *const BUSINESS_CreditCardData_White = @"YNETCreditCardDataBusiness_White";

NSString *const KEY_LifeServeFloorData = @"KEY_LifeServeFloorData";
NSString *const KEY_MineFloorData = @"KEY_MineFloorData";


NSString *const KEY_MorePageFloorData = @"KEY_MorePageFloorData";
 


NSString *const SESSION_TIMEOUT_NOTIFICITION_WJM = @"doSessionTimeOutFun";
NSString *const KEY_StarAdvertImageData = @"YNETStarAdvertImageData";
NSString *const BUSINESS_StarAdvertData = @"YNETStartAdvertViewBusiness";
NSString *const WHITE_LIST_DATA = @"whiteLsit";

#pragma mark - 通知 旧
NSString *const kNotificationFinancingMyCollectionCellClicked = @"kNotificationFinancingMyCollectionCellClicked";
NSString *const kNotificationFinancingZiYanFundCellClicked = @"kNotificationFinancingZiYanFundCellClicked";
NSString *const kNotificationFinancingDaiXiaoFundCellClicked = @"kNotificationFinancingDaiXiaoFundCellClicked";
NSString *const kNotificationFinancingFundCellClicked = @"kNotificationFinancingFundCellClicked";
NSString *const kNotification_AddIntergalUserMask = @"Notification_AddIntergalUserMask";
NSString *const kNotificationHomeUserMaskDisappear = @"kNotificationHomeUserMaskDisappear";

#pragma mark - JSApi的错误码
NSString * const JSApiParameterTypeErrorCodeString = @"1000";
NSString * const JSApiOperationCancelErrorCodeString = @"2000";
NSString * const JSApiExceptionErrorCodeString = @"3000";
NSString * const JSApiUnkonwErrorCodeString = @"4000";

#pragma mark - 楼层风格存储
NSString *const KEY_CacheHomePageStyleType = @"KEY_CacheHomePageStyleType";
NSString *const KEY_CacheFinancePageStyleType = @"KEY_CacheFinancePageStyleType";
NSString *const KEY_CacheLivePageStyleType = @"KEY_CacheLivePageStyleType";
NSString *const KEY_CacheMinePageStyleType = @"KEY_CacheMinePageStyleType";

#pragma mark - 版本号存储
// 最新图片服务器地址
NSString *const KEY_CacheImgServerUrl = @"KEY_CacheImgServerUrl";
// 获取最新闪屏版本号
NSString *const KEY_CacheSplashVersion = @"KEY_CacheSplashVersion";
// 获取最新插屏版本号
NSString *const KEY_CacheAdVersion = @"KEY_CacheAdVersion";
// 获取App版本号
NSString *const KEY_CacheAppVersion = @"KEY_CacheAppVersion";
// 获取服务器时间
NSString *const KEY_CacheSysDate = @"KEY_CacheSysDate";
// 获取菜单总版本
NSString *const KEY_CacheMenuGroupVersion = @"KEY_CacheMenuGroupVersion";
// 获取菜单版本集合
NSString *const KEY_CacheMenuVersionList = @"KEY_CacheMenuVersionList";

// 获取最新菜单版本
NSString *const KEY_CacheNewHomeMenuVersion = @"KEY_CacheNewHomeMenuVersion";
NSString *const KEY_CacheNewFinanceMenuVersion = @"KEY_CacheNewFinanceMenuVersion";
NSString *const KEY_CacheNewLiveMenuVersion = @"KEY_CacheNewLiveMenuVersion";
NSString *const KEY_CacheNewOwnMenuVersion = @"KEY_CacheNewOwnMenuVersion";
NSString *const KEY_CacheNewAllMenuVersion = @"KEY_CacheNewAllMenuVersion";
// 获取楼层版本集合
NSString *const KEY_CachePageFloorVersionList = @"KEY_CachePageFloorVersionList";

NSString *const KEY_CacheNewHomePageFloorVersion = @"KEY_CacheNewHomePageFloorVersion";
NSString *const KEY_CacheNewFinancePageFloorVersion = @"KEY_CacheNewFinancePageFloorVersion";
NSString *const KEY_CacheNewLivePageFloorVersion = @"KEY_CacheNewLivePageFloorVersion";
NSString *const KEY_CacheNewOwnPageFloorVersion = @"KEY_CacheNewOwnPageFloorVersion";
NSString *const KEY_CacheNewMorePageFloorVersion = @"KEY_CacheNewMorePageFloorVersion";

// 获取当前业务菜单版本
NSString *const KEY_CacheCurrentHomeMenuVersion = @"KEY_CacheCurrentHomeMenuVersion";
NSString *const KEY_CacheCurrentFinanceMenuVersion = @"KEY_CacheCurrentFinanceMenuVersion";
NSString *const KEY_CacheCurrentLiveMenuVersion = @"KEY_CacheCurrentLiveMenuVersion";
NSString *const KEY_CacheCurrentOwnMenuVersion = @"KEY_CacheCurrentOwnMenuVersion";
NSString *const KEY_CacheCurrentAllMenuVersion = @"KEY_CacheCurrentAllMenuVersion";
// 获取当前业务楼层版本
NSString *const KEY_CacheCurrentHomePageFloorVersion = @"KEY_CacheCurrentHomePageFloorVersion";
NSString *const KEY_CacheCurrentFinancePageFloorVersion = @"KEY_CacheCurrentFinancePageFloorVersion";
NSString *const KEY_CacheCurrentLivePageFloorVersion = @"KEY_CacheCurrentLivePageFloorVersion";
NSString *const KEY_CacheCurrentOwnPageFloorVersion = @"KEY_CacheCurrentOwnPageFloorVersion";
NSString *const KEY_CacheCurrentMorePageFloorVersion = @"KEY_CacheCurrentMorePageFloorVersion";
// 首页业务菜单
NSString *const KEY_CacheCurrentIndexMenuList = @"KEY_CacheCurrentIndexMenuList";

#pragma mark - 闪屏广告存储
NSString *const KEY_CacheSplashStyleUIArray = @"KEY_CacheSplashStyleUIArray";
NSString *const KEY_CacheSplashStyleAllUrlkeyArray = @"KEY_CacheSplashStyleAllUrlkeyArray";
NSString *const KEY_CacheSplashStylePlayUrlkeyArray = @"KEY_CacheSplashStylePlayUrlkeyArray";

#pragma mark - 闪屏时间策略存储
NSString *const KEY_CacheStartSplashSkipTimeArray = @"KEY_CacheStartSplashSkipTimeArray";
NSString *const KEY_CacheAPPBackSplashAfternoonDate = @"KEY_CacheAPPBackSplashAfternoonDate";
NSString *const KEY_CacheAPPBackSplashMorningDate = @"KEY_CacheAPPBackSplashMorningDate";

//指纹识别信息存储
NSString *const KEY_DeviceMessage = @"SDZXDeviceMessage";
NSString *const BUSINESS_DeviceMessage = @"SDZXDeviceMessageBusiness";

@end
