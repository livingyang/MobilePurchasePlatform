//
//  ViewController.m
//  PurchasePlatformDemo
//
//  Created by 中 青宝 on 13-12-17.
//  Copyright (c) 2013年 zqgame. All rights reserved.
//

#import "ViewController.h"
#import "PurchasePlatformAdapter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onInitialClick:(id)sender
{
    PurchasePlatformAdapter::instance()->initial();
}

- (IBAction)onLoginClick:(id)sender
{
    PurchasePlatformAdapter::instance()->login();
}
- (IBAction)onLogoutClick:(id)sender
{
    PurchasePlatformAdapter::instance()->logout();
}
- (IBAction)onIsLoginClick:(id)sender
{
    bool isLogin = PurchasePlatformAdapter::instance()->isLogin();
    
    if (isLogin)
    {
        PurchasePlatformDictionary userInfo = PurchasePlatformAdapter::instance()->getUserInfo();
        
        [[[UIAlertView alloc] initWithTitle:@"Now Login"
                                    message:[NSString stringWithFormat:@"%s", PurchasePlatformAdapter::getDictionaryString(userInfo).c_str()]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Now Logout"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)onPurchaseClick:(id)sender
{
    PurchasePlatformAdapter::instance()->purchase("1");
}

- (IBAction)onOpenCenterClick:(id)sender
{
    PurchasePlatformAdapter::instance()->openCenter();
}

@end
