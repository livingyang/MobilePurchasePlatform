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

void PurchasePlatformAdapter::initial()
{
    cout << "PurchasePlatformAdapter::initial()" << endl;
    
    [[TBPlatform defaultPlatform] TBInitPlatformWithAppID:100000
                                        screenOrientation:UIInterfaceOrientationPortrait
                          isContinueWhenCheckUpdateFailed:NO];
}

void PurchasePlatformAdapter::login()
{
    cout << "PurchasePlatformAdapter::login()" << endl;
    
    [[TBPlatform defaultPlatform] TBLogin:0];
}
void PurchasePlatformAdapter::logout()
{
    cout << "PurchasePlatformAdapter::logout()" << endl;
    
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
    cout << "PurchasePlatformAdapter::purchase, productId : " << productId << endl;
    
    [[TBPlatform defaultPlatform] TBUniPayForCoin:[NSString stringWithUTF8String:productId.c_str()]
                                       needPayRMB:1
                                   payDescription:@"test"
                                         delegate:nil];
}

void PurchasePlatformAdapter::openCenter()
{
    cout << "PurchasePlatformAdapter::openCenter()" << endl;
    
    [[TBPlatform defaultPlatform] TBEnterUserCenter:0];
}
