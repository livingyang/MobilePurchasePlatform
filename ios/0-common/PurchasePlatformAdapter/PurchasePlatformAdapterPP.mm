//
//  PurchasePlatformAdapterStub.cpp
//  PurchasePlatformDemo
//
//  Created by 中 青宝 on 13-12-17.
//  Copyright (c) 2013年 zqgame. All rights reserved.
//

#include "PurchasePlatformAdapter.h"

#include <iostream>
using std::cout;
using std::endl;

#include <PPAppPlatformKit/PPAppPlatformKit.h>
#pragma mark -
#pragma mark PurchasePlatformNotificationReceiver

@interface PPDelegate : NSObject <PPAppPlatformKitDelegate>

+ (PPDelegate *)instance;

@end

@implementation PPDelegate

+ (PPDelegate *)instance
{
    static PPDelegate *delegate = nil;
    
    if (delegate == nil)
    {
        delegate = [[PPDelegate alloc] init];
    }
    
    return delegate;
}

- (void)ppPayResultCallBack:(PPPayResultCode)paramPPPayResultCode
{
    PurchasePlatformDictionary dic;
    dic["platform"] = "pp";
    PurchasePlatformAdapter::instance()->getDelegate()->onPurchase(dic);
}

- (void)ppVerifyingUpdatePassCallBack
{}

- (void)ppLoginStrCallBack:(NSString *)paramStrToKenKey
{
    PurchasePlatformDictionary dic;
    dic["platform"] = "pp";
    PurchasePlatformAdapter::instance()->getDelegate()->onLogin(dic);
}

- (void)ppLoginHexCallBack:(char *)paramHexToKen
{
    PurchasePlatformDictionary dic;
    dic["platform"] = "pp";
    PurchasePlatformAdapter::instance()->getDelegate()->onLogin(dic);
}

- (void)ppCloseWebViewCallBack:(PPWebViewCode)paramPPWebViewCode
{}

- (void)ppClosePageViewCallBack:(PPPageCode)paramPPPageCode
{}

- (void)ppLogOffCallBack
{}

@end

// 注意，PPAppPlatformKit的初始化，要求在界面库初始化完成之后调用，具体可以看pp demo的AppDelegate代码
void PurchasePlatformAdapter::initial()
{
    [[PPAppPlatformKit sharedInstance] setAppId:2269 AppKey:@"58dbd4f880e6171de0745bef18218811"];
    [[PPAppPlatformKit sharedInstance] setIsNSlogData:YES];
    [[PPAppPlatformKit sharedInstance] setRechargeAmount:10];
    [[PPAppPlatformKit sharedInstance] setIsLongComet:YES];
    [[PPAppPlatformKit sharedInstance] setIsLogOutPushLoginView:YES];
    [[PPAppPlatformKit sharedInstance] setIsOpenRecharge:YES];
    [[PPAppPlatformKit sharedInstance] setCloseRechargeAlertMessage:@"关闭充值提示语"];
    [PPUIKit sharedInstance];
    
    
    [PPUIKit setIsDeviceOrientationLandscapeLeft:YES];
    [PPUIKit setIsDeviceOrientationLandscapeRight:YES];
    [PPUIKit setIsDeviceOrientationPortrait:YES];
    [PPUIKit setIsDeviceOrientationPortraitUpsideDown:YES];
    
    [PPAppPlatformKit sharedInstance].delegate = [PPDelegate instance];
    
    NSLog(@"bundle id: %@", [[NSBundle mainBundle] bundleIdentifier]);
}

void PurchasePlatformAdapter::login()
{
    [[PPAppPlatformKit sharedInstance] showLogin];
}

void PurchasePlatformAdapter::logout()
{
    [[PPAppPlatformKit sharedInstance] PPlogout];
}

bool PurchasePlatformAdapter::isLogin()
{
    return [[PPAppPlatformKit sharedInstance] currentUserName].length > 0;
}

PurchasePlatformDictionary PurchasePlatformAdapter::getUserInfo()
{
    PurchasePlatformDictionary dic;
    dic["username"] = [[PPAppPlatformKit sharedInstance].currentUserName UTF8String];
    dic["userId"] = [NSString stringWithFormat:@"%llud", [PPAppPlatformKit sharedInstance].currentUserId].UTF8String;
    dic["platform"] = "pp";
    
    return dic;
}

void PurchasePlatformAdapter::purchase(std::string productId)
{
    // 测试代码，注意订单号必须由服务器生成
    // 另外所有的支付参数最好也是由服务器传过来的
    [[PPAppPlatformKit sharedInstance] exchangeGoods:1 BillNo:@"111" BillTitle:@"test" RoleId:@"0" ZoneId:0];
}

void PurchasePlatformAdapter::openCenter()
{
    [[PPAppPlatformKit sharedInstance] showCenter];
}
