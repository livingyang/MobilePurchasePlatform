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

void PurchasePlatformAdapter::initial()
{
    cout << "PurchasePlatformAdapter::initial()" << endl;
}

void PurchasePlatformAdapter::login()
{
    cout << "PurchasePlatformAdapter::login()" << endl;
}
void PurchasePlatformAdapter::logout()
{
    cout << "PurchasePlatformAdapter::logout()" << endl;
}
bool PurchasePlatformAdapter::isLogin()
{
    return true;
}

PurchasePlatformDictionary PurchasePlatformAdapter::getUserInfo()
{
    PurchasePlatformDictionary dic;
    dic["username"] = "user";
    dic["platform"] = "stub";
    
    return dic;
}

void PurchasePlatformAdapter::purchase(std::string productId)
{
    cout << "PurchasePlatformAdapter::purchase, productId : " << productId << endl;
}

void PurchasePlatformAdapter::openCenter()
{
    cout << "PurchasePlatformAdapter::openCenter()" << endl;
}
