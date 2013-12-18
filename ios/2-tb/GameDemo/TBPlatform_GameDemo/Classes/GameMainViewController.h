//
//  GameMainViewController.h
//  TBPlatform_GameDemo
//
//  Created by OXH on 13-4-27.
//  Copyright (c) 2013年 ios_team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"
@interface GameMainViewController : UIViewController <UITextFieldDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    IBOutlet UIButton *debugButton;
}

- (IBAction)buttonPressed:(id)sender;

- (IBAction)enterUserCenter:(id)sender;
- (IBAction)enterBBS:(id)sender;
- (IBAction)enterGamesCenter:(id)sender;
- (IBAction)enterUpdate:(id)sender;
- (IBAction)enterCheckSession:(id)sender;

@end
