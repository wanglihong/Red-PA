//
//  GridViewItem.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "GridViewItem.h"

#define _title_height 20

@implementation GridViewItem

@synthesize delegate = _delegate;
@synthesize titleLabel = _titleLabel;
@synthesize supportCount = _supportCount;
@synthesize joining = _joining;
@synthesize support = _support;
@synthesize index = _index;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = old_red_full;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        UIView *title_bg = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - _title_height, frame.size.width, _title_height)];
        title_bg.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.85];
        [self addSubview:title_bg];
        [title_bg release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - _title_height, frame.size.width, _title_height)];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:1.0 alpha:0.85];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.titleLabel.textColor = background_red;
        [self addSubview:self.titleLabel];
        [self.titleLabel release];
        
        self.joining = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 24, 0, 24, 24)];
        [self addSubview:self.joining];
        [self.joining release];
        
        self.support = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 34, frame.size.height - 14, 10, 10)];
        self.support.image = [UIImage imageNamed:@"support.png"];
        self.support.hidden = YES;
        [self addSubview:self.support];
        [self.support release];
        
        self.supportCount = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 20, frame.size.height - _title_height, 20, _title_height)];
        self.supportCount.textAlignment = UITextAlignmentLeft;
        self.supportCount.backgroundColor = [UIColor clearColor];
        self.supportCount.font = [UIFont systemFontOfSize:12.0];
        self.supportCount.textColor = background_red;
        [self addSubview:self.supportCount];
        [self.supportCount release];
    }
    return self;
}

- (void)setTitleWidth:(float)width
{
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, width, _titleLabel.bounds.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount == 1) {
    
        UIView *hightLight = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        hightLight.backgroundColor = high_light;
        hightLight.tag = 100;
        [self addSubview:hightLight];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    [self performSelector:@selector(cancelHighLight) withObject:nil afterDelay:0.2];
    
    if (touch.tapCount == 1) {
        
        [self performSelector:@selector(handelTouch) withObject:nil afterDelay:0.2];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self performSelector:@selector(cancelHighLight) withObject:nil afterDelay:0.2];
}

- (void)cancelHighLight
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDidStopSelector:@selector(removeHighLight)];
    
    [[self viewWithTag:100] setAlpha:0];
    
    [UIView commitAnimations];
}

- (void)removeHighLight
{
    [[self viewWithTag:100] removeFromSuperview];
}

- (void)handelTouch
{
    if ([_delegate respondsToSelector:@selector(gridViewItem:didSelectedItemAtIndex:)]) {
        [_delegate gridViewItem:self didSelectedItemAtIndex:_index];
    }
}

- (void)dealloc
{
    _delegate = nil;
    
    [super dealloc];
}

@end
