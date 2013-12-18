//
//  MenuItem.h
//  TBPlatform_GameDemo
//
//  Created by OXH on 13-4-28.
//  Copyright (c) 2013年 ios_team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItem : UIView{
	UIImageView *_bgImageView;
	UILabel *_itemLabel;
	
	SEL	_itemSel;
    id _delegate;
}
@property (nonatomic) SEL itemSel;
@property (nonatomic, assign) id delegate;

- (id)initWithImage:(UIImage *)img
   highlightedImage:(UIImage *)himg
		 itemString:(NSString *)itemString
			itemSel:(SEL)itemSel;


@end
