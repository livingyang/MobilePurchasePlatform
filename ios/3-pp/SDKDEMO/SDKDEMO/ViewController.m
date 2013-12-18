//
//  ViewController.m
//  SDK_DEMO
//
//  Created by seven  mr on 2/3/13.
//  Copyright (c) 2013 张熙文. All rights reserved.
//

//http://58.218.147.147:8082

#define UI_SCREEN_WIDTH                     [[UIScreen mainScreen] bounds].size.width
#define UI_SCREEN_HEIGHT                    [[UIScreen mainScreen] bounds].size.height
#define IMAGERESOURCEPATH               [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"GameImages"]
#define BUTTONWIDTH                 150
#define BUTTONHEIGHT                40


#import "ViewController.h"
#import <PPAppPlatformKit/PPAppPlatformKit.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <sys/types.h>
#include <arpa/inet.h>








#define GAMESERVER_PORT_TEST                 @"8000"
#define GAMESERVER_IP_TEST                   "58.218.248.218"



@interface ViewController ()

@end

@implementation ViewController




- (void)viewDidLoad
{
    [[PPAppPlatformKit sharedInstance] setDelegate:self];
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    bgloginImageView = [[UIImageView alloc] init];
    [bgloginImageView setUserInteractionEnabled:YES];
    
    [bgloginImageView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [[self view] addSubview:bgloginImageView];
    [bgloginImageView setHidden:NO];
    
    
    
    pploginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pploginButton setFrame:CGRectMake(0, 0, 150, 40)];
    [pploginButton addTarget:self action:@selector(loginPressDown) forControlEvents:UIControlEventTouchUpInside];
    [pploginButton setImage:[UIImage imageWithContentsOfFile:[IMAGERESOURCEPATH stringByAppendingPathComponent:@"button.png"]]
                   forState:UIControlStateNormal];
    [bgloginImageView addSubview:pploginButton];
    
        
    NSArray *array = [NSArray arrayWithObjects:@"正式",@"测试",@"自定义", nil];
    changeAddressButton = [[UISegmentedControl alloc] initWithItems:array];
    [changeAddressButton setSelectedSegmentIndex:0];
    [changeAddressButton addTarget:self action:@selector(changeAddressButtonPressDown:)
                  forControlEvents:UIControlEventValueChanged];
    
    [changeAddressButton setFrame:CGRectMake(10, 10, 150, 30)];
//    [bgloginImageView addSubview:changeAddressButton];
    
    
    //    customAddresTextField = [[UITextField alloc] init];
    //    [customAddresTextField setFrame:CGRectMake(10, 50, 250, 35)];
    //    [customAddresTextField setText:@"http://"];
    //    [customAddresTextField setDelegate:self];
    //    [customAddresTextField addTarget:self action:@selector(textFieldDidChange)
    //                    forControlEvents:UIControlEventEditingChanged];
    //    [customAddresTextField setBorderStyle:UITextBorderStyleLine];
    //    [bgloginImageView addSubview:customAddresTextField];
    //    [customAddresTextField setHidden:YES];
    
    UILabel *loginLabel = [[UILabel alloc] init];
    [loginLabel setBackgroundColor:[UIColor clearColor]];
    [loginLabel setText:@"登 录"];
    [loginLabel setFrame:CGRectMake(0, 0, BUTTONWIDTH, BUTTONHEIGHT)];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [pploginButton addSubview:loginLabel];
    [loginLabel release];
    
    
    
    bgGanmeCenterImageView = [[UIImageView alloc] init];
    [bgGanmeCenterImageView setUserInteractionEnabled:YES];
    [bgGanmeCenterImageView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [[self view] addSubview:bgGanmeCenterImageView];
    [bgGanmeCenterImageView setHidden:YES];
    
    ppCenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ppCenterButton setFrame:CGRectMake(0, 0, 150, 40)];
    [ppCenterButton addTarget:self action:@selector(ppCenterPressDown) forControlEvents:UIControlEventTouchUpInside];
    [ppCenterButton setImage:[UIImage imageWithContentsOfFile:[IMAGERESOURCEPATH stringByAppendingPathComponent:@"button.png"]]
                    forState:UIControlStateNormal];
    [bgGanmeCenterImageView addSubview:ppCenterButton];
    
    UILabel *gameLabel = [[UILabel alloc] init];
    [gameLabel setBackgroundColor:[UIColor clearColor]];
    [gameLabel setText:@"PP中心"];
    [gameLabel setTextAlignment:NSTextAlignmentCenter];
    [gameLabel setFrame:CGRectMake(0, 0, BUTTONWIDTH, BUTTONHEIGHT)];
    [ppCenterButton addSubview:gameLabel];
    [gameLabel release];
    
    propView = [[UIView alloc] init];
    [propView setFrame:CGRectMake(0, 0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH / 3 * 2)];
    [bgGanmeCenterImageView addSubview:propView];
    arrayName = [[NSArray alloc] initWithObjects:@"红色球（1PP币）",@"黑色球（2PP币）",@"紫色球（3PP币）"
                 ,@"黄色球（4PP币）"
                 , nil];
    arrayPrice = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    for (int i = 0; i < [arrayName count]; i++) {
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buyButton setTag:i];
        [buyButton setTitle:@"购 买" forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lbl = [[UILabel alloc] init];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setText:[arrayName objectAtIndex:i]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setNumberOfLines:2];
        if (i % 2 == 0) {
            [lbl setFrame:CGRectMake(propView.frame.size.height / 2 - 100,  10 + i / 2 * 80, 100, 50)];
            [buyButton setFrame:CGRectMake(propView.frame.size.height / 2 - 100, 60 + i / 2 * 80, 100, 30)];
        }else{
            [lbl setFrame:CGRectMake(propView.frame.size.height / 2 + 100,  10 + i / 2 * 80, 100, 50)];
            [buyButton setFrame:CGRectMake(propView.frame.size.height / 2 + 100, 60 + i / 2 * 80, 100, 30)];
        }
        [propView addSubview:buyButton];
        [propView addSubview:lbl];
        [lbl release];
    }
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [pploginButton setCenter:CGPointMake(UI_SCREEN_WIDTH / 2, UI_SCREEN_HEIGHT / 2 + 30)];
        [bgloginImageView setImage:[UIImage imageWithContentsOfFile:[IMAGERESOURCEPATH stringByAppendingPathComponent:@"PPLogin.png"]]];
        [ppCenterButton setCenter:CGPointMake(UI_SCREEN_WIDTH / 2, UI_SCREEN_HEIGHT - 50)];
        [bgGanmeCenterImageView setImage:[UIImage imageWithContentsOfFile:[IMAGERESOURCEPATH stringByAppendingPathComponent:@"bg.png"]]];
    }else{
        [pploginButton setFrame:CGRectMake(UI_SCREEN_HEIGHT / 2 - BUTTONWIDTH / 2, UI_SCREEN_WIDTH / 2 + 10, 150, 40)];
        [bgloginImageView setImage:[UIImage imageWithContentsOfFile:[IMAGERESOURCEPATH stringByAppendingPathComponent:@"PPLogin_iPad.png"]]];
        [ppCenterButton setFrame:CGRectMake(UI_SCREEN_HEIGHT / 2 - 150 / 2, UI_SCREEN_WIDTH / 2 + 10, 150, 40)];
        [bgGanmeCenterImageView setImage:[UIImage imageWithContentsOfFile:[IMAGERESOURCEPATH stringByAppendingPathComponent:@"bg.png"]]];
    }
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    [self willRotateToInterfaceOrientation:interfaceOrientation duration:NSTimeIntervalSince1970];
}


