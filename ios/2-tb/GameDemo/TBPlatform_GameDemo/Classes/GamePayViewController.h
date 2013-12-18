//
//  GamePayViewController.h
//  TBPlatform_GameDemo
//
//  Created by OXH on 13-5-14.
//  Copyright (c) 2013年 ios_team. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GamePayViewController : UIViewController<TBBuyGoodsProtocol,TBPayDelegate>{
    NSString *_currentOrder;
    BOOL      _isRecharging;
}

@end
