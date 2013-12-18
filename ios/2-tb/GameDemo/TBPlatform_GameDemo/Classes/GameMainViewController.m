//
//  GameMainViewController.m
//  TBPlatform_GameDemo
//
//  Created by OXH on 13-4-27.
//  Copyright (c) 2013年 ios_team. All rights reserved.
//

#import "GameMainViewController.h"
#import "GameStartViewController.h"
#import "GamePayViewController.h"

@interface GameMainViewController (){
	IBOutlet UILabel *nickNameLabel;
	MenuItem *userCenterItem;
}

@end

@implementation GameMainViewController

- (void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[nickNameLabel release];
	[super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*开启调试模式，用以调试检查更新流程（测试充值无需开启），正式发布前需要注释该行代码*/
    //[[TBPlatform defaultPlatform] TBSetDebugMode:0];

    /*监听初始化结果通知（3.0.1新增），该通知userInfo字典中带有检查更新结果*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tbInitFinished:)
                                                 name:kTBInitDidFinishNotification
                                               object:nil];

    /*~~~~~~~~~~调用其他平台接口前，必须先对平台进行初始化~~~~~~~~~~*/
    [[TBPlatform defaultPlatform] TBInitPlatformWithAppID:100000
                                        screenOrientation:UIInterfaceOrientationLandscapeLeft
                          isContinueWhenCheckUpdateFailed:NO];

    /*监听登录成功通知（3.0.1版本开始，失败不再发送该通知*/
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginResult:)
                                                 name:(NSString *)kTBLoginNotification
                                               object:nil];
	/* 监听离开平台通知（3.0.1版本开始，该通知userInfo字典中带有离开的类型及订单号 */
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leavePlatform:)
                                                 name:(NSString *)kTBLeavePlatformNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[TBPlatform defaultPlatform] isLogined]) {
        GameStartViewController *startViewController = [[GameStartViewController alloc]
                                                        initWithNibName:@"GameStartViewController"
                                                        bundle:[NSBundle mainBundle]];
        [self presentModalViewController:startViewController animated:YES];

        [startViewController release];
    }
    /*StartView*/

}
#pragma mark - 通用方法
/**
 *	@brief	消息显示方法
 */
- (void)showMessage:(NSString*)msg
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg
												   delegate:nil
										  cancelButtonTitle:@"好的"
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}

/**
 *	@brief	更新玩家信息
 */
- (void)updatePlayerInfo
{
	nickNameLabel.text = [NSString stringWithFormat:@"%@,欢迎回来",[TBPlatform defaultPlatform].nickName];

}

/**
 *	@brief	按压actions
 */
- (IBAction)buttonPressed:(id)sender{
	switch ([sender tag]) {
		case 0:
		{
			/*切换帐号
             旧接口：
             [[TBPlatform defaultPlatform] logout];
             [[TBPlatform defaultPlatform] login:NO];*/
			[[TBPlatform defaultPlatform] TBSwitchAccount];
		}
			break;
		case 1:
		{
            GamePayViewController *gpv = [[GamePayViewController alloc] initWithNibName:@"GamePayViewController" bundle:nil];
            [self presentModalViewController:gpv animated:YES];
            [gpv release];
		}
			break;
        case 2:/*修改debug模式*/
        {
            [debugButton setTitle:@"已开启调试模式" forState:UIControlStateNormal];

            /*开启调试模式以调试检查更新流程（测试充值无需开启），正式发布前需要注释该行代码*/
            [[TBPlatform defaultPlatform] TBSetDebugMode:0];
        }
            break;
		default:
			break;
	}
}

/**
 *	@brief	初始化菜单
 */
