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

#import <NdComPlatform/NdComPlatform.h>

#pragma mark -
#pragma PurchasePlatformNotificationReceiver

@interface PurchasePlatformNotificationReceiver : NSObject

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
    
    return self;
}

@end

#pragma mark -
#pragma PurchasePlatformAdapter

void PurchasePlatformAdapter::initial()
{
    cout << "PurchasePlatformAdapter::initial()" << endl;
    
    NdInitConfigure *cfg = [[NdInitConfigure alloc] init];
	cfg.appid = 102328;
	cfg.appKey = @"f686c38a3d50f4f91aa6289908a81b8f6662cef0d901af32";
    //这里以竖屏演示下orientation的设置，默认的为空表示不设置
    cfg.orientation = UIInterfaceOrientationPortrait;
	[[NdComPlatform defaultPlatform] NdInit:cfg];
    
    [[NdComPlatform defaultPlatform] NdSetDebugMode:0];
}

void PurchasePlatformAdapter::login()
{
    cout << "PurchasePlatformAdapter::login()" << endl;
    
    [[NdComPlatform defaultPlatform] NdLogin:0];
}
void PurchasePlatformAdapter::logout()
{
    cout << "PurchasePlatformAdapter::logout()" << endl;
    
    [[NdComPlatform defaultPlatform] NdLogout:0];
}
bool PurchasePlatformAdapter::isLogin()
{
    return [[NdComPlatform defaultPlatform] isLogined];
}

PurchasePlatformDictionary PurchasePlatformAdapter::getUserInfo()
{
    PurchasePlatformDictionary dic;
    dic["username"] = [NdComPlatform defaultPlatform].nickName.UTF8String;
    dic["sessionId"] = [NdComPlatform defaultPlatform].sessionId.UTF8String;
    dic["uin"] = [NdComPlatform defaultPlatform].loginUin.UTF8String;
    dic["platform"] = "91";
    
    return dic;
}

void PurchasePlatformAdapter::purchase(std::string productId)
{
    cout << "PurchasePlatformAdapter::purchase, productId : " << productId << endl;
    
    [[NdComPlatform defaultPlatform] NdUniPayForCoin:@"1" needPayCoins:1 payDescription:@"test"];
}

void PurchasePlatformAdapter::openCenter()
{
    cout << "PurchasePlatformAdapter::openCenter()" << endl;
    
    [[NdComPlatform defaultPlatform] NdEnterPlatform:0];
}
