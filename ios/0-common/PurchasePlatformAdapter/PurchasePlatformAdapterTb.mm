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

#include <TBPlatform/TBPlatform.h>
#pragma mark -
#pragma mark PurchasePlatformNotificationReceiver

@interface PurchasePlatformNotificationReceiver : NSObject <TBBuyGoodsProtocol>

+ (PurchasePlatformNotificationReceiver *)instance;

@end

@implementation PurchasePlatformNotificationReceiver

+ (PurchasePlatformNotificationReceiver *)instance
{
    static PurchasePlatformNotificationReceiver *receiver = nil;
    
    if (receiver == nil)
    {
        receiver = [[PurchasePlatformNotificationReceiver alloc] init];
    }
    
    return receiver;
}

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onInitFinish:)
                                                     name:kTBInitDidFinishNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onLoginFinish:)
                                                     name:kTBLoginNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)onInitFinish:(NSNotification *)aNotification
{
    if (PurchasePlatformAdapter::instance()->getDelegate() != NULL)
    {
        PurchasePlatformDictionary dic;
        dic["platform"] = "tb";
        PurchasePlatformAdapter::instance()->getDelegate()->onInit(dic);
    }
}

- (void)onLoginFinish:(NSNotification *)aNotification
{
    if (PurchasePlatformAdapter::instance()->getDelegate() != NULL)
    {
        PurchasePlatformDictionary dic;
        dic["platform"] = "tb";
        PurchasePlatformAdapter::instance()->getDelegate()->onLogin(dic);
    }
}

- (void)onPurchaseFinish
{
    PurchasePlatformDictionary dic;
    dic["platform"] = "tb";
    PurchasePlatformAdapter::instance()->getDelegate()->onPurchase(dic);
}

- (void)TBBuyGoodsDidSuccessWithOrder:(NSString*)order
{
    [self onPurchaseFinish];
}

- (void)TBBuyGoodsDidFailedWithOrder:(NSString *)order resultCode:(TB_BUYGOODS_ERROR)errorType
{
    [self onPurchaseFinish];
}

- (void)TBBuyGoodsDidStartRechargeWithOrder:(NSString*)order
{
    [self onPurchaseFinish];
}

- (void)TBBuyGoodsDidCancelByUser:(NSString *)order
{
    [self onPurchaseFinish];
}

@end


void PurchasePlatformAdapter::initial()
{
    // 调用一次，注册接收91平台的各种通知
    [PurchasePlatformNotificationReceiver instance];
    
    [[TBPlatform defaultPlatform] TBInitPlatformWithAppID:100000
                                        screenOrientation:UIInterfaceOrientationPortrait
                          isContinueWhenCheckUpdateFailed:NO];
}

void PurchasePlatformAdapter::login()
{
    [[TBPlatform defaultPlatform] TBLogin:0];
}

void PurchasePlatformAdapter::logout()
{
    [[TBPlatform defaultPlatform] TBLogout:0];
}

bool PurchasePlatformAdapter::isLogin()
{
    return [[TBPlatform defaultPlatform] isLogined];
}

PurchasePlatformDictionary PurchasePlatformAdapter::getUserInfo()
{
    TBPlatformUserInfo *userInfo = [[TBPlatform defaultPlatform] getUserInfo];
    PurchasePlatformDictionary dic;
    dic["username"] = userInfo.nickName.UTF8String;
    dic["platform"] = "tb";
    dic["userId"] = userInfo.userID.UTF8String;
    dic["sessionId"] = userInfo.sessionID.UTF8String;
    
    return dic;
}

void PurchasePlatformAdapter::purchase(std::string productId)
{
    // 测试代码，注意订单号必须由服务器生成
    // 另外所有的支付参数最好也是由服务器传过来的
    [[TBPlatform defaultPlatform] TBUniPayForCoin:[NSString stringWithUTF8String:productId.c_str()]
                                       needPayRMB:1
                                   payDescription:@"test"
                                         delegate:[PurchasePlatformNotificationReceiver instance]];
}

void PurchasePlatformAdapter::openCenter()
{
    [[TBPlatform defaultPlatform] TBEnterUserCenter:0];
}