- (void)initMenu
{
	NSArray *array = [NSArray arrayWithObjects:
					  @"用户中心", @"enterUserCenter", @"icon_usercenter",
					  @"论坛", @"enterBBS", @"icon_bbs",
					  @"精品游戏", @"enterGamesCenter", @"icon_games",
					  @"版本更新", @"enterUpdate", @"icon_update",
                      //@"SessionID", @"enterCheckSession", @"icon_feedback",
					  nil];
	for (int i = 0; i < [array count]; ) {
		SEL sel = NSSelectorFromString([array objectAtIndex:i+1]);
		UIImage *storyMenuItemImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[array objectAtIndex:i+2]]];
		UIImage *storyMenuItemImagePressed = storyMenuItemImage;

		MenuItem *menuItem = [[MenuItem alloc] initWithImage:storyMenuItemImage
											highlightedImage:storyMenuItemImagePressed
												  itemString:[array objectAtIndex:i]
													 itemSel:sel];
		menuItem.delegate = self;

        float height = 260;
        float width = 360;
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
            height = 708;
            width = 604;
        }
		float fX = (i/3 <= 4 ? width-i/3*70 : width+55);
		float fY = (i/3 <= 4 ? height : height+20-(i/3-4)*65 );
		menuItem.frame = CGRectMake(fX, fY-8, 65, 60);
        //menuItem.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-40);
		[self.view addSubview:menuItem];
		[menuItem release];
		i += 3;
	}
}
/**
 *	@brief	进入用户中心
 */
- (IBAction)enterUserCenter:(id)sender{
    /*
     旧接口：
     [[TBPlatform defaultPlatform] enterPlatform];*/
	[[TBPlatform defaultPlatform] TBEnterUserCenter:0];
}

/**
 *	@brief	进入论坛（论坛需要联系客服配置)
 */
- (IBAction)enterBBS:(id)sender
{
    /*
     旧接口：（在进入用户中心后，有配置论坛的情况下可以选择）
     [[TBPlatform defaultPlatform] enterPlatform];*/
	int bbsResult = [[TBPlatform defaultPlatform] TBEnterAppBBS:0];
	if (bbsResult == TB_PLATFORM_NO_BBS) {
		[self showMessage:@"该游戏未配置论坛"];
	}
}

/**
 *	@brief	进入游戏推荐中心
 */
- (IBAction)enterGamesCenter:(id)sender
{
    /*
     旧接口：（在进入用户中心后可以选择进入）
     [[TBPlatform defaultPlatform] enterPlatform];*/
	[[TBPlatform defaultPlatform] TBEnterAppCenter:0];
}

/**
 *	@brief	检查更新
 */
- (IBAction)enterUpdate:(id)sender
{
    /*新接口*/
    [[TBPlatform defaultPlatform] TBAppVersionUpdate:0 delegate:self];
}

/**
 * @brief 检查Session
 */
- (IBAction)enterCheckSession:(id)sender{
    NSString *urlString = [NSString stringWithFormat:@"http://tgi.tongbu.com/check.aspx?k=%@",
                           [[TBPlatform defaultPlatform] sessionId]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:15.f];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (!conn) {
        [self showMessage:@"核对Session失败，请检查网络"];
    }
}


#pragma mark - 监听通知方法
- (void)tbInitFinished:(NSNotification *)notification{
    int updateResult = [[notification.userInfo objectForKey:@"updateResult"] intValue];
    [self showMessage:[NSString stringWithFormat:@"平台初始化结果（即检查更新结果）：%d",updateResult]];
    [[TBPlatform defaultPlatform] TBLogin:0];
}
/**
 *	@brief	登录通知监听方法，登录成功、失败都在这个方法处理
 *
 *	@param 	notification 	通知的userInfo包含登录结果信息
 */