#pragma mark ---------------------------------------------------- 登 录 -------------------------------------------------------

- (void)loginPressDown{
    [[PPAppPlatformKit sharedInstance] showLogin];
}



- (void)ppCenterPressDown{
    [[PPAppPlatformKit sharedInstance] showCenter];
}


- (void)buy:(UIButton *)sender{
    double prices[] = {1, 2, 3, 4};
    int index = sender.tag;
    _name = [[NSString alloc] initWithFormat:@"%@",[[arrayName objectAtIndex:index] substringToIndex:3]];
    [self exchangeGoods:prices[index]];
}

- (void)exchangeGoods:(double)price
{
    int time = [[NSDate date] timeIntervalSince1970];
    NSString *billNO = [NSString stringWithFormat:@"%d",time];
    [[PPAppPlatformKit sharedInstance] exchangeGoods:price BillNo:billNO BillTitle:_name RoleId:@"0" ZoneId:0];
}









#pragma mark    ---------------SDK CALLBACK---------------
//字符串登录成功回调【实现其中一个就可以】
- (void)ppLoginStrCallBack:(NSString *)paramStrToKenKey{
    //字符串token验证方式
    MSG_GAME_SERVER_STR mgs_s = {};
    mgs_s.len_str =  41;
    mgs_s.commmand_str = 0xAA000022;
    memcpy(mgs_s.token_key_str, [paramStrToKenKey UTF8String], 33);
    //下面请注意，登录验证分两种情况e
    //1. 如果您没有业务服务器则在此处直接跳入游戏界面
    //2. 如果您有游戏服务器，请在这里验证登录信息，然后跳转到游戏界面
    //下面代码为内部服务器测试代码
//    int fd = socket( AF_INET , SOCK_STREAM , 0 ) ;
//    if(fd == -1)
//        printf("socket err : %m\n"),exit(1);
//    struct sockaddr_in addr;
//    addr.sin_family = AF_INET;
//    addr.sin_port = htons([GAMESERVER_PORT_TEST intValue]);
//    addr.sin_addr.s_addr = inet_addr(GAMESERVER_IP_TEST);
//    int r = connect(fd, (struct sockaddr *)&addr, sizeof(addr));
//    if(r == -1)
//        printf("connect err : %m\n"),exit(-1);
//
//    //发送验证
//    send(fd, &mgs_s, sizeof(MSG_GAME_SERVER_STR), 0);
//    MSG_GAME_SERVER_RESPONSE mgsr;
//    recv(fd, &mgsr, 12, 0);
//    NSLog(@"%02X",mgsr.status);
//    if(mgsr.status == 0)
    {
        //跳入游戏界面
        [bgGanmeCenterImageView setHidden:NO];
        [bgloginImageView setHidden:YES];
        [[PPAppPlatformKit sharedInstance] getUserInfoSecurity];
    }
}

