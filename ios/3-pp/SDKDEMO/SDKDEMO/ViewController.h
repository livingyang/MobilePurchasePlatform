//
//  ViewController.h
//  SDK-DEMO2
//
//  Created by Seven on 13-8-29.
//  Copyright (c) 2013年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PPAppPlatformKit/PPAppPlatformKit.h>

@interface ViewController : UIViewController<PPAppPlatformKitDelegate>
{
    UIImageView *bgloginImageView;
    UIImageView *bgGanmeCenterImageView;
    UIButton *ppCenterButton;
    UIButton *pploginButton;
    UISegmentedControl *changeAddressButton;
    
    UIView *propView;
    NSArray *arrayName;
    NSArray *arrayPrice;
    UITextField *customAddresTextField;
    
    
    //购买商品的价格
    NSString *_price;
    //购买商品的名称
    NSString *_name;
    NSMutableData *recvData;
    char token_key_ToStr[32];
}
@end
