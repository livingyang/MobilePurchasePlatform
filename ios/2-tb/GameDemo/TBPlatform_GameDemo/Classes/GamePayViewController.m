//
//  GamePayViewController.m
//  TBPlatform_GameDemo
//
//  Created by OXH on 13-5-14.
//  Copyright (c) 2013年 ios_team. All rights reserved.
//

#import "GamePayViewController.h"

@interface GamePayViewController ()

@end

@implementation GamePayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leavePlatform:) name:kTBLeavePlatformNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTBLeavePlatformNotification object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
- (BOOL)shouldAutorotate{
    return  YES;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - IB
- (IBAction)buttonPressed:(UIButton *)sender{
    switch (sender.tag) {
        case 0:/*充值6元*/
        {
            /*旧接口：
             [TBPlatform defaultPlatform].bankType = TB_BANK_TYPE_ALIPAY;
             [TBPlatform defaultPlatform].amount = 600;
             [[TBPlatform defaultPlatform] uniPayOrderSerial:[self newOrder] description:@"test@gmail.com"];*/
            [[TBPlatform defaultPlatform] TBUniPayForCoin:[self newOrder]
                                               needPayRMB:6
                                           payDescription:@"DesDemo"
                                                 delegate:self];
            _isRecharging = NO;
        }
            break;
        case 1:/*充值50元*/
        {
            /*旧接口：
             [TBPlatform defaultPlatform].bankType = TB_BANK_TYPE_ALIPAY;
             [TBPlatform defaultPlatform].amount = 550;
             [[TBPlatform defaultPlatform] uniPayOrderSerial:[self newOrder] description:@"test@gmail.com"];*/
            [[TBPlatform defaultPlatform] TBUniPayForCoin:[self newOrder]
                                               needPayRMB:50
                                           payDescription:@"DesDemo"
                                                 delegate:self];
            _isRecharging = NO;
        }
            break;
        case 2:/*自选金额充值*/
        {
            _isRecharging = YES;
            _currentOrder = [[self newOrder] copy];
            [[TBPlatform defaultPlatform] TBUniPayForCoin:_currentOrder
                                           payDescription:@"DesDemo"];
        }
            break;
        case 3:/*返回游戏*/
        {
            [self dismissModalViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - funcs
- (NSString *)newOrder{
  /*创建订单号，需唯一*/
  CFUUIDRef theUUID = CFUUIDCreate(NULL);
  CFStringRef guid = CFUUIDCreateString(NULL, theUUID);
  CFRelease(theUUID);
  NSString *uuidString = [((NSString *)guid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
  CFRelease(guid);
  return [uuidString lowercaseString];
}
- (void)showMessage:(NSString*)msg
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg
												   delegate:nil
										  cancelButtonTitle:@"好的"
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}
#pragma mark - Notifications
- (void)leavePlatform:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:TBLeavedPlatformTypeKey] intValue]
        == TBPlatformLeavedFromUserPay) {
        [[TBPlatform defaultPlatform] TBCheckPaySuccess:[notification.userInfo objectForKey:TBLeavedPlatformOrderKey]
                                               delegate:self];
    }
}
#pragma mark - BuyGoods Delegate
- (void)TBBuyGoodsDidSuccessWithOrder:(NSString*)order{
    [self showMessage:@"购买成功"];
}
- (void)TBBuyGoodsDidFailedWithOrder:(NSString *)order resultCode:(TB_BUYGOODS_ERROR)errorType;{
    switch (errorType) {
        case kBuyGoodsOrderEmpty:
            NSLog(@"订单号为空");
            break;
        case kBuyGoodsBalanceNotEnough:
            NSLog(@"推币余额不足");
            break;
        case kBuyGoodsServerError:
            NSLog(@"服务器错误");
            break;
        case kBuyGoodsOtherError:
            NSLog(@"其他错误");
            break;
        default:
            break;
    }
}
- (void)TBBuyGoodsDidStartRechargeWithOrder:(NSString *)order{
}
- (void)TBBuyGoodsDidCancelByUser:(NSString *)order{
    [self showMessage:@"取消支付"];
}
#pragma mark - CheckOrder Delegate
- (void)TBCheckOrderSuccessWithResult:(NSDictionary *)dict{
    NSLog(@"Check Result:%@",dict);
}
- (void)TBCheckOrderDidFailed:(NSString *)order{
    /*检查订单失败*/
    NSLog(@"Check Failed:%@",order);
}
@end
