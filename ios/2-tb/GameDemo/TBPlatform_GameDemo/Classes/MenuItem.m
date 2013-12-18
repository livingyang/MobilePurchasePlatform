//
//  MenuItem.m
//  TBPlatform_GameDemo
//
//  Created by OXH on 13-4-28.
//  Copyright (c) 2013年 ios_team. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem
@synthesize delegate  = _delegate;
@synthesize itemSel = _itemSel;


- (id)initWithImage:(UIImage *)img
   highlightedImage:(UIImage *)himg
		 itemString:(NSString *)itemString
			itemSel:(SEL)itemSel
{
	if (self = [super init]) {
		self.userInteractionEnabled = YES;
		
		_bgImageView = [[UIImageView alloc] initWithImage:img];
		_bgImageView.highlightedImage = himg;
		
		
		_itemLabel = [[UILabel alloc] init];
		_itemLabel.text = itemString;
		_itemLabel.textColor = [UIColor blackColor];
		_itemLabel.textAlignment = UITextAlignmentCenter;
		_itemLabel.font = [UIFont systemFontOfSize:13];
		_itemLabel.backgroundColor = [UIColor clearColor];
		
		_itemSel = itemSel;
		
		[self addSubview:_bgImageView];
		[self addSubview:_itemLabel];
	}
	
	return self;
}

- (void)dealloc {
	[_bgImageView release];
	[_itemLabel release];
    [super dealloc];
}

#pragma mark touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _bgImageView.highlighted = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.bounds, location))
    {
        _bgImageView.highlighted = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _bgImageView.highlighted = NO;
    CGPoint location = [[touches anyObject] locationInView:self];
	if (CGRectContainsPoint(self.bounds, location)) {
		if ([_delegate respondsToSelector:self.itemSel])
		{
			[_delegate performSelector:self.itemSel];
		}
	}
}
#pragma mark layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
	
	CGSize imgSize = _bgImageView.bounds.size;
	CGSize bgSize = self.frame.size;
	_bgImageView.frame = CGRectMake(bgSize.width/2-imgSize.width/2, (bgSize.height-25)/2-imgSize.height/2, _bgImageView.image.size.width, _bgImageView.image.size.height);
	_itemLabel.frame = CGRectMake(0, bgSize.height-30, bgSize.width, 25);
}

@end
