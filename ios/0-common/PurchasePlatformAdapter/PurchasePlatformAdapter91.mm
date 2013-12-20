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


static int APP_ID = 102328;
static NSString *APP_KEY = @"f686c38a3d50f4f91aa6289908a81b8f6662cef0d901af32";

#pragma mark -
#pragma mark PurchasePlatformNotificationReceiver

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
    
    if (self != nil)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onInitFinish:)
                                                     name:kNdCPInitDidFinishNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onLoginFinish:)
                                                     name:kNdCPLoginNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onPurchaseFinish:)
                                                     name:kNdCPBuyResultNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)onInitFinish:(NSNotification *)aNotification
{
    if (PurchasePlatformAdapter::instance()->getDelegate() != NULL)
    {
        PurchasePlatformDictionary dic;
        dic["platform"] = "91";
        PurchasePlatformAdapter::instance()->getDelegate()->onInit(dic);
    }
}

- (void)vertifyLoginUser:(std::string)vertifyUrl
                  userId:(NSString *)userId
                platform:(NSString *)platform
               sessionId:(NSString *)sessionId
                   appId:(int)appId
                  appKey:(NSString *)appKey
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s?userId=%@&platform=91&sessionId=%@&appId=%d&appKey=%@", vertifyUrl.c_str(), userId, sessionId, appId, appKey]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // 打印返回数据
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)onLoginFinish:(NSNotification *)aNotification
{
    if (PurchasePlatformAdapter::instance()->getDelegate() != NULL)
    {
        PurchasePlatformDictionary dic;
        dic["platform"] = "91";
        
        PurchasePlatformAdapter::instance()->getDelegate()->onLogin(dic);
        
        // 将登陆信息发送服务器
        if (PurchasePlatformAdapter::instance()->isLogin())
        {
            [self vertifyLoginUser:PurchasePlatformAdapter::instance()->urlLogin
                            userId:[NdComPlatform defaultPlatform].loginUin
                          platform:@"91"
                         sessionId:[NdComPlatform defaultPlatform].sessionId
                             appId:APP_ID
                            appKey:APP_KEY];
        }
    }
}

- (void)onPurchaseFinish:(NSNotification *)aNotification
{
    if (PurchasePlatformAdapter::instance()->getDelegate() != NULL)
    {
        PurchasePlatformDictionary dic;
        dic["platform"] = "91";
        PurchasePlatformAdapter::instance()->getDelegate()->onPurchase(dic);
    }
}

@end

#pragma mark -
#pragma mark PurchasePlatformAdapter


NSDictionary *getOrder(NSString *getOrderUrl, NSString *productId)
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:getOrderUrl]];
    
    NSDictionary *orderDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return orderDic;
}

void PurchasePlatformAdapter::initial()
{
    // 调用一次，注册接收91平台的各种通知
    [PurchasePlatformNotificationReceiver instance];
    
    NdInitConfigure *cfg = [[NdInitConfigure alloc] init];
	cfg.appid = APP_ID;
	cfg.appKey = APP_KEY;
    
    //这里以竖屏演示下orientation的设置，默认的为空表示不设置
    cfg.orientation = UIInterfaceOrientationPortrait;
	[[NdComPlatform defaultPlatform] NdInit:cfg];
    
    [[NdComPlatform defaultPlatform] NdSetDebugMode:0];
}

void PurchasePlatformAdapter::login()
{
    [[NdComPlatform defaultPlatform] NdLogin:0];
}
void PurchasePlatformAdapter::logout()
{
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
    // 测试代码，注意订单号必须由服务器生成
    // 另外所有的支付参数最好也是由服务器传过来的
    
    NSDictionary *orderDic = getOrder([NSString stringWithUTF8String:PurchasePlatformAdapter::instance()->urlCreateOrder.c_str()], [NSString stringWithFormat:@"%s", productId.c_str()]);
    NSLog(@"orderDic: %@", orderDic);
    
    [[NdComPlatform defaultPlatform] NdUniPayForCoin:[orderDic objectForKey:@"_id"] needPayCoins:[[orderDic objectForKey:@"price"] intValue] payDescription:[orderDic objectForKey:@"description"]];
}

void PurchasePlatformAdapter::openCenter()
{
    [[NdComPlatform defaultPlatform] NdEnterPlatform:0];
}