//2进制登录成功回调【实现其中一个就可以】
//- (void)ppLoginHexCallBack:(char *)paramHexToKen{
//    
//    MSG_GAME_SERVER mgs = {};
//    mgs.len =  24;
//    mgs.commmand = 0xAA000021;
//    memcpy(mgs.token_key, paramHexToKen, 16);
//        
//    //下面请注意，登录验证分两种情况e
//    //1. 如果您没有业务服务器则在此处直接跳入游戏界面
//    //2. 如果您有游戏服务器，请在这里验证登录信息，然后跳转到游戏界面
//    //下面代码为内部服务器测试代码
//    int fd = socket( AF_INET , SOCK_STREAM , 0 ) ;
//    if(fd == -1)
//        printf("socket err : %m\n"),exit(1);
//    struct sockaddr_in addr;
//    addr.sin_family = AF_INET;
//    addr.sin_port = htons([GAMESERVER_PORT_TEST intValue]);
//    addr.sin_addr.s_addr = inet_addr(GAMESERVER_IP_TEST);
//    int r = connect(fd, (struct sockaddr *)&addr, sizeof(addr));
//    if(r == -1)
//        printf("connect err : %m\n"),exit(-1);
//    //发送验证
//    send(fd, &mgs, sizeof(MSG_GAME_SERVER), 0);
//    MSG_GAME_SERVER_RESPONSE mgsr;
//    recv(fd, &mgsr, 12, 0);
//    NSLog(@"%02X",mgsr.status);
//    if(mgsr.status == 0){
//        //跳入游戏界面
//        [bgGanmeCenterImageView setHidden:NO];
//        [bgloginImageView setHidden:YES];
//        [[PPAppPlatformKit sharedInstance] getUserInfoSecurity];
//    }
//}

//关闭客户端页面回调方法
-(void)ppClosePageViewCallBack:(PPPageCode)paramPPPageCode{
    //可根据关闭的VIEW页面做你需要的业务处理
    NSLog(@"当前关闭的VIEW页面回调是%d", paramPPPageCode);
}



