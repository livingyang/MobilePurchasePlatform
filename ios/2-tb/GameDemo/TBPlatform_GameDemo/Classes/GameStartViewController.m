//
//  GameStartViewController.m
//  TBPlatform_GameDemo
//
//  Created by OXH on 13-4-27.
//  Copyright (c) 2013年 ios_team. All rights reserved.
//

#import "GameStartViewController.h"
@interface GameStartViewController ()

@end

@implementation GameStartViewController

/**
 *	@brief	登录，参数预留，填0
 *
 *	@param 	sender 	
 */
- (IBAction)login:(id)sender
{
    /*旧接口：[[TBPlatform defaultPlatform] login:NO];*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginResult:)
                                                 name:(NSString *)kTBLoginNotification
                                               object:nil];
	[[TBPlatform defaultPlatform] TBLogin:0];

}

- (IBAction)pay:(id)sender{
    [[TBPlatform defaultPlatform] TBUniPayForCoin:@"order" payDescription:@"paydes"];
}
- (IBAction)userCenter:(id)sender{
    [[TBPlatform defaultPlatform] TBEnterUserCenter:0];
}

- (IBAction)register:(id)sender {
    [[TBPlatform defaultPlatform] TBRegister:0];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)loginResult:(NSNotification *)notification
{
	
}

- (BOOL)shouldAutorotate{
    return  YES;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
