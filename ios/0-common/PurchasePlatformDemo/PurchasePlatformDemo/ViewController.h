//
//  ViewController.h
//  PurchasePlatformDemo
//
//  Created by 中 青宝 on 13-12-17.
//  Copyright (c) 2013年 zqgame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, assign) IBOutlet UITextField *txtLogin;
@property (nonatomic, assign) IBOutlet UITextField *txtCreateOrder;

- (IBAction)onInitialClick:(id)sender;

- (IBAction)onLoginClick:(id)sender;
- (IBAction)onLogoutClick:(id)sender;
- (IBAction)onIsLoginClick:(id)sender;

- (IBAction)onPurchaseClick:(id)sender;

- (IBAction)onOpenCenterClick:(id)sender;

@end