- (void)loginResult:(NSNotification *)notification
{
	NSDictionary *dict = [notification userInfo];
	BOOL success = [[dict objectForKey:@"result"] boolValue];


	/*登录成功后处理*/
	if([[TBPlatform defaultPlatform] isLogined] && success) {
		/*进行玩家信息的更新，或转入游戏界面等*/
		[self updatePlayerInfo];
		[self dismissModalViewControllerAnimated:YES];
	}
	/*登录失败处理和相应提示*/
	else {
		int error = [[dict objectForKey:@"error"] intValue];
		NSString* errNotice = [NSString stringWithFormat:@"登录失败, error=%d", error];
		switch (error) {
			case TB_PLATFORM_LOGIN_INCORRECT_ACCOUNT_OR_PASSWORD_ERROR:
				errNotice = @"帐号或密码错误，请重试";
				break;
			case TB_PLATFORM_LOGIN_INVALID_ACCOUNT_ERROR:
				errNotice = @"帐号被禁用，请与管理员联系";
				break;
			case TB_PLATFORM_LOGIN_SYNC_FAILED_ERROR:
				errNotice = @"同步帐号失败，请重试";
				break;
			case TB_PLATFORM_LOGIN_REQUEST_FAILED_ERROR:
				errNotice = @"登录请求失败，请检查网络";
				break;
			default:
				break;
		}
        /*SDK已通知，无需再通知*/
		//[self showMessage:errNotice];
	}
}

/**
 *	@brief	平台关闭通知，监听离开平台通知以对游戏界面进行重新调整
 */
- (void)leavePlatform:(NSNotification *)notification
{
    TBPlatformLeavedType leavedType = [[notification.userInfo objectForKey:TBLeavedPlatformTypeKey] intValue];
    switch (leavedType) {
        //从登录界面手动关闭（登录成功关闭时不发送离开通知）
        case TBPlatformLeavedFromLogin:
            if (![[TBPlatform defaultPlatform] isLogined])
            {
                [self showMessage:@"玩家未登录"];

                //[self dismissModalViewControllerAnimated:YES];
                GameStartViewController *startController = [[GameStartViewController alloc]
                                                            initWithNibName:@"GameStartViewController"
                                                            bundle:[NSBundle mainBundle]];
                [self presentModalViewController:startController animated:YES];
                [startController release];
            }
            break;
        //从个人中心页关闭（包括游戏推荐、论坛页）
        case TBPlatformLeavedFromUserCenter:
            [self showMessage:@"从个人中心离开"];
            break;
        //从充值页面退出（包含一个订单号字段）
        case TBPlatformLeavedFromUserPay:
        {
            NSString *order = [notification.userInfo objectForKey:TBLeavedPlatformOrderKey];
            //在GamePayViewController中处理，此处忽略
//            [self showMessage:[NSString stringWithFormat:@"订单号:%@",order]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Delegate Method
/**
 *	@brief	检查更新完成后回调
 *
 *	@param 	updateResult 	结果标识
 */
- (void)appVersionUpdateDidFinish:(TB_APP_UPDATE_RESULT)updateResult
{
    NSString *title = nil;
    NSLog(@"update result:%d", updateResult);
    switch (updateResult) {
        case TB_APP_UPDATE_NO_NEW_VERSION:
            title = @"无可用更新";//正常进入游戏
            break;
        case TB_APP_UPDATE_NEW_VERSION_DOWNLOAD_FAIL:
            title = @"下载新版本失败";//可以正常进入游戏，强制更新可由服务端限制登录
            break;
        case TB_APP_UPDATE_CHECK_NEW_VERSION_FAIL:
            title = @"检测新版本信息失败"; /*可能是网络问题，那么建议检查下网络，也可以直接进入游戏，
                                   这边的风险在于如果是客户端与服务器版本不兼容，容易引起客户端异常*/
            break;
        case TB_APP_UPDATE_UPDATE_CANCEL_BY_USER:
            title = @"用户取消更新"; //进入游戏，需要的话，可以提示进一步提示玩家更新的好处和目的
            break;
        default:
            break;
    }
    [self showMessage:title];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
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
#pragma mark - Connection Delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self showMessage:@"核对Session失败，请检查网络"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *string = [[[NSString alloc ]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSString *notice = [NSString stringWithFormat:@"检查Session有效性返回结果：%@",string];
    [self showMessage:notice];
}
@end
