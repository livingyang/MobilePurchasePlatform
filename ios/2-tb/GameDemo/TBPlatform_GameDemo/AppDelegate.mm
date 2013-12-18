//
//  AppDelegate.m
//  TBPlatform_GameDemo
//
//  Created by OXH on 13-4-27.
//  Copyright (c) 2013年 ios_team. All rights reserved.
//

#import "AppDelegate.h"
#import "GameMainViewController.h"
#import "GameStartViewController.h"

@implementation AppDelegate
@synthesize rootViewCtrl = _rootViewCtrl;
- (void)dealloc
{
	[_window release];
    _rootViewCtrl = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[application setStatusBarHidden:YES];
    [_window makeKeyAndVisible];

    // Override point for customization after application launch.

    //NSString *ver = [[TBPlatform defaultPlatform] version];
    //NSLog(@"v : %@", ver);

	/*RootViewController*/
	GameMainViewController * gameViewController = [[[GameMainViewController alloc]
                                                        initWithNibName:@"GameMainViewController"
                                                                 bundle:[NSBundle mainBundle]] autorelease];
    self.rootViewCtrl = gameViewController;
    _window.rootViewController = gameViewController;

    return YES;
}

@end
