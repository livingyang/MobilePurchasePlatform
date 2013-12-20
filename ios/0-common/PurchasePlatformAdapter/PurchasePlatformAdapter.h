//
//  PurchasePlatformAbstract.h
//  PurchasePlatformDemo
//
//  Created by 中 青宝 on 13-12-17.
//  Copyright (c) 2013年 zqgame. All rights reserved.
//

#ifndef PurchasePlatformDemo_PurchasePlatformAbstract_h
#define PurchasePlatformDemo_PurchasePlatformAbstract_h

#include <string>
#include <sstream>
#include <map>

typedef std::map<std::string, std::string> PurchasePlatformDictionary;

// 平台接口
struct PurchasePlatformDelegate;
class PurchasePlatformAdapter
{
    
public: // interface
    
    // initial
    void initial();
    
    // login
    void login();
    void logout();
    bool isLogin();
    
    PurchasePlatformDictionary getUserInfo();
    
    // purchase
    void purchase(std::string productId);
    
    // center
    void openCenter();
    
protected:
    PurchasePlatformAdapter(): mDelegate(NULL) {}
    ~PurchasePlatformAdapter() { setDelegate(NULL); }
    
public: // instance method
    
    static PurchasePlatformAdapter *instance()
    {
        static PurchasePlatformAdapter *adapter = NULL;
        if (adapter == NULL)
        {
            adapter = new PurchasePlatformAdapter();
        }
        
        return adapter;
    }
    
    // print dictionary
    static std::string getDictionaryString(PurchasePlatformDictionary dic)
    {
        std::stringstream ss;
        ss << "{\n";
        for (PurchasePlatformDictionary::iterator iter = dic.begin();
             iter != dic.end();
             ++iter)
        {
            ss << "\t" << iter->first << " : " << iter->second << "\n";
        }
        ss << "}\n";
        return ss.str();
    }
    
public: // url
    std::string urlLogin;
    std::string urlCreateOrder;
    
public: // delegate
    void setDelegate(PurchasePlatformDelegate *delegate)
    {
        mDelegate = delegate;
    }
    
    PurchasePlatformDelegate *getDelegate() const
    {
        return mDelegate;
    }
    
private:
    PurchasePlatformDelegate *mDelegate;
};


// 处理平台事件的回调
struct PurchasePlatformDelegate
{
    virtual void onInit(PurchasePlatformDictionary params) = 0;
    
    virtual void onLogin(PurchasePlatformDictionary params) = 0;
    
    virtual void onPurchase(PurchasePlatformDictionary params) = 0;
};

#endif