//关闭WEB页面回调方法
- (void)ppCloseWebViewCallBack:(PPWebViewCode)paramPPWebViewCode{
    //可根据关闭的WEB页面做你需要的业务处理
    NSLog(@"当前关闭的WEB页面回调是%d", paramPPWebViewCode);
}

//注销回调方法
- (void)ppLogOffCallBack{
    NSLog(@"注销的回调");
    [bgGanmeCenterImageView setHidden:YES];
    [bgloginImageView setHidden:NO];
}

//兑换回调接口【只有兑换会执行此回调】
- (void)ppPayResultCallBack:(PPPayResultCode)paramPPPayResultCode{
    NSLog(@"兑换回调返回编码%d",paramPPPayResultCode);
    //回调购买成功。其余都是失败
    if(paramPPPayResultCode == PPPayResultCodeSucceed){
        //购买成功发放道具
        
    }else{
        
    }
}

-(void)ppVerifyingUpdatePassCallBack{
    NSLog(@"验证游戏版本完毕回调");
    [[PPAppPlatformKit sharedInstance] showLogin];
}

#pragma mark      ---------------------ios supportedInterfaceOrientations -------------
//iOS 6.0旋屏开关
- (BOOL)shouldAutorotate
{
    return YES;
}


//iOS 6.0旋屏支持方向
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


//iOS 6.0以下旋屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return YES;
    }
    return YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration
{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;
    
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [propView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT / 3 * 2)];
        [ppCenterButton setCenter:CGPointMake(UI_SCREEN_WIDTH / 2, UI_SCREEN_HEIGHT - 50)];
        [pploginButton setCenter:CGPointMake(UI_SCREEN_WIDTH / 2 , UI_SCREEN_HEIGHT / 2)];
        [changeAddressButton setCenter:CGPointMake(UI_SCREEN_WIDTH / 2 , UI_SCREEN_HEIGHT / 2 + 50)];
        [customAddresTextField setCenter:CGPointMake(UI_SCREEN_WIDTH / 2 , UI_SCREEN_HEIGHT / 2 - 90)];
		rect = screenRect;
	}
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
        [propView setFrame:CGRectMake(0, 0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH / 3 * 2)];
        [ppCenterButton setCenter:CGPointMake(UI_SCREEN_HEIGHT / 2, UI_SCREEN_WIDTH - 50)];
        [pploginButton setCenter:CGPointMake(UI_SCREEN_HEIGHT / 2, UI_SCREEN_WIDTH / 2 + 30)];
        [changeAddressButton setCenter:CGPointMake(UI_SCREEN_HEIGHT / 2, UI_SCREEN_WIDTH / 2 + 80)];
        [customAddresTextField setCenter:CGPointMake(UI_SCREEN_HEIGHT / 2, UI_SCREEN_WIDTH / 2 - 120)];
        rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
    }
    bgloginImageView.frame = rect;
    bgGanmeCenterImageView.frame = rect;
}





//#pragma mark  -------------------------UITextField delegate methods ------------------------------------
////清空用户名文本框时，连带密码信息也清空
//- (void) textFieldDidChange{
//    [[PPAppPlatformKit sharedInstance] setCurrentAddress:[customAddresTextField text]];
//}
//
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [[PPAppPlatformKit sharedInstance] setCurrentAddress:[customAddresTextField text]];
//    [textField resignFirstResponder];
//    return YES;
//}


//- (void)changeAddressButtonPressDown:(id) sender{
//    [customAddresTextField setHidden:YES];
//    UISegmentedControl *myseg = (UISegmentedControl *) sender;
//    if (myseg.selectedSegmentIndex == 0) {
//        [[PPAppPlatformKit sharedInstance] setCurrentAddress:@"https://pay.25pp.com"];
//    }else if(myseg.selectedSegmentIndex == 1){
//        [[PPAppPlatformKit sharedInstance] setCurrentAddress:@"https://testpay.25pp.com"];
//    }else if(myseg.selectedSegmentIndex == 2){
//        [customAddresTextField setHidden:NO];
//    }
//
//}

-(void) dealloc{
    [super dealloc];
    
}




@end
